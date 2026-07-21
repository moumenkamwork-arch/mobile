<div dir="rtl">

# Promoo — خريطة الربط المعتمدة (Backend ↔ Mobile Integration Map)

> **هذا الملف هو المرجع المعتمد لمرحلة الربط (Phase B).** أُعيد توليده بالكامل بفحص مُتحقَّق منه لـ:
>
> - **طبقة البيانات بالموبايل (الحالية):** كل `*_dto.dart` و entities و `*_data_source.dart` (واجهات) و `*_fake_data_source.dart` و `*_repository_impl.dart`، حقلاً بحقل، بالإضافة لملفات السباكة (`app_config.dart`, `auth_session_store.dart`, `locale_controller.dart`, `pubspec.yaml`).
> - **عقد الـ API بالباك إند:** جرد الـ endpoints + الحقول من التوليد الأصلي المُتحقَّق منه (`promoo-api-reference.json` + `src/routes/**` + نتائج `Apis-Resaults/`)، **والباك مقفول ولم يتغيّر** — آخر migration = `034_advisor_security_hardening.sql` (لا يوجد 035 بعد).
>
> **⚠️ ما تغيّر عن نسخة 2026-07-09 (المهم):** أُعيد فحص المشروع بعد: (1) **حذف طبقة الشبكة بالكامل** (frontend-only)، (2) **إنجاز التعريب بالكامل** (محور ربط جديد: `Accept-Language`)، (3) إصلاحات UX (Follow صار toggle محلي فعّال، البروفايل يولّد نسخة لكل id، الشات صار `family`)، (4) تنظيف مكوّنات مكرّرة (طبقة العرض فقط — **لم يمسّ الـ DTOs**، لذا نِسَب التوافق ثابتة). التفاصيل بقسم 0.1.
>
> **القاعدة الذهبية:** لم نعدّل أي ملف بالباك.
>
> آخر تحديث: 2026-07-19 (**Phase 10 — Notifications موصولة** بالباك الحقيقي: `GET /notifications` + مقروء/مقروء-الكل/حذف/تسجيل توكن. هاد كمان صلّح مشكلة كان يواجهها المالك — الضغط على إشعار رسالة كان يعطي 400 لأن القسم كان لسا fake وإشعاره الوهمي يحمل room id وهمي `chat-room-1`). قبلها: **Chat Realtime** عبر Supabase (بعد ما كانت مؤجلة بـ Phase 9) + UX تفاؤلي، Phase 9 (Chat REST)، Phase 8 (Saved)، Phase 7 (Follow)، Phase 6 (Seats قراءة)، Phase 5 (Services/Categories/Search/Leaderboard)، Phase 4 (Home)، Phase 3 (Profile)، Phase 2 (Auth)، Phase 1 (السباكة)، Phase 0 (تصليب التوافق).

---

## 0. الخلاصة التنفيذية (اقرأ هذا أولاً)

**تحديث 2026-07-19:** الربط ماشي ومُتحقَّق حياً — مو مجرد "خطة". جاهز حياً: السباكة (شبكة+interceptor+تخزين آمن)، Auth، Profile (me + تعديل **+ البروفايل العام**)، Home، Categories/Services/Search/Leaderboard، **Seats (قراءة — Phase 6)**، **Follow/Unfollow (Phase 7)**، **Saved (قائمة + إزالة — Phase 8)**، **Chat (Phase 9 REST + Realtime — قائمة/غرفة/إرسال/مقروء + رسائل حيّة عبر Supabase + فتح/إرسال تفاؤلي)**، **Notifications (Phase 10 — قائمة + مقروء + مقروء-الكل + حذف + تسجيل توكن + دفع FCM حي)**، **Upload (Phase 11 — بنية الرفع + avatar موصولين، 2026-07-20)**. الباقي (نشر الإعلان/العرض/الخدمة، cover، زر حفظ من الكروت، قوائم المتابعة) لسا **fake محلي** — التفاصيل أدناه.

**لماذا لا يزال هذا الملف صالحاً وحاسماً لبقية الأقسام؟** لأن العنصر الأثمن لم يُمَس: **الـ DTOs**. كل `*_dto.dart` ما زالت موجودة، **دفاعية جداً** (كل حقل يقبل عدة تهجئات `snake_case`+`camelCase`+aliases، ويقرأ الكائنات المتداخلة `profile`/`category`/`data`/`items`). أي أن **عقد السلك (wire contract) محفوظ**، وإعادة بناء الطبقة البعيدة لبقية الأقسام ستكون **إعادة توصيل منخفضة الاحتكاك**، لا إعادة تصميم.

**الفجوة المتبقية للربط الكامل:**

1. ~~إعادة بناء السباكة~~ ✅ **تمّت (Phase 1).**
2. ~~تخزين التوكن الآمن~~ ✅ **تمّت (Phase 1)** — `SecureAuthSessionStore` عبر `flutter_secure_storage`.
3. ~~تدفق البروفايل الشخصي (me + تعديل)~~ ✅ **تمّت (Phase 3)** — `GET/PUT /profiles/me` موصولة وشغالة حياً. يتبقّى فقط: رفع الأفاتار/الصورة (Upload، Phase 8) وربط الفئة (category picker).
4. ~~Home~~ ✅ **تمّت (Phase 4)** — `GET /home` + تفاصيل عرض/إعلان موصولة وشغالة حياً (بيانات DB حقيقية، معرّبة صح).
5. ~~Categories + Services + Search + Leaderboard~~ ✅ **تمّت (Phase 5)** — موصولة؛ Categories/Services/Leaderboard مُتحقَّقة حياً ببيانات حقيقية، Search كود جاهز بانتظار أول استخدام حي.
6. ~~Seats (قراءة)~~ ✅ **تمّت (Phase 6)** — `GET /seats` + `/seats/me` موصولة، 144 مقعد حقيقي. الحجز (Stripe) مؤجل v2.
7. ~~البروفايل العام + Follow/Unfollow~~ ✅ **تمّت (Phase 7)** — `GET /profiles/:id` (كان موصول من Phase 3)، و `POST/DELETE /follows/:id` + `GET /follows/:id/status` موصولة حياً.
8. ~~Saved (قائمة + إزالة)~~ ✅ **تمّت (Phase 8)** — `GET /saved` (مع hydrate) + `DELETE /saved/:id` موصولة. زر الحفظ من الكروت (`POST /saved`) لسا.
9. ~~Chat (REST + Realtime)~~ ✅ **تمّت (Phase 9 + 2026-07-19)** — قائمة/بدء غرفة/رسائل/إرسال/مقروء موصولة، بالإضافة لـ **Realtime حي عبر Supabase** (رسائل جديدة تظهر فوراً بدون refresh، بادج الأيقونة يتحدث حي) وفتح/إرسال تفاؤلي (UI فوري، الشبكة بالخلفية).
10. ~~Notifications~~ ✅ **تمّت (Phase 10 — 2026-07-19، دفع FCM أُضيف 2026-07-20)** — `GET /notifications` + `PATCH /notifications/:id/read` + `PATCH /notifications/read-all` + `DELETE /notifications/:id` + `POST /notifications/token` موصولة. (صلّحت مشكلة الـ `chat-room-1` 400: الإشعارات صارت حقيقية فتحمل room id حقيقي يفتح المحادثة صح.) دفع FCM صار حي بالكامل (`firebase_core` + `firebase_messaging`)، شوف قسم 3.10 تحت.
11. **أزرار مدعومة بالباك بلا توصيل (بقية الأقسام):** نشر الإعلان/العرض/الخدمة (بيستهلكوا بنية Upload الجاهزة)، غلاف البروفايل (cover — ما في UI بعد)، زر حفظ من الكروت، قوائم المتابِعين/المتابَعين.

