<div dir=rtl>
# Phase 6 — Seats Integration (تكامل المقاعد)

> تاريخ التنفيذ: 2026-07-15
> الحالة: ✅ **القراءة موصولة ومُتحقَّق منها حياً** · الحجز (Stripe) مؤجل v2 (قرار المالك)
> الملفات المرجعية: [integration_map.md](integration_map.md) §3.4 · [v2_deferred_scope.md](v2_deferred_scope.md) §1/§7 · [v1_interim_admin_curation.md](v1_interim_admin_curation.md)

هذا الملف يشرح **بالتفصيل الممل** كل ما تم عمله في Phase 6، والقرارات ورائه، والأدلة الحية.

---

## 1. ما هي Phase 6 والقرار الجوهري

Phase 6 هي ربط شاشة **المقاعد (Seats / Influencer)** بالباك إند الحقيقي. الشاشة role-gated: تظهر للـ **influencer + company** (الشركة تتصفّح لتختار مؤثرين)، والحجز للـ influencer فقط — راجع §7.

المشكلة: **معظم عمليات المقاعد بالباك مبنية على Stripe.** فحص الـ endpoints أظهر انقسامًا طبيعيًا:

| Endpoint | النوع | Stripe؟ | قرار v1 |
| --- | --- | --- | --- |
| `GET /seats?tier=` | قراءة | ❌ لا | ✅ **نوصّلها الآن** |
| `GET /seats/me` | قراءة (تحتاج Bearer) | ❌ لا | ✅ **نوصّلها الآن** |
| `POST /seats/:id/book` | كتابة | ✅ نعم (Checkout Session) | ⏸️ **مؤجل v2** |
| `DELETE /seats/:id/cancel` | كتابة | ✅ نعم (تحرير مقعد مدفوع) | ⏸️ **مؤجل v2** |

**القرار (المالك، 2026-07-15):** شبكة نظيفة — نوصّل **القراءة فقط**، والحجز يبقى preview محلي مؤجل v2. صفر Stripe من التطبيق.

---

## 2. لماذا هذا المنطق (المبرّر)

1. **نفس نمط كل Phase سابقة.** Home (Phase 4) و Services/Categories/Search/Leaderboard (Phase 5) كلها وُصّلت بنفس الطريقة: قراءة حقيقية، لا كتابة مدفوعة.
2. **نفس فلسفة `v1_interim_admin_curation`.** حجز المقعد فعليًا = تعيين `seats.status='booked'` + `influencer_id=<profile>` — وهذا **بالضبط** ما يفعله webhook تبع Stripe (`seat.service.ts:handleStripeWebhook`). أي إن Stripe لا يفعل شيئًا سحريًا، فقط يقلب flag واحد. التطبيق لا يرى Stripe أبدًا — يقرأ الـ flag فقط.
3. **قاعدة المشروع (`project_rules.md` §4):** "الدفع يمر عبر الباك فقط، ولا يُستدعى Stripe من Flutter — والدفع v2 أصلاً."
4. **صدق العرض.** الشبكة كلها متاحة (لا حجوزات بعد) = حالة واقعية وصحيحة لإطلاق جديد، لا بيانات مؤثرين وهمية (يحترم قرار سابق: "لا تعبّي المقاعد").

---

## 3. فحص واقع الداتا بيز (تصحيح معلومة قديمة)

`integration_map.md` كان يقول: "الباك مزروع فيه ~مقعد واحد لكل tier". **هذا صار غلطًا/قديمًا.**

فحص مباشر للـ DB عبر MCP (2026-07-15):

```sql
select tier, count(*) as total,
       count(*) filter (where status = 'available') as available
from public.seats group by tier;
```

النتيجة: **الشبكة الكاملة 144 مقعد مزروعة فعلاً**:

| Tier | العدد | متاح |
| --- | --- | --- |
| gold | 16 | 16 |
| silver | 48 | 48 |
| bronze | 80 | 80 |
| **المجموع** | **144** | **144** |

هذا يطابق **تمامًا** بنية شبكة الموبايل (12×12 = 144، بنطاقات gold/silver/bronze). صُحّحت الملاحظة القديمة في `integration_map.md` §3.4.

---

## 4. الملفات — ماذا تغيّر بالضبط

### 4.1 جديد: `lib/features/seats/data/datasources/seats_remote_data_source.dart`
مصدر بيانات حقيقي يطبّق `SeatsDataSource`، بنفس نمط `leaderboard_remote_data_source.dart` / `services_remote_data_source.dart`:

- `fetchSeats({tier})` → `GET /seats` مع `tier` كـ query param اختياري، يفكّ عبر `SeatsDto.fromJsonFlexible`.
- `fetchMySeats()` → `GET /seats/me` (الـ interceptor يحقن `Bearer` تلقائيًا من `AuthSessionStore`).
- `bookSeat(seatId)` → **يرمي `AppFailure` واضحة عمدًا** بدل استدعاء الـ endpoint الحقيقي:
  ```dart
  throw const AppFailure.unknown(
    message: 'Seat booking is not available in this version.',
  );
  ```
  **لماذا يرمي بدل ما يتصل؟** الحجز Stripe/v2، وواجهة v1 لا تستدعيه أصلاً (زر "Book Now" يفتح شاشة preview محلية بالكامل). لو اتصل بالـ endpoint الحقيقي، لأطلق Checkout Session فعلية + حجز المقعد `pending`. الرمي يجعل حدود v1 صريحة ويمنع أي حجز عرضي.

