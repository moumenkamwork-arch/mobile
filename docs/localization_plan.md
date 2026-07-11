<div dir="rtl">

# خطة التعريب (Arabic / English + RTL) — قبل الربط

> **الهدف:** جعل تطبيق `promo_mobile` ثنائي اللغة (عربي/إنجليزي) مع دعم RTL كامل، **قبل** مرحلة ربط الـ backend.
>
> **لماذا قبل الربط؟** التعريب ينقسم قسمين ينفصلان نظيفاً: **نصوص الواجهة + RTL (≈90%) مستقلّة تماماً عن الـ backend** ونعملها الآن على قاعدة frontend-only مستقرّة؛ و**لغة المحتوى الديناميكي (≈10%) تندمج طبيعياً في الربط** (هيدر `Accept-Language`).
>
> الحالة: **قيد التنفيذ** — ✅ L0 (السكافولد + شاشة الإعدادات) منجزة · ⏭️ L1 التالية · التاريخ: 2026-07-11.

---

## 0) السياق — كيف يتعامل الطرفان مع اللغة

| الطبقة | المسؤول | الآلية |
| --- | --- | --- |
| نصوص واجهة التطبيق (أزرار، عناوين، حالات فارغة/خطأ...) | **الفرونت** | Flutter `l10n` (ملفات ARB) + RTL |
| محتوى مرجعي (تصنيفات، باقات الاشتراك) | **الباك** | أعمدة `name_ar/name_en`؛ الباك يحلّها عبر `Accept-Language` ويُرجع حقلاً واحداً (`name`) — [helpers.ts](../../promo_backend/src/utils/helpers.ts) `getLanguage` + `pickLocalized` |
| محتوى المستخدمين (عناوين العروض/الخدمات، البايو، الشات) | — | لغة واحدة كما كتبها صاحبها؛ لا تُترجم |

**الخلاصة:** الفرونت يملك نصوص الواجهة بالكامل، ويكفي أن يبعث `Accept-Language` ليحصل على المحتوى المرجعي باللغة الصحيحة.

## جاهزية التطبيق الحالية (نقاط قوة)
- ✅ `intl` + `flutter_localizations` **موجودان** في [pubspec.yaml](../pubspec.yaml).
- ✅ **صفر** paddings/alignments غير اتجاهية — 172 موضعاً كلها `EdgeInsetsDirectional`/`AlignmentDirectional`/`PositionedDirectional` → RTL سينقلب "تلقائياً" دون أعطال تخطيط تقريباً.
- ✅ يوجد toggle "Arabic/English" في الإعدادات (حالياً stub) + نمط حفظ جاهز نقلّده ([theme_mode_controller.dart](../lib/theme/theme_mode_controller.dart)).
- ✅ نقطة تبديل واحدة للتطبيق: [app.dart](../lib/app.dart) (`MaterialApp.router`).

---

## المرحلة L0 — السكافولد ✅ (منجزة 2026-07-11)

- [x] إضافة [l10n.yaml](../l10n.yaml) (`arb-dir: lib/l10n`, `template: app_en.arb`, `output: app_localizations.dart`, `nullable-getter: false`).
- [x] `flutter: generate: true` في [pubspec.yaml](../pubspec.yaml).
- [x] [app_en.arb](../lib/l10n/app_en.arb) + [app_ar.arb](../lib/l10n/app_ar.arb) — نصوص شاشة الإعدادات كاملة (شريحة أولى حقيقية).
- [x] [locale_controller.dart](../lib/i18n/locale_controller.dart) — `NotifierProvider<LocaleController, Locale>` مطابق لنمط `theme_mode_controller` (مفتاح `promoo_locale`، حفظ best-effort، **الافتراضي = لغة الجهاز** ثم اختيار المستخدم).
- [x] ربط [app.dart](../lib/app.dart): `locale` + `localizationsDelegates` + `supportedLocales`.
- [x] وصل قسم "Language" في [profile_menu_screen.dart](../lib/features/profile/presentation/screens/profile_menu_screen.dart) بالـ `localeProvider` (إزالة "coming soon") + **تعريب كامل لشاشة الإعدادات** (الترحيب، صفوف القائمة، اللغة، المظهر، الخروج، الفوتر).
- [x] اختبارات: [localization_test.dart](../test/i18n/localization_test.dart) تُثبت **عربي → RTL** + إنجليزي → LTR + toggle الـ controller. (163 اختباراً يمرّ، analyze نظيف.)
- **DoD محقّق:** تبديل "Arabic" يقلب التطبيق لـ RTL ونصوص شاشة الإعدادات كلها عربية، ويُحفظ. باقي الشاشات إنجليزية حتى L1+.

> **قرارات مُعتمدة:** الافتراضي = لغة الجهاز (fallback إنجليزي) · أرقام غربية · الترجمة العربية مسودّة مني (تُراجَع لاحقاً).
> **ملاحظة تحقّق:** الإثبات الحيّ للـ RTL عبر اختبار الودجت (مُوثوق)؛ معاينة المتصفح كانت عالقة هالجولة (مشكلة أداة، مش كود).