**الأرقام:**

| المقياس                                               | القيمة                                 | ملاحظة                                                                                                                                                                                                                                                                                                                                                                  |
| ----------------------------------------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| إجمالي endpoints بالباك                               | **111**                                | 108 موثّقة + 3 admin content مكتشفة بالكود                                                                                                                                                                                                                                                                                                                              |
| endpoints يحتاجها الموبايل بـ v1                      | **~50**                                | القراءة + المصادقة + follow/saved/upload/chat                                                                                                                                                                                                                                                                                                                           |
| endpoints مؤجلة v2 (Stripe/Reports/Featured)          | **~21**                                | القسم 6 — Notifications REST صارت موصولة (Phase 10)، ودفع FCM صار حي أيضاً (2026-07-20) فطلع من هالعدّاد                                                                                                                                                                                                                                                                |
| endpoints للداشبورد فقط                               | **23**                                 | كل `/admin/*`                                                                                                                                                                                                                                                                                                                                                           |
| endpoints أخرى (Auth موسّع، Webhook، إدارة المالك)    | **~11**                                | phone/oauth/otp، webhook، PUT/DELETE للمالك                                                                                                                                                                                                                                                                                                                             |
| **حالة الربط الحالية**                                | **✅ ~31 موصولة حياً + Chat Realtime** | ...السابقة + `GET/POST /chats` · `GET/POST /chats/:id/messages` · `PATCH /chats/:id/read` · اشتراك Supabase Realtime على `messages` · **`GET /notifications` · `PATCH /notifications/:id/read` · `PATCH /notifications/read-all` · `DELETE /notifications/:id` · `POST /notifications/token`** · **`POST /upload/image` + `POST /profiles/me/avatar`**. الباقي (~19) لسا fake (أبرزه: نشر المحتوى، زر الحفظ من الكروت). |
| نسبة التوافق المتوقعة (حقول ↔ حقول)                   | **~89%**                               | ثابتة للأقسام غير الموصولة بعد — الـ DTOs لم تُمَس منذ الفحص الأصلي                                                                                                                                                                                                                                                                                                     |
| صفحات ناقصة بالموبايل                                 | **صفر**                                | كل المسارات تفتح شاشة حقيقية (القسم 7)                                                                                                                                                                                                                                                                                                                                  |
| اختبارات تمرّ حالياً                                  | **193**                                | `flutter analyze` نظيف                                                                                                                                                                                                                                                                                                                                                  |

### 0.1 — ماذا تغيّر منذ النسخة الأصلية (2026-07-09 → 2026-07-13)؟

| التغيير                                                              | الأثر على الربط                                                                                                                                                                                                                                                                                                                                                                                                                            |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **حذف طبقة الشبكة بالكامل** (2026-07-09)                             | كل أعمدة "ربط الآن" السابقة (🟢/🟡) لم تعد تنطبق — **الكل الآن fake محلي**. أي كلام سابق عن "موصول حقيقي" (chat/profile عام/auth) صار تاريخياً. اقرأ كل الحالات كـ "الهدف بعد الربط".                                                                                                                                                                                                                                                      |
| **التعريب اكتمل** (Arabic/English، بلا RTL)                          | **محور ربط جديد بالكامل:** `localeProvider` ([locale_controller.dart](../lib/i18n/locale_controller.dart)) هو المصدر الوحيد، والـ interceptor بمرحلة الربط لازم يحقن `Accept-Language`. الباك يحلّ المحتوى المرجعي server-side عبر `pickLocalized` → يرجّع `name`/`description` مفرد (الـ DTOs تقرأ `name` مع fallback `name_ar/name_en` — **متوافق**). محتوى المستخدمين يبقى بلغته الأصلية (قرار مالك — الإدخال ثنائي اللغة = v2، قسم 6). |
| **`flutter_secure_storage` صارت مُستخدمة** (ثيم + لغة)               | مُثبتة وتعمل على الجهاز → تنفيذ `SecureAuthSessionStore` للتوكن صار أقل مخاطرة. النسخة السابقة قالت "موجودة لكن غير مستخدمة" — لم يعد صحيحاً.                                                                                                                                                                                                                                                                                              |
| **`dio` أُزيلت من pubspec** · `intl`+`flutter_localizations` أُضيفتا | يلزم إعادة إضافة عميل HTTP عند الربط.                                                                                                                                                                                                                                                                                                                                                                                                      |
| **Follow صار toggle محلي فعّال** (كان "coming soon")                 | العمل تغيّر من "توصيل زر معطّل" إلى "استبدال toggle متفائل محلي بـ `POST/DELETE /follows/:id` + `GET status`".                                                                                                                                                                                                                                                                                                                             |
| **البروفايل يولّد نسخة لكل id**                                      | البروفايل العام قابل للعرض بأي id ديمو؛ الربط يستبدل التوليد بـ `GET /profiles/:id`.                                                                                                                                                                                                                                                                                                                                                       |
| **الشات صار `NotifierProvider.family`** بـ roomId                    | لا أثر على الحقول؛ البنية أصبحت صحيحة للربط (كل غرفة controller مستقل).                                                                                                                                                                                                                                                                                                                                                                    |
| **تنظيف مكوّنات مكرّرة + حذف 7 ملفات ميتة بـ seats**                 | طبقة عرض فقط — **صفر أثر على DTOs/الربط**.                                                                                                                                                                                                                                                                                                                                                                                                 |

</div>

---

## 1. جرد الـ API الكامل — 111 endpoint