### 4.2 مُعدّل: `lib/features/seats/data/repositories/seats_repository_impl.dart`
تبديل مصدر البيانات من الـ fake إلى الـ remote:
```dart
// قبل:
dataSource: ref.watch(seatsFakeDataSourceProvider),
// بعد:
dataSource: ref.watch(seatsRemoteDataSourceProvider),
```
(والـ import تغيّر تبعًا). لا تغيير في منطق الـ repository نفسه — الطبقة كانت جاهزة والـ DTO كان يملك `fromJsonFlexible` أصلاً.

### 4.3 مُعدّل: `test/routing/app_routes_smoke_test.dart`
أُضيف override لـ `seatsRepositoryProvider` بالـ fake (نفس نمط home/services/leaderboard) حتى لا تضرب حالة `/seats` الشبكة الحقيقية أثناء الاختبار.

### 4.4 لم تتغيّر (لأنها كانت جاهزة)
- `seats_dto.dart` — كان فيه `SeatsDto.fromJsonFlexible` + `SeatBookingResultDto.fromJsonFlexible` جاهزين.
- `seats_fake_data_source.dart` — بقي كما هو (تستخدمه الاختبارات وشاشة الديمو محليًا).
- `seats_screen.dart` / `seats_controller.dart` — لا تغيير؛ يقرأون من الـ repository الذي صار يوصل للباك.

---

## 5. لماذا `bookSeat` كود ميت في v1 (توضيح مهم)

تتبّع مسار الحجز أثبت أن `repository.bookSeat` **لا يُستدعى إطلاقًا** في v1:
- زر "Book Now" في `_SeatDetailSheet` يفعل `context.push(AppRoutes.seatCheckout(...))` → يفتح `SeatCheckoutPreviewScreen`.
- شاشة الـ preview محلية 100% — زر "الدفع" فيها يعرض snackbar "preview only" ولا يلمس الشبكة.
- دوال الـ controller `requestBooking` / `bookSeatAfterAuth` (التي تستدعي `repository.bookSeat`) **معرّفة لكن غير مستدعاة** من أي شاشة.

لذلك رمي `bookSeat` في المصدر الحقيقي آمن تمامًا ولا يكسر أي مسار حي.

---

## 6. التحقق (الأدلة)

- `flutter analyze` → **نظيف** (No issues found).
- `flutter test` → **182/182 ناجح** (يشمل حالة smoke لـ `/seats`).
- `GET /seats` حي (عبر origin التطبيق) → رجّع **144 مقعد** بالحقول المتوقعة:
  ```json
  {"status":200,"total":144,"byTier":{"bronze":80,"silver":48,"gold":16},
   "sample":{"id":"...","tier":"bronze","price":149,"status":"available","position":1,"profile":null}}
  ```
- **الخطوة البصرية المتبقية (تحتاج login المالك):** شاشة Seats للـ influencer فقط، فرؤيتها بالعين تحتاج تسجيل دخول بحساب influencer (كلمة السر عند المالك، لا يتعامل معها المساعد). المتوقع: شبكة 144 مقعد كلها متاحة، والـ stats strip يعرض "0 مؤثرين / 144 متاح".

---

## 7. الشريط السفلي: الشركة ترى Seats (حُسم بناءً على المنطق التجاري)

أثناء توقّف عملي (rate limit)، عدّل عميل آخر (Antigravity) منطق الشريط السفلي وعمل له commit
(`9349e37 "company now can see influencer seat"`): حوّله من **5 أزرار (Seats XOR Offers)** إلى
**6 أزرار للـ influencer + company** (Offers دائمًا + Seats مُضاف)، وجعل الشركة ترى تاب Seats.

**القرار النهائي (2026-07-15): نُبقي تصميم 6 أزرار — لأنه صحيح تجاريًا.** دليل الأعمال
(`promoo_business_logic_guide.md`) صريح: إخفاء صفحة Seats عن الشركات "خطأ تجاري فادح" لأن
**الشركة تدخل الصفحة لتتصفّح المؤثرين وتتعاقد معهم**. فالمنطق الصحيح:
- **مشاهدة صفحة Seats:** influencer **+ company**.
- **حجز مقعد:** influencer فقط (مضبوط في `account_capabilities.dart:canBookSeat` و
  `seats_screen._onTap`).
- **Offers:** يراها الجميع (سوق).

المتطلّب القديم "Seats للـ influencer فقط" كان **خطأً في المنطق نفسه**، لا في التنفيذ — وصُحّح.

**باگ رافق تعديل Antigravity — أُصلح (2026-07-15):** كان `_selectedIndexForPath` في
`app_router.dart` خريطة 5-tab ساكنة لم تُحدَّث لحالة 6-tab، فكان التظليل خطأ للـ
influencer/company (مثلاً `/services` كان يعطي index 3 = Cup بدل 4 = Services). **الحل:**
`PromooShell` صار يحسب الـ index من قائمة تاباته الواعية بالدور (`selectedShellTabForPath` +
`tabs.indexWhere`)، فيصحّ لـ 5 و 6 أزرار. أُضيف اختبار `test/shell/promoo_shell_tabs_test.dart`
يغطّي الحالتين ويقفل الـ regression. 186/186 اختبار ناجح، analyze نظيف.

---

## 8. المتبقّي لـ v2

- `POST /seats/:id/book` عبر Stripe Checkout (+ PaymentSheet في الموبايل).
- `DELETE /seats/:id/cancel`.
- توسعة/إدارة المقاعد الديناميكية من الداشبورد (راجع `v2_deferred_scope.md` §7).
- (اختياري إن طلب العميل ديمو مقاعد مشغولة) stand-in إداري لتعيين مؤثر لمقعد — لم يُنفّذ (اختار المالك الشبكة النظيفة).

</div>