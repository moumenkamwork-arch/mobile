<div dir="rtl">

# Promoo — سجل التعديلات الكامل (2026-07-22)

> **كل شي انبنى/اتوصل بهالجلسة، حرفياً.** الملف موزّع حسب الميزة، وكل ميزة فيها:
> ما انعمل · تغييرات الباك · تغييرات الموبايل · الـ endpoints · نقاط الدخول · نطاق مقصود (شو تركناه).
> بالآخر: جدول ملخّص لكل الملفات (جديد/معدّل)، حالة التحقق، والمتبقّي.
>
> **قاعدة ذهبية طول الجلسة:** ما في شي ضرب بشي — بعد كل ميزة: `flutter analyze` نظيف + كل الاختبارات تمرّ + `npx tsc` بالباك نظيف.

---

## الخلاصة التنفيذية

بعد إنجاز **نشر المحتوى (Phase 12)**، أُنجزت بهالجلسة كل نواقص v1 المتبقية:

| # | الميزة | الحالة | الأثر |
|---|--------|--------|-------|
| 1 | زر الحفظ من التفاصيل (`POST /saved`) | ✅ | زر bookmark بتفاصيل العرض/الإعلان/الخدمة |
| 2 | قائمة Followers (`GET /follows/followers/:id`) | ✅ | شاشة جديدة |
| 3 | **حظر المستخدم (Block)** — ميزة جديدة بالكامل | ✅ | جدول + endpoints + إنفاذ بالشات + UI |
| 4 | **تعديل/حذف المحتوى + شاشة "منشوراتي"** | ✅ | `PUT`/`DELETE` + شاشة إدارة |
| 5 | **حذف الحساب** (`DELETE /profiles/me`) | ✅ | مطلب متجر Apple/Google |
| 6 | **الإبلاغ (`POST /reports`)** | ✅ | من 4 نقاط دخول |

**النتيجة:** اكتمل مطلب Apple Guideline 1.2 (تبليغ + حظر) ومطلب حذف الحساب الإجباري بالمتجرين. **المتبقّي v1 الوحيد:** غلاف البروفايل (cover) — بلا UI، قرار متعمّد.

---

## 1) زر الحفظ من التفاصيل — `POST /saved`

**ما انعمل:** قبل، الـ Saved كان قائمة عرض/حذف فقط (`GET /saved` + `DELETE /saved/:id`). أُضيف زر bookmark فعلي بتفاصيل العرض/الإعلان والخدمة يستدعي `POST /saved`.

**الموبايل:**
- `SavedRepository.addSavedItem` (جديد) + `SavedController.toggle()`/`isSaved()` (تفاؤلي + revert).
- widget مشترك جديد `PromooSaveButton` بالـ `trailing` slot الجديد لـ `PromooDetailHeader`.

**Endpoint:** `POST /saved` (`{item_id, item_type}`).

---

## 2) قائمة Followers — `GET /follows/followers/:id`

**ما انعمل:** كان في شاشة Following فقط. أُضيفت شاشة Followers مطابقة.

**الموبايل:**
- `ProfileRepository.getFollowers` (يعيد استخدام `_parseFollowUsers` الدفاعي الموجود — يقرأ `follower`/`following` معاً).
- `FollowersController` + `FollowersScreen` (نفس نمط Following)، route جديد + صف بقائمة البروفايل.

**Endpoint:** `GET /follows/followers/:id` (كان الثابت `followersList` موجود بالكود بس غير مستخدم).

---

## 3) حظر المستخدم (Block) — ميزة جديدة بالكامل

**ما انعمل:** ما كانت موجودة **إطلاقاً** — لا جدول، لا endpoint، لا UI. بُنيت من الصفر بنفس نمط `follows`.