| #   | Module              | العدد   | Mobile v1؟ | ملاحظات                                                                                                               |
| --- | ------------------- | ------- | ---------- | --------------------------------------------------------------------------------------------------------------------- |
| 1   | Health              | 1       | ➖         | `GET /health` — بنية تحتية                                                                                            |
| 2   | Auth                | 11      | 4          | login/email, register/email, refresh, logout؛ **7 مؤجلة** (phone×2, oauth, verify-otp, forgot, reset, delete-account) |
| 3   | Profiles            | 7       | 6          | me(GET/PUT), avatar, cover, :id, :id/media؛ verify-request = v2                                                       |
| 4   | Follows             | 5       | 5          | كلها v1                                                                                                               |
| 5   | Offers              | 7       | ~4         | list/detail/by-profile/create v1؛ PUT/DELETE(مالك), feature(Stripe)=v2                                                |
| 6   | Ads                 | 8       | ~4         | active/impression/click/create v1؛ toggle/stats/PUT(مالك)=لاحقاً                                                      |
| 7   | Services            | 5       | 5          | GET×2 قراءة؛ POST/PUT/DELETE للمزوّد/الشركة                                                                           |
| 8   | Seats               | 4       | 2          | GET, GET me = v1؛ **book/cancel (Stripe) = v2**                                                                       |
| 9   | Stories             | 5       | ~2         | GET feeds v1 (عبر /home)؛ POST/DELETE = v2                                                                            |
| 10  | Saved Items         | 3       | 3          | كلها v1                                                                                                               |
| 11  | Home & Leaderboard  | 2       | 2          | كلاهما v1 (أساسي)                                                                                                     |
| 12  | Subscriptions       | 4       | 0          | **كلها v2** (Stripe؛ `POST /subscriptions` = خطأ 500 مفتوح)                                                           |
| 13  | Chats               | 6       | 6          | كلها v1 (الشات ميزة معتمدة)                                                                                           |
| 14  | Notifications       | 5       | 5          | ✅ موصولة (Phase 10): list/read/read-all/delete/token. دفع FCM صار حي أيضاً (2026-07-20).                             |
| 15  | Upload              | 4       | 4          | لازم لِـ avatar/cover/ad-image                                                                                        |
| 16  | Search & Categories | 3       | 3          | كلها v1                                                                                                               |
| 17  | Featured            | 2       | 0          | **v2** (Stripe)                                                                                                       |
| 18  | Payments            | 3       | 0          | **v2** (Stripe)                                                                                                       |
| 19  | Reports             | 2       | 0          | **v2** (لا واجهة تبليغ)                                                                                               |
| 20  | Admin               | 23      | 0          | **للداشبورد فقط**                                                                                                     |
| 21  | Webhooks            | 1       | 0          | Stripe→server                                                                                                         |
|     | **الإجمالي**        | **111** | **~50 v1** |                                                                                                                       |

> **3 endpoints بالكود غير موثّقة بالـ reference JSON:** `GET /admin/content/{offers,ads,services}` — للداشبورد، لا تؤثر على الموبايل.

---

## 2. حقيقة المصادقة والسباكة (الأهم للربط)

<div dir="rtl">

| العنصر                         | الحالة الفعلية الآن                                                                                                                                                                                                                                                                                                                           | ما يحتاجه الربط                                                                     |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **طبقة الشبكة (Dio/client)**   | ✅ **Phase 1 (2026-07-13):** أُعيد بناؤها بالكامل — [api_client.dart](../lib/core/network/api_client.dart) + [api_response.dart](../lib/core/network/api_response.dart)، `dio: ^5.9.2` بالـ pubspec، `baseUrl` بـ `AppConfig` (`--dart-define PROMOO_BASE_URL`). يرمي `AppFailure` مباشرة (لا `ApiException` منفصل).                          | جاهزة — أول مستهلك حقيقي (`auth_remote_data_source.dart`) بالـ Phase 2.             |
| **interceptor للتوكن + اللغة** | ✅ **Phase 1:** `QueuedInterceptorsWrapper` يحقن **`Authorization: Bearer <token>`** من `AuthSessionStore` + **`Accept-Language: <locale>`** من `localeProvider` على كل طلب، + auto-refresh عند 401 (عبر `Dio` ثانٍ بلا interceptors، لتفادي التكرار).                                                                                        | جاهزة — لم تُختبر بعد ضد باك حقيقي (لا يوجد مستهلك حتى Phase 2).                    |
| **تخزين التوكن**               | ✅ **Phase 1:** `SecureAuthSessionStore` عبر `flutter_secure_storage` ([auth_session_store.dart](../lib/features/auth/data/session/auth_session_store.dart)) — تسلسل JSON، best-effort مطابق لـ `LocaleController`. `InMemoryAuthSessionStore` بقي كـ test double صريح (اكتُشف أن قراءة الـ plugin الحقيقي لا تُحل أبداً داخل `testWidgets`). | جاهزة.                                                                              |
| **`Accept-Language`**          | ✅ المصدر جاهز — `localeProvider` مصدر وحيد، والـ DTOs المرجعية تقرأ الحقل الموحّد `name`.                                                                                                                                                                                                                                                    | حقن الهيدر بالـ interceptor فقط.                                                    |
| **الـ envelope**               | ✅ منطق التحليل الدفاعي بالـ DTOs يفهم `{ success, data, message, meta? }` أو كائن/قائمة مجرّدة.                                                                                                                                                                                                                                              | متوافق — يُعاد ربطه مع العميل الجديد.                                               |
| **`PROMOO_USE_MOCKS`**         | ➖ **أُزيل** — لم يعد موجوداً.                                                                                                                                                                                                                                                                                                                | لا حاجة له؛ الربط يستبدل الـ fake data source بـ remote مباشرةً feature بـ feature. |

> **القاعدة الحاكمة:** ابدأ الربط من إعادة بناء السباكة (شبكة + interceptor: Bearer + Accept-Language + secure store + refresh). **كل الـ endpoints المحمية والمحتوى المُعرّب يعتمدان عليها.**

</div>

---

## 3. خريطة الربط لكل قسم (Section → API)

> **الحالة الحالية لكل الأقسام: غير مربوط، بيانات محلية (fake).** الأعمدة أدناه تصف **الهدف بعد الربط**: الـ endpoint · حالة الباك (من الاختبار الحيّ الأصلي) · التوافق المتوقّع (حقول، ثابت لأن الـ DTOs لم تتغيّر) · العمل المطلوب.

### 3.1 — Auth (Login / Register) — ✅ موصول (Phase 2، 2026-07-13)

| Endpoint               | Method | Backend                 | توافق | الحالة                                                                                                        |
| ---------------------- | ------ | ----------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| `/auth/login/email`    | POST   | ✅200                   | 95%   | ✅ موصول — `auth_remote_data_source.dart`. الجلسة تُحفظ بـ `SecureAuthSessionStore`.                          |
| `/auth/register/email` | POST   | ✅(⚠️rate-limit بالتست) | 95%   | ✅ موصول. **تحقّق حي:** تسجيل حقيقي وصل للباك، وخطأ تحقّق (إيميل نطاق محجوز) رجع بالشكل الصحيح وظهر بالواجهة. |
| `/auth/refresh`        | POST   | ✅200                   | 90%   | ✅ موصول داخل الـ 401-interceptor (`api_client.dart`) — لسا ما اختُبر حياً (لا حالة 401 حقيقية جربت بعد).     |
| `/auth/logout`         | POST   | ✅200                   | 100%  | ✅ موصول — يمسح الجلسة الآمنة.                                                                                |
| مؤجل v2                | —      | —                       | —     | phone login/register, oauth (google/apple), verify-otp, forgot/reset-password, delete-account.                |

### 3.2 — Home (شاشة واحدة تجيب كل شي)

`GET /home` يرجّع: `stories[] · categories[] · featured_profiles[] · promoo_of_the_day · latest_offers[] · services[] · ads[]`. الـ `HomeContentDto` ([home_content_dto.dart](../lib/features/home/data/dto/home_content_dto.dart)) يقرأ **نفس المفاتيح بالضبط** (مع aliases).