## المرحلة L1 — النصوص المشتركة/الأساسية (أعلى رافعة)
تظهر في كل الشاشات، فترجمتها تُعرّب أجزاء واسعة دفعة واحدة.
- [ ] الودجت المشتركة: `promoo_empty_state`, `promoo_error_state`, `promoo_loading_indicator`, `promoo_section_header`, `promoo_button` (نصوص شائعة).
- [ ] الهيدر/الفوتر: `promoo_page_header` (Chats/Notifications/Switch mode)، تبويبات `promoo_shell` (Home/Influencer/Promoo/Services/Profile)، snackbar "Press back again to exit".

## المراحل L2…Ln — استخراج feature بعد feature
لكل ميزة: استخراج النصوص إلى ARB + الترجمة العربية + تحقّق RTL بصري.
- [ ] **Auth** — Login / Register (حقول، أزرار، "Continue as Guest"، رسائل).
- [ ] **Home** — عناوين الأقسام (Top Offers, For You, Promoo of the Day, Services, Stories)، See All.
- [ ] **Services** — البحث، حالات "No service found"، شريط النتائج.
- [ ] **Influencer/Seats** — Influencers/Available seats، Gold/Silver/Bronze، Place/Book Seat، ورقة المقعد.
- [ ] **Cup/Leaderboard** — العناوين، Champion، Ranking.
- [ ] **Profile** — البروفايل العام (Follow/Following/Message/Packages/Media/About)، قائمة الإعدادات، Edit، Following، My Packages، Saved، Support، Static info (About/Terms/Privacy).
- [ ] **Chat** — قائمة الشات، غرفة المحادثة، composer، حالات فارغة.
- [ ] **Notifications** — العنوان، Mark all read، الحالات.
- [ ] **Add wizards** — Add Offer / Ad / Service (عناوين الحقول، الأزرار، إشعارات "next phase").
- [ ] **Story viewer** — أي نصوص + تأكيد اتجاه السحب في RTL.

## المرحلة Lx — تلميع RTL + التنسيق
- [ ] الأيقونات الاتجاهية: `Icons.chevron_right_rounded` في صفوف القوائم لا ينقلب تلقائياً → استبداله بأيقونة تحترم `Directionality` (أو `Icons.chevron_right` مع انعكاس). زر الرجوع `arrow_back` ينقلب تلقائياً.
- [ ] تنسيق الأرقام/العملة عبر `intl` (`NumberFormat` باللغة الحالية) — العملة AED.
- [ ] التواريخ/الأوقات (الشات، التنبيهات) عبر `DateFormat` باللغة.
- [ ] تأكيد الكاروسيلات والـ PageView تحترم الاتجاه.

---

## ما يُؤجَّل لمرحلة الربط (موثّق هنا حتى لا يُنسى)
- [ ] إرسال `Accept-Language: <locale>` من الـ `localeProvider` عبر interceptor على عميل الشبكة (سطر واحد).
- [ ] DTOs المحتوى المرجعي (تصنيفات/باقات) تقرأ الحقل الموحّد (`name`, `description`) المطابق لمخرجات `pickLocalized`.
- [ ] محتوى المستخدمين يُعرض بلغته الأصلية (لا ترجمة) — سلوك متوقّع.

## الاختبارات
- [x] widget tests: `Locale('ar')` → نص عربي + `Directionality.rtl` ([localization_test.dart](../test/i18n/localization_test.dart)). يُوسَّع مع كل feature.
- [x] الإبقاء على الاختبارات خضراء (163 تمرّ الآن). **ملاحظة:** أي harness يعرض شاشة معرّبة يحتاج `localizationsDelegates: AppLocalizations.localizationsDelegates` + `supportedLocales` في الـ MaterialApp.
- [ ] تحقّق بصري حيّ للثيمين × اللغتين على شاشات مفتاحية.

## Definition of Done
- كل نصوص الواجهة تأتي من ARB (لا نص إنجليزي مكتوب مباشرة في الشاشات).
- تبديل اللغة من الإعدادات يقلب النص + الاتجاه فوراً ويُحفظ.
- لا أعطال RTL (محاذاة/حشو/أيقونات اتجاهية).
- جاهزية الربط: `localeProvider` مصدر وحيد يقرأ منه الـ interceptor لاحقاً.

---

## القرارات (مُعتمدة ✔)
1. ✔ **اللغة الافتراضية:** تتبع لغة الجهاز (عربي→عربي، وإلا إنجليزي)، ثم يُحفظ اختيار المستخدم.
2. ✔ **الأرقام:** غربية (1,2,3) للاتساق.
3. ✔ **الترجمة العربية:** أصيغها كمسودّة ضمن ملفات ARB، تُراجَع لاحقاً من مترجم.

</div>