**الباك (جديد كلياً):**
- `supabase/migrations/036_create_blocks.sql` — جدول `blocks` مع **RLS خاص** (فقط الحاظر يشوف صفوفه — عكس `follows` العام).
- `block.validator.ts` / `block.service.ts` / `block.controller.ts` / `block.routes.ts` — مطابقة لوحدة `follows`.
- تسجيل بـ `routes/index.ts` على `/blocks`.
- **إنفاذ فعلي بالشات (الأهم):** `chat.service.ts` — `startOrOpenChat` و`sendMessage` يتحققوا `blockService.isBlockedEitherWay(...)` ويرجّعوا **403** لو أي طرف حاظر التاني (يغطي: فتح محادثة جديدة + الإرسال بمحادثة قديمة انحظر فيها لاحقاً).

**الموبايل:**
- `ProfileRepository`: `blockProfile` / `unblockProfile` / `getBlockStatus` / `getBlockedUsers`.
- `ProfileState.isBlocked` (يُجلب مع `isFollowing`) + `ProfileController.toggleBlock()` (تفاؤلي + revert).
- قائمة "⋮" برأس البروفايل العام (حظر بتأكيد، إلغاء حظر بدون).
- شاشة إدارة جديدة `BlockedUsersScreen` + `BlockedUsersController`.

**Endpoints:** `POST /blocks/:id` · `DELETE /blocks/:id` · `GET /blocks/:id/status` · `GET /blocks`.

**نطاق مقصود (لسا):** لا زر حظر داخل شاشة الشات نفسها؛ لا فلترة تلقائية للمحظورين من الهوم/السيرش.

---

## 4) تعديل/حذف المحتوى + شاشة "منشوراتي"

**ما انعمل:** بعد ما صار المستخدم يقدر **ينشر** (Phase 12)، صار يقدر **يعدّل ويحذف** منشوراته، مع شاشة تجمعهم.

**الباك (سدّ فجوات ناقصة):**
- `ad.service.deleteAd` + `DELETE /ads/:id` route — **كان ناقص** (العروض والخدمات كان عندهم حذف، الإعلان لأ).
- `service.service.getServicesByProfileId` + `GET /services/profile/:id` route — **كان ناقص** (العروض والإعلانات كان عندهم `/profile/:id`).
- (العروض/الإعلانات/الخدمات أصلاً عندهم `PUT`؛ العروض/الإعلانات عندهم `/profile/:id`.)

**الموبايل:**
- شاشات `Add Offer/Service/Ad` صارت تقبل `editing:` — `initState` يعبّي الحقول، ومسار الإرسال يستدعي `updateOffer/updateService/updateAd` (`PUT`) بدل الإنشاء. **نفس الشاشة، بلا نموذج تعديل منفصل.**
- شريحة جديدة `lib/features/my_listings/`:
  - `MyListingsController` — يجيب الثلاثة بالتوازي من `GET /…/profile/:myId` (كل الحالات، للمالك فقط)، حذف تفاؤلي + revert.
  - `MyListingsScreen` — أقسام لكل نوع مع حالة كل عنصر؛ تعديل يفتح شاشة الإضافة المعبّأة عبر `MaterialPageRoute`؛ حذف بتأكيد.
- كيانات جديدة `OfferListing` / `AdListing` + DTOs؛ `PromooService`/DTO اكتسبوا حقل `status`.
- ثوابت endpoint جديدة: `adById` · `offersByProfile` · `adsByProfile` · `servicesByProfile`.
- صف بقائمة البروفايل مشروط بـ `canCreateAnything`.

**Endpoints:** `PUT /offers|/services|/ads/:id` · `DELETE /offers|/services|/ads/:id` · `GET /offers|/services|/ads/profile/:id`.

---

## 5) حذف الحساب — `DELETE /profiles/me`

**ما انعمل:** مطلب إجباري بمتجري Apple/Google لأي تطبيق فيه تسجيل حساب.

**الباك:**
- الـ service `profileService.deleteAccount` (`supabaseAdmin.auth.admin.deleteUser` — الـ profile يتحذف cascade) **كان موجود بلا route**؛ أُضيف `DELETE /profiles/me`.