| القسم                | مصدره                                  | توافق | ملاحظة حقول (مُتحقَّقة الآن)                                                                                                                                    |
| -------------------- | -------------------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Stories              | `stories[]`                            | 80%   | ✅ الـ DTO أصلاً يقرأ `items[]` دفاعياً (وأيضاً عنصر مفرد) — لا شغل مطلوب. لسا ما شفنا ستوري حقيقية بالتست الحي (الباك رجّع `stories: []` — لا بيانات، مو خطأ). |
| Services (مصغّرة)    | `services[]`                           | 88%   | ✅ **موصول (Phase 4)** — تحقّق حي رجّع `services: []` (لا خدمات فعالة بالـ DB حالياً — حالة فاضية صحيحة).                                                       |
| Top Offers / For You | `latest_offers[]`+`ads[]`              | 85%   | ✅ **موصول (Phase 4)، `media_urls[0]` انحلّت (F0.1).** تحقّق حي: `latest_offers: []` (فاضي بصحة)، `ads` رجّعت إعلان حقيقي واحد وظهر صح بالواجهة.                |
| Categories           | `categories[]`                         | 90%   | ✅ **موصول (Phase 4) + مُتحقَّق حياً** — `name` رجعت "Marketing/Design/..." بالإنكليزي صح عبر `pickLocalized` (Phase 0).                                        |
| Promoo of the Day    | `promoo_of_the_day`                    | 85%   | ✅ **موصول (Phase 4)** — تحقّق حي: كانت `null`، والفرونت سقط صح لأول `ad` (badge "Promoted") تماماً كما مصمّم.                                                  |
| تفاصيل عرض/إعلان     | `GET /offers/:id` أو `GET /ads/active` | 85%   | ✅ **موصول (Phase 4) + مُتحقَّق حياً** — فتح تفاصيل الإعلان الحقيقي نجح (`GET /ads/active` + فلترة محلية بالـ id).                                              |

**الحالة:** Phase 4 خلصت بالكامل (2026-07-14) — `home_remote_data_source.dart` + `home_repository_impl.dart` موصولة، 181 اختبار ✅.

### 3.3 — Services Tab + Service Detail — ✅ موصول (Phase 5، 2026-07-14)

| Endpoint                        | Method | Backend | توافق | ملاحظة                                                                                     |
| ------------------------------- | ------ | ------- | ----- | ------------------------------------------------------------------------------------------ |
| `GET /categories`               | GET    | ✅200   | 90%   | ✅ **موصول + مُتحقَّق حياً** — رجعت `name` محسومة صح.                                      |
| `GET /services?category_id=&q=` | GET    | ✅200   | 88%   | ✅ **موصول + مُتحقَّق حياً** — `[]` حالياً (لا خدمات فعالة بالـ DB، حالة صحيحة).           |
| `GET /services/:id`             | GET    | ✅200   | 88%   | ✅ **موصول** (نفس `services_remote_data_source.dart`). مطابق. لا `location` للخدمة (فاضي). |
| `GET /categories/:id/content`   | GET    | ✅200   | —     | غير مستخدم؛ الفرونت يفلتر `/services` بدلاً منه.                                           |

### 3.4 — Influencer / Seats — ✅ القراءة موصولة (Phase 6، 2026-07-15)

> **تصحيح منطقي (2026-07-15):** شاشة Seats تظهر للـ **influencer + company** (لا influencer فقط — راجع `promoo_business_logic_guide.md`: الشركة تتصفّح المقاعد لتختار مؤثرين وتتعاقد معهم؛ **الحجز** للـ influencer فقط). الشريط السفلي role-aware: user/service_provider/guest يشوفوا 5 أزرار (Offers بلا Seats)؛ influencer/company يشوفوا 6 أزرار (Offers **و** Seats). الـ index يُحسب ديناميكياً من قائمة التابات (`selectedShellTabForPath` في `promoo_shell.dart`).
>
> **تحديث Phase 6 (2026-07-15):** القراءة موصولة فعلياً (`seats_remote_data_source.dart` + ربط `seatsRepositoryProvider`)، الحجز (Stripe) يبقى مؤجل v2 — قرار المالك. راجع [phase_6_seats_integration.md](phase_6_seats_integration.md). **تصحيح فجوة قديمة:** الملاحظة السابقة كانت تقول "الباك مزروع ~مقعد واحد لكل tier" — **هذا صار غلط/قديم**؛ فحص مباشر للـ DB (2026-07-15) أظهر الشبكة الكاملة **144 مقعد مزروعة فعلاً** (16 ذهبي + 48 فضي + 80 برونزي)، كلها `available` حالياً، بنفس بنية شبكة الموبايل بالضبط. `GET /seats` الحي رجّع 144 مقعد بالحقول المتوقعة (`tier/price/status/position/profile`).

| Endpoint                   | Method | Backend        | توافق    | ملاحظة                                                                                                                                          |
| -------------------------- | ------ | -------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET /seats?tier=`         | GET    | ✅200          | 90% حقول | ✅ **موصول + مُتحقَّق حياً (Phase 6)** — رجّع 144 مقعد حقيقي، كلها متاحة (لا مؤثرين محجوزين بعد — حالة صحيحة، لا بيانات وهمية). الحقول متطابقة. |
| `GET /seats/me`            | GET    | ✅200          | 90%      | ✅ **موصول (Phase 6)** — يحتاج Bearer (الـ interceptor يحقنه تلقائياً). يرجّع مقاعد المستخدم المحجوزة (فاضي بالـ v1، لا حجز).                   |
| `POST /seats/:id/book`     | POST   | ✅200 (Stripe) | —        | **مؤجل v2** — الـ remote source يرمي failure واضح بدل ما يطلق Stripe (غير مستدعى بالـ v1 أصلاً؛ زر Book Now يفتح preview محلي فقط).             |
| `DELETE /seats/:id/cancel` | DELETE | ✅200          | —        | مؤجل v2.                                                                                                                                        |

### 3.5 — Cup / Leaderboard — ✅ موصول (Phase 5، 2026-07-14)

| Endpoint                              | Method | Backend | توافق   | ملاحظة                                                                                                                                                                             |
| ------------------------------------- | ------ | ------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET /leaderboard?page=&limit=&type=` | GET    | ✅200   | **98%** | ✅ **موصول + مُتحقَّق حياً** — رجع ترتيب حقيقي بـ 3 بروفايلات حقيقية (رقم 3 كان حساب المالك نفسه، بنفس الـ bio المحفوظ بـ Phase 3 — تأكيد إضافي إنو الحفظ فعلاً دائم عبر الجلسات). |

### 3.6 — Profile (بروفايلي + العام + التعديل) — ✅ "أنا + تعديل" موصولة (Phase 3، 2026-07-13)

| Endpoint                              | Method | Backend | توافق | الحالة                                                                                                                                                                                                                                                                  |
| ------------------------------------- | ------ | ------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET /profiles/:idOrUsername`         | GET    | ✅200   | 88%   | ✅ **موصول + مُتحقَّق حياً (تصحيح 2026-07-15).** الملاحظة القديمة "لسا fake" **صارت غلط** — `getProfile` مربوط على remote من Phase 3 (`profile_remote_data_source.dart:fetchProfile`). تحقّق حي: `GET /profiles/<owner id>` رجّع 200 والاسم الحقيقي "Moumen Alkamsheh". |
| `GET /profiles/me`                    | GET    | ✅200   | 88%   | ✅ **موصول** — `profile_remote_data_source.dart`. **تحقّق حي:** حساب حقيقي أظهر اسمه الحقيقي/0 متابع/حقول فاضية (مو بيانات Saffron Social الوهمية).                                                                                                                     |
| `PUT /profiles/me`                    | PUT    | ✅200   | 90%   | ✅ **موصول** (كان stub ثابت يرجّع فشل فوراً — أُصلح). **تحقّق حي:** حفظ bio+location حقيقي رجع 200 مع العدّادات، وتحميل الصفحة من جديد أظهر القيم المحفوظة (استمرارية حقيقية، مو UI متفائل فقط). Name/Bio/Location فقط بالشاشة حالياً — لا category/website.            |
| `POST /profiles/me/avatar` · `/cover` | POST   | ✅200   | 85%   | 🔄 **avatar موصول (Phase 11، 2026-07-20)** — زر/badge "Change profile photo" صار يفتح المعرض → يرفع (`bucket=avatars`, `related_to=profile`) → `POST /profiles/me/avatar` → يحدّث البروفايل. **cover لسا** (ما في UI غلاف بشاشة التعديل بعد).                                    |
| `GET /profiles/:id/media`             | GET    | ✅200   | —     | ❌ غير مستخدم بعد؛ الميديا تُقرأ من كائن البروفايل حالياً.                                                                                                                                                                                                              |

**تحديث إحصائيات البروفايل (كان تنبيهاً، انحلّ جزئياً بـ Phase 0):** الباك صار يرجّع `followers_count` (موجود من قبل) + `following_count`+`posts_count` (أُضيفا Phase 0، `profile.service.ts withCounts`) على GET **و** PUT (كانت PUT ناقصة العدّادات — أُصلحت بـ Phase 3). **`views_count` يبقى مفقود** (لا مصدر بالـ DB — مؤجّل v2 نهائياً، قرار مالك موثّق بـ `v2_deferred_scope.md` §6). `ProfileStatsDto` يقرأ الكل دفاعياً فيرجع 0 لـ views تلقائياً — سلوك صحيح ومقصود.

### 3.7 — Follow / Unfollow — ✅ موصول (Phase 7، 2026-07-15)

| Endpoint                                       | Method | Backend | توافق | ملاحظة                                                                                                                                                        |
| ---------------------------------------------- | ------ | ------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `POST /follows/:profileId`                     | POST   | ✅200   | 90%   | ✅ **موصول** — زر Follow صار طلب حقيقي (optimistic + revert عند الفشل). أُضيف للـ `ProfileDataSource/Repository` + `profile_controller.toggleFollow`.         |
| `DELETE /follows/:profileId`                   | DELETE | ✅200   | 90%   | ✅ **موصول** — Unfollow.                                                                                                                                      |
| `GET /follows/:profileId/status`               | GET    | ✅200   | 90%   | ✅ **موصول** — يُجلب عند فتح بروفايل شخص آخر (إذا مسجّل دخول) لتهيئة حالة الزر. تحقّق حي: بدون توكن رجّع 401 (auth-gated صح). البارس يقرأ `data.isFollowing`. |
| `GET /follows/followers/:id` · `following/:id` | GET    | ✅200   | 85%   | ⏳ قوائم المتابعين/المتابَعين لسا ديمو محلي — تُربط لاحقاً (Following screen).                                                                                |

### 3.8 — Saved Items — ✅ موصول (Phase 8، 2026-07-15)

| Endpoint            | Method | Backend | توافق | ملاحظة                                                                                                                                                                                                                                                                                                                                 |
| ------------------- | ------ | ------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET /saved`        | GET    | ✅200   | 90%   | ✅ **موصول** — **الفجوة القديمة (بلا تفاصيل) انحلّت بالباك Phase 0:** الباك صار يعمل hydrate ويرجّع `item` الكامل (offer/service/ad/profile) لكل صف — لا N+1. شريحة جديدة `lib/features/saved/` (DTO polymorphic + controller). تحقّق حي: بدون توكن 401 (auth-gated صح). زُرع صف saved للمالك للعرض. الضيف → حالة فاضية (بلا استدعاء). |
| `DELETE /saved/:id` | DELETE | ✅200   | 90%   | ✅ **موصول** — إزالة من شاشة Saved (optimistic + revert). ياخد **saved-row id** مو item_id.                                                                                                                                                                                                                                            |
| `POST /saved`       | POST   | ✅201   | 90%   | ⏳ زر الحفظ من كروت العروض/الخدمات لسا غير مربوط (يحتاج bookmark buttons عبر التطبيق) — لاحقاً.                                                                                                                                                                                                                                        |

### 3.9 — Chat (ميزة v1) — ✅ موصول REST + Realtime (Phase 9 يوم 2026-07-15، Realtime يوم 2026-07-19)

> **Phase 9:** الـ REST موصول عبر `chat_remote_data_source.dart` + ربط `chatRepositoryProvider`. الـ Bearer يُحقن تلقائياً بالـ interceptor.
> **2026-07-19:** أضيف Supabase Realtime — `chat_realtime_service.dart` (`RealtimeClient` مباشر، بدون `SupabaseClient`/`GoTrueClient` الكاملة لتفادي auto-refresh timer غير المستخدم) يشترك بـ `postgres_changes` INSERT على جدول `messages`؛ RLS (مُتحقَّق سابقاً أنها تحصر كل مستخدم بغرفه فقط) تكفي فلترة الاشتراك بلا حاجة لفلتر إضافي. `ChatController` يعيد التحميل عند تغيّر حالة الدخول (كان السبب وراء اختفاء بادج الأيقونة دائماً) ويحدّث القائمة عند أي رسالة حيّة؛ `ChatRoomController` يلحق الرسائل الحيّة مباشرة بالغرفة المفتوحة. بالإضافة: **فتح محادثة جديدة وإرسال رسالة صارا تفاؤليين (optimistic)** — الفتح ينتقل فوراً (`/chats/new?participant=`) والحل الفعلي لل room id يصير بالخلفية، والإرسال يظهر فوراً بحالة "Sending" ثم يتحول لحالة نهائية. تحقّق حي بحسابين حقيقيين وتابين: رسالة أُرسلت من حساب عبر API مباشر ظهرت بالتاب التاني بدون أي تفاعل (تأكيد بصري + شبكي: `PATCH .../read` انطلق تلقائياً بدون `GET messages` مرافق)، وبادج الأيقونة بالهيدر تحول من بلا بادج لـ "1" حي.

| Endpoint                           | Method            | Backend | توافق | ملاحظة                                                                                                                        |
| ---------------------------------- | ----------------- | ------- | ----- | ----------------------------------------------------------------------------------------------------------------------------- |
| `GET /chats`                       | GET               | ✅200   | 88%   | ✅ **موصول** — قائمة الغرف `{room, otherParticipant, lastMessage, unreadCount}`. يُعاد تحميلها عند الدخول وعند أي رسالة حيّة. |
| `POST /chats`                      | POST              | ✅201   | 85%   | ✅ **موصول** — `{participant_id}` → `{room, participant, isNew}`. يُستدعى بالخلفية عند فتح محادثة جديدة (UI فوري قبله).       |
| `GET/POST /chats/:roomId/messages` | GET/POST          | ✅      | 88%   | ✅ **موصول** — قراءة/إرسال الرسائل (`family` بـ `{roomId, participantId}`). الإرسال تفاؤلي محلياً.                            |
| `PATCH /chats/:roomId/read`        | PATCH             | ✅200   | 90%   | ✅ **موصول** — تعليم الغرفة مقروءة، يُستدعى تلقائياً أيضاً عند وصول رسالة حيّة والغرفة مفتوحة.                                |
| **Realtime**                       | Supabase Realtime | —       | —     | ✅ **تمّت (2026-07-19)** — `postgres_changes` INSERT على `messages` عبر `RealtimeClient` مباشر؛ RLS موجودة مسبقاً وتكفي.      |