**الموبايل:**
- `ProfileRepository.deleteAccount`.
- صف **أحمر** أسفل قائمة البروفايل + `AlertDialog` تأكيد → عند النجاح: `logout()` محلي (استدعاؤه يمسح الجلسة حتى لو 401 على مستخدم محذوف) + `context.go(login)`.

**Endpoint:** `DELETE /profiles/me`.

---

## 6) الإبلاغ عن المحتوى — `POST /reports`

**ما انعمل:** الـ endpoint موجود بالباك **من زمان** (`report.routes.ts`) بس غير مربوط بالموبايل إطلاقاً. اتوصل أخيراً.

**الموبايل (شريحة جديدة `lib/features/reports/`):**
- `ReportDraft` + `ReportedType` (enum يطابق `reported_type` بالباك: profile/offer/ad/message/service/story/seat).
- repository + remote data source.
- `showReportSheet` — bottom sheet فيه ChoiceChips للأسباب (قيمة `reason` تبقى إنكليزية ثابتة ليقرأها الداشبورد موحّدة، بينما الـ label معرّب) + حقل تفاصيل اختياري.
- `PromooReportMenuButton` — زر "⋮" لإعادة الاستخدام.

**نقاط الدخول:**
- قائمة "⋮" بالبروفايل العام (صارت `PopupMenuButton` بإجرائين: حظر + إبلاغ) → `ReportedType.profile`.
- رأس تفاصيل العرض/الإعلان (`ReportedType.offer|ad`) — جنب زر الحفظ.
- رأس تفاصيل الخدمة (`ReportedType.service`).
- عارض الستوري (`ReportedType.story`) — يوقف التقدّم أثناء فتح الشيت.

**Endpoint:** `POST /reports` (`{reported_id, reported_type, reason, details?}`).

**نطاق مقصود (لسا):** لا إبلاغ على رسالة مفردة داخل الشات (`ReportedType.message` معرّف بالـ enum بس بلا نقطة دخول UI).

---

## جدول الملفات

### الباك (`promo_backend`)

| الملف | نوع |
|-------|-----|
| `supabase/migrations/036_create_blocks.sql` | جديد |
| `src/validators/block.validator.ts` | جديد |
| `src/services/block.service.ts` | جديد |
| `src/controllers/block.controller.ts` | جديد |
| `src/routes/block.routes.ts` | جديد |
| `src/routes/index.ts` | معدّل (تسجيل `/blocks`) |
| `src/services/chat.service.ts` | معدّل (إنفاذ الحظر) |
| `src/services/ad.service.ts` | معدّل (`deleteAd`) |
| `src/controllers/ad.controller.ts` | معدّل (`deleteAd`) |
| `src/routes/ad.routes.ts` | معدّل (`DELETE /ads/:id`) |
| `src/services/service.service.ts` | معدّل (`getServicesByProfileId`) |
| `src/controllers/service.controller.ts` | معدّل |
| `src/routes/service.routes.ts` | معدّل (`GET /services/profile/:id`) |
| `src/controllers/profile.controller.ts` | معدّل (`deleteAccount` handler) |
| `src/routes/profile.routes.ts` | معدّل (`DELETE /profiles/me`) |
| `docs/MEMORY_BANK.md` | معدّل (addendum) |

### الموبايل (`promo_mobile`) — ملفات جديدة

```
lib/features/reports/domain/entities/report_draft.dart
lib/features/reports/domain/repositories/reports_repository.dart
lib/features/reports/data/datasources/reports_remote_data_source.dart
lib/features/reports/data/repositories/reports_repository_impl.dart
lib/features/reports/presentation/report_sheet.dart
lib/features/reports/presentation/report_menu_button.dart

lib/features/my_listings/presentation/controllers/my_listings_controller.dart
lib/features/my_listings/presentation/screens/my_listings_screen.dart

lib/features/offers/domain/entities/offer_listing.dart
lib/features/offers/data/dto/offer_listing_dto.dart
lib/features/ads/domain/entities/ad_listing.dart
lib/features/ads/data/dto/ad_listing_dto.dart

lib/features/profile/presentation/controllers/followers_controller.dart
lib/features/profile/presentation/screens/followers_screen.dart
lib/features/profile/presentation/controllers/blocked_users_controller.dart
lib/features/profile/presentation/screens/blocked_users_screen.dart

lib/shared/widgets/promoo_save_button.dart
```