### 3.10 — Notifications (✅ موصولة — Phase 10, 2026-07-19)

| Endpoint                        | Method | Backend | ملاحظة                                                                                                                                            |
| ------------------------------- | ------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET /notifications`            | GET    | ✅      | موصول عبر `notifications_remote_data_source.dart`. الشاشة معرّبة والعدّاد بصيغة plural صحيحة.                                                     |
| `PATCH /notifications/:id/read` | PATCH  | ✅      | موصول (تعليم إشعار كمقروء).                                                                                                                       |
| `PATCH /notifications/read-all` | PATCH  | ✅      | موصول (تعليم الكل كمقروء).                                                                                                                        |
| `DELETE /notifications/:id`     | DELETE | ✅      | موصول (حذف إشعار).                                                                                                                                |
| `POST /notifications/token`     | POST   | ✅      | ✅ **موصول (2026-07-20)** — `firebase_messaging` مضافة والتوكن يُرسل للباك إند عند تسجيل الدخول لاستقبال الـ Push. |
| ملاحظة                          | —      | —       | إشعارات الرسائل تحمل `data.room_id` حقيقي → الضغط عليها يفتح المحادثة الصحيحة (صلّح خطأ `chat-room-1` 400 الذي سببه القديم الـ fake data source). |

### 3.11 — إنشاء المحتوى (Add Ad / Offer / Service)

| Endpoint         | Method | Backend | Role                      | ملاحظة                                                                                                                          |
| ---------------- | ------ | ------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `POST /ads`      | POST   | ✅201   | company, influencer       | wizard 4 خطوات؛ الحقول تطابق `createAdSchema` (المطلوبة `ad_type/budget/target_url` تحتاج defaults). زر Create AD "next phase". |
| `POST /offers`   | POST   | ✅201   | company, service_provider | شاشة `AddOfferScreen` موجودة (role-gated). "next phase".                                                                        |
| `POST /services` | POST   | ✅201   | service_provider, company | شاشة `AddServiceScreen` موجودة (role-gated). "next phase".                                                                      |

> الشاشات الثلاث تتشارك chrome عبر `add_form_widgets.dart` (عرض فقط — لا أثر على الحقول)، وتُظهرها `accountCapabilitiesProvider` حسب `account_type`. راجع القسم 5.

> **2026-07-21 — تصحيحات حية بعد اختبار FCM حقيقي على جهاز:** أيقونة إشعار حقيقية (`ic_stat_promoo.xml`، بدل صورة blob)؛ الضغط عالإشعار صار يفتح الوجهة الصحيحة فعلياً (`_handleMessageTap` كان `print()` بس)؛ `chatRoomControllerProvider`/`serviceDetailControllerProvider`/`homeContentDetailControllerProvider` صاروا `.autoDispose` (كانوا بيضلوا محفوظين بالذاكرة للأبد فما بيرجعوا يجيبوا بيانات جديدة)؛ وصلّح bug عميق بـ `_disposed` كان بيوقف تحديث Home/Services نهائياً بعد أول تبديل لغة. التفاصيل الكاملة بـ [MEMORY_BANK.md](MEMORY_BANK.md).

### 3.12 — Upload (شرط لِـ avatar/cover/ad-image) — 🔄 البنية التحتية موصولة (Phase 11، 2026-07-20)

**البنية التحتية جاهزة ومستخدمة:** `image_picker` مضافة؛ feature slice `lib/features/upload/`
(entity `UploadedMedia` + enums `UploadBucket`/`UploadRelatedTo` توثّق التنظيم المعتمد،
`UploadRepository.uploadImage` يبني `FormData` multipart بحقل `file`). النمط **خطوتين** (طبق
الأصل عن `ImageUpload` بالداشبورد): اختيار محلي → `POST /upload/image` يرجّع `file_url` →
حفظ الرابط على الكيان عبر endpoint مستقل. **أول مستهلك حي: avatar** (شوف صف البروفايل فوق).
المتبقي: cover + صور الإعلان/العرض/الخدمة (تُوصَل مع مرحلة النشر Phase 12).

| Endpoint                            | Method | Backend           | ملاحظة                                                                 |
| ----------------------------------- | ------ | ----------------- | ---------------------------------------------------------------------- |
| `POST /upload/image` · video · file | POST   | ✅201 (multipart) | 🔄 **image موصول** (`UploadRemoteDataSource`) — حقل `file` + `bucket` + `related_to`. video/file لسا (مؤجّلين لحين الحاجة). |
| `DELETE /upload/:id`                | DELETE | ✅200             | ❌ لسا — يُوصَل مع حذف الميديا لاحقاً.                                  |

> ⚠️ **مصيدة وثّقناها (التوثيق `Apis-Resaults/15 - Upload/Upload.md` ناقص/مضلِّل):** (1) حقل
> `bucket` **غير مذكور بالتوثيق** لكن الكود الفعلي بياخده وهو أساسي. (2) الأفاتار/الغلاف **لا
> يُحفظان عبر `PUT /profiles/me`** (الـ `updateProfileSchema` ما فيه `avatar_url`/`cover_url`) —
> إلهم endpoints مستقلة `POST /profiles/me/avatar` و`/cover`. التفاصيل: قسم "منطق الرفع" بأعلى
> هالملف والـ enums بالكود.

### 3.13 — Search — ✅ الكود موصول (Phase 5، 2026-07-14)

| Endpoint                 | Method | Backend | توافق | ملاحظة                                                                                                                                                                                                                                                                                                                     |
| ------------------------ | ------ | ------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET /search?q=&type=&…` | GET    | ✅200   | 92%   | ✅ **موصول** (`search_remote_data_source.dart`، نفس نمط الباقي). يرجّع `{profiles[],offers[],ads[],services[]}` مجمّعة. `type` + `meta` (pagination) مدعومان. **لم يُختبر حياً بعد** (الشاشة ما بتطلق طلب إلا بعد كتابة نص — التفاعل الحي تعثّر بمشكلة تقنية بأداة المتصفح، مو بمشكلة كود؛ يُتحقّق أول ما يُستخدم فعلياً). |

---

## 4. نسبة التوافق حقلاً بحقل (Compatibility) — ثابتة

<div dir="rtl">

النِّسَب لم تتغيّر عن الفحص الأصلي لأن **الـ DTOs لم تُمَس** (التعريب والتنظيف كانا بطبقة العرض/الدومين فقط). التوافق عالٍ لأن التطبيق بُني backend-first والـ DTOs دفاعية.

</div>

| القسم                    | Endpoints | توافق    | أهم فجوة                                                                                  |
| ------------------------ | --------- | -------- | ----------------------------------------------------------------------------------------- |
| ✅ Login / Register      | 2         | **95%**  | **موصول (Phase 2)** — refresh لسا ما اختُبر حياً                                          |
| ✅ Home (كامل)           | 3         | **85%**  | **موصول (Phase 4)** — تحقّق حي؛ لا ستوري/خدمات/عروض حالياً بالـ DB (حالة فاضية، مو خطأ)   |
| ✅ Search                | 1         | **92%**  | **موصول (Phase 5)** — الكود جاهز، لسا بلا تحقّق حي (يحتاج نص مكتوب لإطلاق الطلب)          |
| ✅ Services + Detail     | 3         | **88%**  | **موصول (Phase 5)** — تحقّق حي؛ لا `location` للخدمة                                      |
| ✅ Leaderboard           | 1         | **98%**  | **موصول (Phase 5) + مُتحقَّق حياً** — بيانات حقيقية                                       |
| ✅ Seats (قراءة)         | 2         | **90%**  | **موصول (Phase 6)** — `GET /seats`+`/seats/me` حي، 144 مقعد حقيقي؛ الحجز (Stripe) مؤجل v2 |
| Profile (عام)            | 2         | **88%**  | ❌ لسا fake — `GET /profiles/:id` غير موصول                                               |
| ✅ Profile (أنا + تعديل) | 3         | **90%**  | **موصول (Phase 3)** — يتبقّى الأفاتار (Upload) والفئة فقط                                 |
| Follow/Unfollow          | 5         | **88%**  | toggle محلي بدل الطلب الحقيقي                                                             |
| Saved                    | 3         | **75%**  | الباك يرجّع id فقط بلا تفاصيل                                                             |
| ✅ Chat                  | 6         | **88%**  | **موصول REST + Realtime (2026-07-19)**                                                    |
| Upload                   | 4         | **80%**  | حقول الرفع "next phase"                                                                   |
| Add Ad/Offer/Service     | 3         | **85%**  | defaults لـ ad_type/budget؛ التوصيل الفعلي                                                |
| **الإجمالي المرجّح**     | **~50**   | **≈89%** |                                                                                           |

---

## 5. تعارض Add Offer vs Add Ad — ✅ مُعالَج بالفرونت

<div dir="rtl">

التعارض الأصلي (صف واحد "Add New Offer" يفتح wizard الإعلان → أسماء/صلاحيات متضاربة → 403 محتمل) **حُلّ**: صار في 3 شاشات منفصلة (`add_offer_screen.dart` · `add_service_screen.dart` · Ad wizard)، و`accountCapabilitiesProvider` ([account_capabilities.dart](../lib/features/profile/presentation/controllers/account_capabilities.dart)) يقرأ `account_type` ويُظهر الإنشاءات المسموحة فقط (Offer=company/service_provider · Ad=company/influencer · Service=company/service_provider · guest/user=لا شيء).

**يتبقّى للربط:** يعتمد على `account_type` الحقيقي من الجلسة بعد ربط الـ auth (register يحدّده)؛ وتوصيل أزرار الـ "next phase" الثلاثة بـ `POST /ads|/offers|/services` (تعتمد على Upload + Auth).

</div>

---

## 6. الأقسام المؤجلة لـ v2 (لا تُربط الآن)

| القسم                                 | Endpoints                                             | السبب                                                                                                                                                                              |
| ------------------------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 💳 Subscriptions                      | `GET/POST /subscriptions*` (4)                        | Stripe؛ **`POST /subscriptions` = خطأ 500 مفتوح**.                                                                                                                                 |
| 💰 Payments                           | `/payments/*` (3)                                     | Stripe.                                                                                                                                                                            |
| ⭐ Featured                           | `/featured*` (2)                                      | Stripe.                                                                                                                                                                            |
| 🔔 Notifications                      | ~~`/notifications*` (5)~~                             | ✅ موصولة (Phase 10). دفع FCM صار حي أيضاً (2026-07-20).                                                                                                                           |
| 🚩 Reports                            | `/reports*` (2)                                       | لا واجهة تبليغ بـ v1.                                                                                                                                                              |
| 🪑 Seat booking/cancel                | `POST /seats/:id/book`, `DELETE …/cancel` (2)         | Stripe checkout.                                                                                                                                                                   |
| 📸 Stories create/delete              | `POST /stories`, `DELETE /stories/:id` (2)            | إنشاء القصص display-only.                                                                                                                                                          |
| 🔐 Auth الموسّع                       | phone×2, oauth, verify-otp, forgot, reset, delete (7) | email-only بـ v1.                                                                                                                                                                  |
| 🛡️ Admin                              | `/admin/*` (23)                                       | للداشبورد فقط.                                                                                                                                                                     |
| 🔗 Webhook                            | `/webhooks/stripe` (1)                                | Stripe→server.                                                                                                                                                                     |
| 📦 Content Packages                   | —                                                     | لا كيان بالباك (خطط 99/149/249 محذوفة migration 032). شاشة Packages display-only.                                                                                                  |
| 🌐 **إدخال محتوى مستخدم ثنائي اللغة** | —                                                     | **جديد (قرار مالك 2026-07-12):** محتوى المستخدمين يبقى بلغة واحدة كما كُتب. الإدخال/العرض ثنائي اللغة = v2 (يحتاج أعمدة `_ar/_en` لكل حقل بالباك). راجع `v2_deferred_scope.md` §9. |

---

## 7. الصفحات الناقصة — التحقّق النهائي

<div dir="rtl">

**النتيجة: لا توجد صفحات ناقصة.** كل مسارات `route_names.dart` تفتح شاشة حقيقية بـ `app_router.dart`. لا زر يشير لصفحة غير موجودة.

**الأزرار المسدودة (dead-ends) المقصودة:**

- **مؤجل v2:** social login, password reset, packages checkout, seat booking/payment, location map.
- **مدعوم بالباك، يحتاج توصيل بالربط:** نشر الإعلان/العرض/الخدمة، رفع الأفاتار/الصور، الفئة (category picker).
- **بلا endpoint بالباك:** رسائل الدعم (Support) — لا endpoint.

**تغيّرات عن النسخة السابقة:**

- **حفظ تعديل البروفايل لم يعد dead-end** — موصول فعلاً ومُتحقَّق حياً (Phase 3، 2026-07-13).
- **Follow لم يعد dead-end** — صار toggle محلي فعّال (يتبقّى استبداله بالطلب الحقيقي).
- **التعريب (Arabic) اكتمل** — لم يعد ضمن "المؤجل/بلا باك"؛ جانبه الخلفي الوحيد هو هيدر `Accept-Language`.
- **See-All على الهوم** يعمل (كان مؤجلاً).

</div>

---

## 8. ترتيب الربط الموصى به (Priority Order)