### الموبايل — أبرز الملفات المعدّلة

```
lib/core/network/api_endpoints.dart            (blocks, reports, adById, *ByProfile)
lib/routing/route_names.dart · app_router.dart (followers/blocked/my-listings routes)

lib/features/offers/**  (repo/datasource/impl: update/delete/getMy)
lib/features/ads/**     (repo/datasource/impl: update/delete/getMy)
lib/features/services/** (repo/datasource/impl/dto/entity: update/delete/getMy + status)

lib/features/profile/presentation/screens/add_offer_screen.dart      (editing mode)
lib/features/profile/presentation/screens/add_service_screen.dart    (editing mode)
lib/features/profile/presentation/screens/add_ad_wizard_screen.dart  (editing mode)
lib/features/profile/presentation/screens/profile_screen.dart        (⋮ menu: block + report)
lib/features/profile/presentation/screens/profile_menu_screen.dart   (My Listings + Delete Account rows)
lib/features/profile/domain/repositories/profile_repository.dart     (block/report/deleteAccount)
lib/features/profile/data/**                                         (block/deleteAccount impls)
lib/features/profile/presentation/controllers/profile_controller.dart (isBlocked + toggleBlock)

lib/features/home/presentation/screens/home_content_detail_screen.dart (save + report)
lib/features/home/presentation/widgets/home_story_viewer.dart          (report others' stories)
lib/features/services/presentation/screens/service_detail_screen.dart  (save + report)
lib/features/saved/**                                                  (addSavedItem + toggle)

lib/shared/widgets/promoo_detail_header.dart   (trailing slot)
lib/l10n/app_en.arb · app_ar.arb               (مفاتيح block/report/my-listings/delete-account/edit)
```

### ملفات الاختبار المعدّلة

test doubles عبر **6 ملفات** حُدّثت لتطابق أعضاء الواجهات الجديدة (`ProfileRepository` × block/report/deleteAccount، و`ServicesRepository` × update/delete/getMy):
`auth_screen_test.dart` · `profile_controller_test.dart` · `profile_screen_test.dart` · `profile_screen_l10n_test.dart` · `search_screen_test.dart` · `service_detail_*_test.dart` · `services_*_test.dart`.

---

## التحقق

| الفحص | النتيجة |
|-------|---------|
| `flutter analyze` (موبايل) | ✅ نظيف |
| `flutter test` (موبايل) | ✅ **198/198 تمرّ** |
| `npx tsc --noEmit` (باك) | ✅ نظيف (exit 0) |

---

## المتبقّي

**v1 — واحد فقط:**
- **غلاف البروفايل (cover)** — الـ endpoint (`POST /profiles/me/cover`) والـ repo جاهزين، بس **ما في UI** لتحميله. قرار متعمّد.

**خارج النطاق عمداً (نُوقش):**
- تبليغ رسالة مفردة داخل الشات (`ReportedType.message` بالـ enum بلا نقطة دخول).
- زر حظر داخل شاشة الشات نفسها.
- فلترة تلقائية لمحتوى المحظورين من الهوم/السيرش.
- اختبارات آلية مخصّصة لميزات block/report/my-listings/delete-account.

**v2 (متبقٍّ كما هو):** Stripe/الدفع، حجز المقاعد، الاشتراكات، تمييز العروض، phone/OTP، forgot-password، Reviews/Ratings، upload video/file، `GET /admin/users/:id`.

---

## مراجع

- خريطة الربط الكاملة: [integration_map.md](integration_map.md) (أقسام 3.11 / 3.14 / 3.15)
- حالة الشاشات: [REQUIREMENTS_STATUS.md](REQUIREMENTS_STATUS.md)
- الخط الزمني التفصيلي: [MEMORY_BANK.md](MEMORY_BANK.md) §5

</div>