| #       | الخطوة                                                                                                                                                                                                                          | Endpoints    | لماذا                                                     |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------------------------------------------------- |
| ✅ 1️⃣   | **إعادة بناء السباكة** — عميل HTTP + interceptor (**Bearer + `Accept-Language`**) + `SecureAuthSessionStore` (`flutter_secure_storage`) + auto-refresh على 401 + إعادة `baseUrl` — **تمّت 2026-07-13**، analyze + 181 اختبار ✅ | (بنية تحتية) | **يفتح كل المحمي + المحتوى المُعرّب.** بدونه لا شيء يعمل. |
| ✅ 2️⃣   | **Auth wiring** — ربط login/register بالتخزين الآمن — **تمّت 2026-07-13**، تحقّق حي (تسجيل حقيقي وصل للباك، أخطاء التحقق ظهرت صح بالواجهة)                                                                                      | 4            | أساس الجلسة.                                              |
| ✅ 3️⃣   | **Profile الشخصي** — استبدال fake بـ `GET /profiles/me`، وتنفيذ `PUT /profiles/me` (إزالة الـ stub) — **تمّت 2026-07-13**، تحقّق حي بحساب حقيقي (تحميل + حفظ + استمرارية)                                                       | 2            | أكبر فجوة.                                                |
| ✅ 4️⃣   | **Home** — `GET /home` + تفاصيل — **تمّت 2026-07-14**، تحقّق حي (تصنيفات معرّبة، إعلان حقيقي بالـ highlight، تفاصيله فتحت صح)                                                                                                   | 1            | الشاشة الأهم (public).                                    |
| ✅ 5️⃣   | **Categories + Services + Search + Leaderboard** — **تمّت 2026-07-14**، تحقّق حي (Categories/Services/Leaderboard بيانات حقيقية؛ Search كود جاهز بلا تحقّق حي بعد)                                                              | 5            | سريعة.                                                    |
| 6️⃣      | **Seats** — تأكيد الـ seed بالباك، ثم `GET /seats`                                                                                                                                                                              | 2            | يحتاج تحقق بالباك.                                        |
| 7️⃣      | **Follow/Unfollow** — استبدال الـ toggle المحلي بالطلب + status                                                                                                                                                                 | 5            | يحدّث `followers_count` → Cup.                            |
| 8️⃣      | **Upload** — `/upload/image` ثم avatar/cover/ad-image                                                                                                                                                                           | 4            | شرط للتعديل والإنشاء.                                     |
| 9️⃣      | **Add Ad/Offer/Service publish** — `POST` + role-gating                                                                                                                                                                         | 3            | يعتمد على Upload + Auth.                                  |
| 🔟      | **Saved** — حل الـ join، ثم ربط الشاشة                                                                                                                                                                                          | 3            | يحتاج قرار الباك.                                         |
| ✅ 1️⃣1️⃣ | **Chat** — REST + Supabase Realtime — **تمّت 2026-07-19**                                                                                                                                                                       | 6            | الأكثر تعقيداً.                                           |
| 1️⃣2️⃣    | **Role-gating حيّ** — أزرار الإنشاء حسب `account_type` الحقيقي                                                                                                                                                                  | —            | يمنع 403.                                                 |

---

## 9. ما ينقص/يحتاج انتباه بالباك (Backend gaps)

> **✅ تحديث Phase 0 (2026-07-13) — أُغلقت الفجوات الأساسية عند المصدر:**
>
> - **الفجوة 1 (seat seed):** ✅ منجز ومُتحقَّق حياً — migration `035_seed_seat_grid.sql` زرع 144 مقعد (16/48/80) على الـ DB الحقيقي.
> - **الفجوة 3 (`GET /saved`):** ✅ منجز بالكود (`saved.service.ts` صار يجمّع حسب النوع ويرجّع تفاصيل العنصر) — يُختبر حياً بمستخدم مصادَق بمرحلة Saved (Phase 11).
> - **الفجوة 4 (إحصائيات البروفايل):** ✅ `following_count`+`posts_count` صاروا يُحسبوا (`profile.service.ts`) ومُتحقَّق. `views_count` **مؤجّل v2** (لا مصدر بالـ DB — قرار مالك 2026-07-13، `v2_deferred_scope.md` §6).
> - **بالإضافة (تعريب):** `pickLocalized` كان معرّف وغير مستدعى — وُصِّل الآن بـ `categories`+`/home` (`name` واحد حسب `Accept-Language`) ومُتحقَّق حياً (عربي/إنكليزي).
> - **الفجوة 8 (Leaked Password Protection):** لسا بانتظارك — toggle بلوحة Supabase.

| #   | الفجوة                                                                                                                                                       | الخطورة              | الحل                                                                                                                                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **Seats seed** — ~مقعد/tier، الفرونت يريد شبكة كاملة                                                                                                         | 🔴 حرجة (Influencer) | توسيع `seed.sql`. **يُعاد التحقق عند الربط** (migrations المقاعد الأخيرة لم تزرع شبكة).                                                         |
| 2   | **`POST /subscriptions` = 500** (`client_secret`)                                                                                                            | 🟠 (v2)              | إصلاح flow الـ PaymentSheet. لا يؤثر v1.                                                                                                        |
| 3   | **`GET /saved` بلا تفاصيل** — id+type فقط                                                                                                                    | 🟡                   | join يرجّع تفاصيل العنصر (مفضّل)، أو N+1 بالفرونت.                                                                                              |
| 4   | ~~إحصائيات البروفايل~~ ✅ **`following`+`posts` أُضيفا (Phase 0) ومُتحقَّقان حياً (Phase 3).** `views_count` يبقى مفقود — لا مصدر بالـ DB، مؤجّل v2 نهائياً. | 🟢 (تمّ جزئياً)      | —                                                                                                                                               |
| 5   | **لا endpoint للدعم (Support)**                                                                                                                              | 🟢                   | mailto/رابط، أو Reports، أو تأجيل.                                                                                                              |
| 6   | **لا كيان Content Packages** (99/149/249)                                                                                                                    | 🟢 (v2)              | جدول جديد أو ربط subscriptions أو إسقاط. display-only حالياً.                                                                                   |
| 7   | **لا `location` بكائن Service** ولا `GET /ads/:id` عام                                                                                                       | 🟢                   | تجميلي — الفرونت يتعامل مع الغياب.                                                                                                              |
| 8   | **Leaked Password Protection معطّلة** (Supabase Auth)                                                                                                        | 🟡 (Phase B)         | تفعيل من Dashboard → Authentication (toggle). مهم قبل تسجيل مستخدمين حقيقيين.                                                                   |
| 9   | **جولة أداء RLS مؤجّلة** — 47 `auth_rls_initplan` + 165 `multiple_permissive_policies` + 4 FK بلا index + 8 index غير مستخدم                                 | 🟡 (scale)           | migration `035` مستقلّة (لم تُنفَّذ بعد). WARN فقط. الأمان أُنجز بـ `034`. التفاصيل: `promo_backend/docs/DB_AUDIT_AND_HARDENING_2026-07-12.md`. |
| 10  | **لا أعمدة `_ar/_en` لمحتوى المستخدمين**                                                                                                                     | 🟢 (v2)              | مطلوب فقط لو طلب العميل إدخال محتوى ثنائي اللغة (قسم 6). المحتوى المرجعي (تصنيفات/باقات) عنده الأعمدة أصلاً.                                    |

---

## 10. مراجع

- عقد الـ API الكامل: `promo_backend/docs/promoo-api-reference.json` + `promoo_full_api.postman_collection.json`
- نتائج الاختبار الحيّة: `promo_backend/docs/Apis-Resaults/` (21 مجلد)
- تدقيق/تقوية الـ DB: `promo_backend/docs/DB_AUDIT_AND_HARDENING_2026-07-12.md`
- منطق الصلاحيات: `promo_mobile/docs/roles_logic.md`
- المؤجل v2: `promo_mobile/docs/v2_deferred_scope.md`
- خطة التعريب (مكتملة): `promo_mobile/docs/localization_plan.md`
- الذاكرة/الخط الزمني: `promo_mobile/docs/MEMORY_BANK.md`
- دليل الشات الفوري: `promo_backend/docs/Realtime-Chat-Flutter-Guide.md`

</div>
