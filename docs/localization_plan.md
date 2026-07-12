<div dir="rtl">

# خطة التعريب (Arabic / English) — قبل الربط

> **الهدف:** جعل تطبيق `promo_mobile` ثنائي اللغة (عربي/إنجليزي)، **قبل** مرحلة ربط الـ backend.
>
> ⚠️ **قرار مالك حاسم (2026-07-11): بلا RTL.** التطبيق **يترجم النص فقط** — اتجاه الواجهة (layout) **يضل LTR ثابت بكلا اللغتين**، بدون أي انقلاب/مرآة. اتجاه القراءة الفعلي لحروف العربي داخل كل نص بيضل صحيح تلقائياً (خوارزمية Unicode bidi على مستوى الحرف، مستقلة عن اتجاه الـ layout) — بس ترتيب العناصر (Row، محاذاة start/end، إلخ) ثابت LTR دايماً. الفرض بـ [app.dart](../lib/app.dart) عبر `builder` بيغلّف كل التطبيق بـ `Directionality(textDirection: TextDirection.ltr)` بغضّ النظر عن اللغة المختارة. **كل مراحل L0-Seats كانت مبنية على افتراض RTL كامل وتصحّحت بأثر رجعي بعد هالقرار** — شوف "تحديث 2026-07-11 (بعد الشغل)" تحت.
>
> **لماذا قبل الربط؟** التعريب ينقسم قسمين ينفصلان نظيفاً: **نصوص الواجهة (≈90%) مستقلّة تماماً عن الـ backend** ونعملها الآن على قاعدة frontend-only مستقرّة؛ و**لغة المحتوى الديناميكي (≈10%) تندمج طبيعياً في الربط** (هيدر `Accept-Language`).
>
> الحالة: **قيد التنفيذ** — L0 حتى Profile/Add wizards/Story viewer منجزة (نص فقط، LTR ثابت) · ⏭️ Chat وNotifications التاليتان · آخر تحديث: 2026-07-12.

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
- ✅ **صفر** paddings/alignments غير اتجاهية — 172 موضعاً كلها `EdgeInsetsDirectional`/`AlignmentDirectional`/`PositionedDirectional`. (هاي كانت أصلاً تحضيراً لـ RTL؛ بعد قرار "بلا RTL" صارت غير حرجة لكن ما في داعي نرجّعها — الأسلوب الاتجاهي شغّال تمام بـ LTR الثابت وهو أفضل ممارسة بأي حال.)
- ✅ يوجد toggle "Arabic/English" في الإعدادات (حالياً stub) + نمط حفظ جاهز نقلّده ([theme_mode_controller.dart](../lib/theme/theme_mode_controller.dart)).
- ✅ نقطة تبديل واحدة للتطبيق: [app.dart](../lib/app.dart) (`MaterialApp.router`) — وفيها الآن `builder` يفرض `Directionality.ltr` دايماً.

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

## المرحلة L1 — النصوص المشتركة/الأساسية ✅ (منجزة 2026-07-11)
تظهر في كل الشاشات، فترجمتها عرّبت أجزاء واسعة دفعة واحدة.
- [x] الودجت المشتركة: فحصت [promoo_section_header.dart](../lib/shared/widgets/promoo_section_header.dart) و[promoo_button.dart](../lib/shared/widgets/promoo_button.dart) — لا نصوص مكتوبة بداخلهما (كل شي parameters من المستدعي، هيترجم مع كل feature بـ L2+). عرّبت الافتراضيات الحقيقية: [promoo_error_state.dart](../lib/shared/widgets/promoo_error_state.dart) (`retryLabel` صار nullable ويرجع لـ `actionRetry` من ARB) و[promoo_loading_indicator.dart](../lib/shared/widgets/promoo_loading_indicator.dart) (`semanticLabel` نفس المبدأ مع `commonLoading`).
- [x] الهيدر: [promoo_page_header.dart](../lib/shared/widgets/promoo_page_header.dart) — تلميحات Chats/Notifications/Switch to light-dark mode.
- [x] الفوتر: [promoo_shell.dart](../lib/shell/promoo_shell.dart) — تبويبات Home/Influencer/Promoo/Services/Profile (حُوّل `PromooShellTab.label` الثابت لـ `PromooShellTabId` enum + دالة `promooShellTabLabel(context, id)` تحلّ النص وقت البناء، لأن قائمة `tabs` هي `static const` وما فيها توصل لـ `BuildContext`)، وsnackbar "Press back again to exit".
- [x] اختبار: [promoo_shell_l10n_test.dart](../test/shell/promoo_shell_l10n_test.dart) يثبت التبويبات + تلميحات الهيدر بالعربي + RTL على الشل كامل.
- [x] حُدّثت 12 ملف اختبار كان يعرض هالودجت المشتركة (Home/Services/Seats/Cup/Profile/Search/Chat/Notifications/Auth) بإضافة `AppLocalizations.localizationsDelegates` + `supportedLocales` لـ `MaterialApp` تبعها (كل ودجت صار يستدعي `AppLocalizations.of(context)` فلازم يكون فيه Localizations ancestor بالاختبار). **164 اختبار يمرّ، analyze نظيف.**

## المراحل L2…Ln — استخراج feature بعد feature
لكل ميزة: استخراج النصوص إلى ARB + الترجمة العربية + تحقّق أنو النص عربي **والـ layout ثابت LTR** (بعد قرار إلغاء RTL — شوف الملاحظة بالأعلى).
- [x] **Auth** — ✅ منجزة 2026-07-11. Login/Register كاملة: حقول (Email/Password/Full name/Account type)، كل الأزرار (Login/Sign Up/Create account/Already have an account/Continue as Guest/forget password?/Continue/Sign out)، شرائح Social login + "{feature} coming soon" (مفتاح `commonComingSoon` قابل لإعادة الاستخدام)، Account type chips (User/Company/Influencer/Service provider — عبر دالة `authAccountTypeLabel` بدل getter بالـ domain layer، وحذفت `AuthAccountType.label` القديمة لأنها صارت ميتة). **رسائل التحقق والنجاح:** كانت نصوص إنجليزية مكتوبة مباشرة بالـ `AuthController` (يلي ما عندو `BuildContext`) — حوّلتها لـ `enum AuthValidationIssue` + `registrationPending: bool`، وأضفت `auth_messages.dart` (`resolveAuthMessage(l10n, state)`) يحلّها كنص وقت العرض. **مؤجَّل بوعي (مو Auth تحديداً):** رسائل فشل الشبكة الفعلية (`AppFailure.message`، مثل "Invalid email or password.") تبقى إنجليزي — هاي ملك بنية `Result<T,AppFailure>` المشتركة بين *كل* الـ features، مو خاصة بـ Auth، فترجمتها Lx منفصلة لاحقاً مش جزء من هالمرحلة. اختبارات: [auth_screen_l10n_test.dart](../test/features/auth/presentation/auth_screen_l10n_test.dart) يثبت عربي+RTL على Login (بما فيها رسالة "البريد الإلكتروني مطلوب.") وRegister (Account type chips). حدّثت `auth_controller_test.dart` + `demo_data_quality_test.dart` + `launch_intro_screen_test.dart` (كانت بتتعثر بعد ما صارت شاشة Login معرّبة). **166 اختبار يمرّ.**
- [x] **Home** — ✅ منجزة 2026-07-11. تغطّي `home_screen`، `home_story_strip`، `home_story_viewer`، `home_preview_sections`، `home_see_all_screen`، `home_content_detail_screen` (`home_header`/`home_highlight_card` لا تحتاج تعديل — أول واحد alias بلا نصوص، والتاني يعرض محتوى ديناميكي بالكامل). عناوين/أوصاف الأقسام (Stories, Top Offers, For You, Promoo of the Day, Services)، شارات الكروت (Top offer, Service badge + "Provider service" fallback)، حالات التحميل/الفراغ/الخطأ، شاشة See All (عناوين لكل قسم + فراغ/خطأ)، وصفحة تفاصيل العنصر كاملة (نوع العنصر Offer/Promotion/Promoo item، السعر/التوفر، أقسام الوصف/المزوّد/التفاصيل/الخطوة التالية، أزرار Contact/Open chats/View provider profile/Location، رسائل "قريباً" الديناميكية). أُضيفت مفاتيح مشتركة معاد استخدامها: `commonSeeAll`, `commonSomethingWentWrong` (ستتكرر بباقي الميزات). **نفس نمط الـ resolver:** `HomeContentDetailType` كان عندها `.label` بطبقة الـ domain تُستخدم بمكانين: العرض (استبدلتها بـ `homeContentDetailTypeLabel(context, type)`) **و** fallback بطبقة البيانات (`home_content_dto.dart` `toDomain()` عند غياب title/badge من المصدر) — هاي الحالة الثانية أعدتها كـ getter منفصل `dataFallbackLabel` (إنجليزي فقط عمداً، موثّق أنه مو للعرض المباشر، لأن طبقة البيانات ما عندها `BuildContext`). اختبار: [home_screen_l10n_test.dart](../test/features/home/presentation/home_screen_l10n_test.dart) يثبت عربي+RTL على عناوين الأقسام + شارة "أفضل عرض" + تلميحات الهيدر. **167 اختبار يمرّ**، لا كسر أي اختبار موجود (حافظت على كل النصوص الإنجليزية الافتراضية مطابقة تماماً للنصوص القديمة المُختبَرة).
- [x] **Services** — ✅ منجزة 2026-07-11. تغطّي `services_screen`، `services_search_field`، `services_category_list`، `service_card`، `service_detail_screen`. البحث + شريط النتائج (استُخدم ICU **plural** حقيقي لعدد النتائج `servicesResultsCount` بدل تفريع يدوي 0/1/غيره — العربية عندها فئات جمع أدق: zero/one/two/few/many/other) + شارة "كل الخدمات" + حالتَي الفراغ (بحث بلا نتيجة / بلا فلترة) + صفحة تفاصيل الخدمة كاملة (السعر، المدة الزمنية بصيغة plural، الوصف، تفاصيل التسليم، المزوّد، قسم التواصل). **تنظيف DRY أثناء الشغل:** رقّيت 8 مفاتيح كانت مكرّرة حرفياً بين Home وServices لقسم مشترك (`commonPrice`, `commonContactForPricing`, `commonDescription`, `commonProvider`, `commonDetails`, `commonOpenChats`, `commonViewProviderProfile`, `commonContactFlowComingSoon`) — أعدت تسميتها من `homeDetail*` إلى `common*` وحدّثت كل الاستخدامات بالملفين. **درس مستفاد:** لما بنعمل ARB لميزة جديدة، أول شي نتأكد هل النص نفسه تماماً موجود بميزة سابقة (نفس الكلمة الإنجليزية) — إذا آه، نرقّيه لمفتاح مشترك بدل تكراره. اختبار: [services_screen_l10n_test.dart](../test/features/services/presentation/services_screen_l10n_test.dart) يثبت عربي+RTL على فئة "كل الخدمات"، تلميح البحث، ورسالة "لا توجد خدمة مطابقة." **168 اختبار يمرّ**، صفر كسر.
- [x] **Influencer/Seats** — ✅ منجزة 2026-07-11. تغطّي `seats_screen` (الشريط + شريط البحث + مفتاح الفئات + الشبكة + ورقتَي المقعد/المؤثر) و`seat_checkout_preview_screen` كاملة. **قرار نحوي مهم:** "Gold Seat/Seats" ما انترجمت بتركيب حرفي (صفة+اسم إنجليزي) لأنو **العربي بترتيب معاكس** (اسم فالصفة: "مقعد ذهبي" مش "ذهبي مقعد"). استخدمت ICU **`select`** حقيقي (`seatsLegendLabel`, `seatsSingularLabel`, `seatsVisibilityPlacementLabel`) بدل الدمج النصي، كل وحدة بترجع عبارة كاملة حسب الفئة (gold/silver/bronze/other) — نفس فكرة الـ plural من مرحلة Services بس لتركيب نحوي مختلف. **نفس نمط split الـ getter:** `SeatTier.label`/`SeatStatus.label` ضلّوا بالـ domain (إنجليزي فقط، fallback داخلي لـ `Seat.title` + اختبار جودة البيانات)، والعرض الفعلي صار عبر دالة مساعدة `_seatTierKey(tier)` + مفاتيح الـ `select`. وصف كل فئة (فقرة تسويقية كاملة لكل من Gold/Silver/Bronze) اتنقل لملفات ARB بالكامل. **ملاحظة:** أربع widgets يتيمة غير مستخدمة بأي مكان بالتطبيق (`seat_card.dart`, `seat_tier_cards.dart`, `seat_status_badge.dart`, `seat_visibility_grid.dart`) — تُركت بلا تعريب لأنها كود ميت غير قابل للوصول، مو لأنها مؤجَّلة. اختبار: [seats_screen_l10n_test.dart](../test/features/seats/presentation/seats_screen_l10n_test.dart) يثبت عربي+RTL **وصحّة الترتيب النحوي** (جمع ومفرد). **170 اختبار يمرّ**، صفر كسر.
- [x] **Cup/Leaderboard** — ✅ منجزة 2026-07-11. تغطّي `leaderboard_screen`، `leaderboard_podium`، `leaderboard_ranked_list`، `leaderboard_profile_card`. العنوان "Cup" + الوصف، القمة (Top of the Cup + بطاقة البطل "Champion / N followers" + المتسابقين)، قسم الترتيب الكامل، وحالات التحميل/الفراغ/الخطأ. **نفس نمط split الـ getter (تكرر ثالث مرة):** `LeaderboardProfile.followersLabel`/`accountTypeLabel` كانوا getters بالـ domain يدمجوا رقم+كلمة أو enum+كلمة — النوع الأول (عدد المتابعين) كان أعقد لأنو بيحتاج **قواعد جمع حقيقية** (عدد صغير <1000 بياخد plural كامل zero/one/two/few/many/other، وعدد مضغوط بصيغة K/M بياخد كلمة ثابتة بعده) — قسمتها لدالتين بملف جديد `leaderboard_labels.dart`: `leaderboardFollowersLabel()` (تجمع بين مفتاحين ARB: `leaderboardFollowersCount` بصيغة plural للأرقام الصغيرة، و`leaderboardFollowersCompact` كقالب ثابت للأرقام المضغوطة) و`leaderboardAccountTypeLabel()` (يعيد استخدام مفاتيح `authAccountType*` الموجودة من مرحلة Auth بدل تكرارها). حذفت الـ getters القديمة بالكامل من الـ domain entity واستبدلتها بـ `compactFollowersCount` (رقم مضغوط فقط، بلا كلمة، إنجليزي/عالمي). حدّثت 3 ملفات اختبار كانت تنادي الـ getters المحذوفة مباشرة (`demo_data_quality_test.dart`, `leaderboard_dto_test.dart`) لتتأكد من الحقول الخام (`accountType`, `compactFollowersCount`) بدل النص المترجم. اختبار: [leaderboard_screen_l10n_test.dart](../test/features/leaderboard/presentation/leaderboard_screen_l10n_test.dart) يثبت عربي+LTR ثابت، **ويميّز بين الحالتين** (185.4K متابع بصيغة مضغوطة، 800 متابع بصيغة plural حقيقية "other"). **171 اختبار يمرّ**، صفر كسر.
- [x] **Profile + Add wizards** — ✅ منجزة 2026-07-12. تغطّي ~18 ملف: البروفايل العام (`profile_screen`, `profile_action_bar` — Follow/Following/Message/Edit profile, `profile_header` — meta chips + Featured badge, `profile_stats_row`, `profile_packages_section`, `profile_package_card`, `profile_media_section`, `profile_media_viewer`, `profile_about_section`)، قائمة الفرعيّة الكاملة (`edit_profile_screen`, `following_screen`, `my_packages_screen`, `saved_items_screen`, `support_screen`, `static_info_screen` — About/Terms/Privacy بنصوص قانونية كاملة)، وموجات "Add" الثلاث سويّة بما أنها تتشارك حقول ونصوص (`add_offer_screen`, `add_service_screen`, `add_ad_wizard_screen`). **نفس نمط split الـ getter (رابع مرة):** `ProfileAccountType.label` كان بالـ domain، فُصل لـ `profileAccountTypeLabel(context, type)` بملف جديد `profile_account_type_label.dart` **يعيد استخدام** مفاتيح `authAccountType*` و`leaderboardAccountTypeFallback` بدل تكرارها (فقط أضفت مفتاح واحد جديد `profileAccountTypeUser` لأنو Profile عندها قيمة `user` ما عند Auth). **إعادة استخدام واسعة عبر الميزات:** `servicesDeliveryDaysLabel` (Services) لبطاقة الباقة، `leaderboardFollowersCount` (Cup) لعدّاد متابعين Edit Profile، `menuFollowing/menuSaved/menuSupport/footerAbout/footerPrivacy/authFieldEmail/commonPrice` (L0/L1/Auth) لعناوين شاشات فرعية وحقول متطابقة نصياً. **قرار نطاق واعٍ لموجة الإعلان (Add AD):** ترجمت كل نصوص الواجهة (عناوين الخطوات، تسميات الحقول، الأزرار) وأسماء الإمارات الثمانية بقائمة المدن، **لكن تركت** قوائم المناطق الفرعية (area) وأنواع الخدمة/العملة/طريقة الدفع بالإنجليزي عمداً — محتوى منسدلات عميقة بشاشة معزولة (role-gated) بمرحلة A محلية بالكامل، بدون قيمة تُذكر مقابل حجم الترجمة. **ملف مشترك جديد:** `add_category_label.dart` يحلّ فئات Add Offer/Add Service الأربع (نفس القائمة بالملفين) عبر دالة واحدة بدل تكرار الـ switch. اختبار: [profile_screen_l10n_test.dart](../test/features/profile/presentation/profile_screen_l10n_test.dart) يثبت عربي+LTR ثابت على تسميات الإحصائيات، نوع الحساب، وقسم الباقات. **172 اختبار يمرّ**، صفر كسر.
- [ ] **Chat** — قائمة الشات، غرفة المحادثة، composer، حالات فارغة.
- [ ] **Notifications** — العنوان، Mark all read، الحالات.
- [x] **Story viewer** — تمّت أصلاً ضمن مرحلة Home (`home_story_viewer.dart`, تلميح "إغلاق" عبر `homeStoryViewerCloseTooltip`) — لا حاجة لعمل إضافي، هاي فقط تسوية دفتر الخطة.

## المرحلة Lx — تلميع التنسيق (بعد إلغاء RTL، ما في تلميع اتجاه — بس تنسيق أرقام/تواريخ)
- [ ] تنسيق الأرقام/العملة عبر `intl` (`NumberFormat` باللغة الحالية إذا لزم) — العملة AED والأرقام غربية بكل الأحوال (قرار مُعتمد).
- [ ] التواريخ/الأوقات (الشات، التنبيهات) عبر `DateFormat` باللغة.
- ~~الأيقونات الاتجاهية / انقلاب الكاروسيلات~~ — **غير مطلوب** بعد قرار "بلا RTL"؛ كل شي ثابت LTR بكلا اللغتين فما في أيقونات أو ترتيب يحتاج ينقلب.

---

## ما يُؤجَّل لمرحلة الربط (موثّق هنا حتى لا يُنسى)
- [ ] إرسال `Accept-Language: <locale>` من الـ `localeProvider` عبر interceptor على عميل الشبكة (سطر واحد).
- [ ] DTOs المحتوى المرجعي (تصنيفات/باقات) تقرأ الحقل الموحّد (`name`, `description`) المطابق لمخرجات `pickLocalized`.
- [ ] محتوى المستخدمين يُعرض بلغته الأصلية (لا ترجمة) — سلوك متوقّع.

## الاختبارات
- [x] widget tests: `Locale('ar')` → نص عربي + `Directionality.ltr` **ثابت** (مو rtl) — كل ملف `*_l10n_test.dart` بيبني `MaterialApp` بنفس `builder` الموجود بـ [app.dart](../lib/app.dart) (تكرار مقصود بكل ملف اختبار، مو helper مشترك، حتى الاختبار يعكس تطابق فعلي مع كود الإنتاج). يُوسَّع مع كل feature.
- [x] الإبقاء على الاختبارات خضراء (170 تمرّ الآن). **ملاحظة:** أي harness يعرض شاشة معرّبة يحتاج `localizationsDelegates: AppLocalizations.localizationsDelegates` + `supportedLocales` في الـ MaterialApp؛ وأي اختبار Arabic حيّ لازم يضيف نفس `builder` LTR (وإلا Flutter بيفرض RTL تلقائياً من الـ locale ويطلع الاختبار غلط).
- [ ] تحقّق بصري حيّ للثيمين × اللغتين على شاشات مفتاحية.

## Definition of Done
- كل نصوص الواجهة تأتي من ARB (لا نص إنجليزي مكتوب مباشرة في الشاشات).
- تبديل اللغة من الإعدادات يقلب **النص فقط** فوراً ويُحفظ — **الـ layout يضل LTR بكلا اللغتين** (لا انقلاب/مرآة).
- جاهزية الربط: `localeProvider` مصدر وحيد يقرأ منه الـ interceptor لاحقاً.

## تحديث 2026-07-11 (بعد الشغل) — إلغاء RTL بالكامل
المالك لاحظ إنو تبديل اللغة كان عم يقلب اتجاه كل قسم بالتطبيق لـ RTL (مرآة كاملة) وقال هالشي **غلط** — المطلوب ترجمة نص بس، بلا أي تغيير باتجاه الواجهة. التصحيح:
- [x] [app.dart](../lib/app.dart): أضفت `builder` بيغلّف `MaterialApp.router` بـ `Directionality(textDirection: TextDirection.ltr)` صريح، فبيلغي الـ RTL التلقائي يلي Flutter كان عم يطبّقو من `Locale('ar')`.
- [x] حدّثت **6 ملفات اختبار** كانت بتفترض RTL (`localization_test.dart`, `promoo_shell_l10n_test.dart`, `auth_screen_l10n_test.dart`, `home_screen_l10n_test.dart`, `services_screen_l10n_test.dart`, `seats_screen_l10n_test.dart`) — كل وحدة زودت نفس الـ `builder` وبدّلت التوقّع لـ `TextDirection.ltr`.
- [x] **170 اختبار يمرّ، analyze نظيف.** النص العربي هلق بيظهر صح (حروف عربي طبيعية بحكم Unicode bidi) بس ترتيب العناصر (أيقونات، أزرار، محاذاة) ثابت LTR بكلا اللغتين — بالضبط متل ما طلب المالك.
- **الأثر على باقي الخطة:** لا حاجة لأي شغل إضافي بالشاشات المُعرَّبة (Auth/Home/Services/Seats) — كانت مبنية بشكل صحيح أصلاً (`EdgeInsetsDirectional` وغيرها بتشتغل مثالي بـ LTR ثابت، وهي أفضل ممارسة برمجية بغضّ النظر عن RTL). التغيير الوحيد كان بـ `app.dart` + ملفات الاختبار. **مرحلة Lx القديمة (تلميع أيقونات/كاروسيلات اتجاهية) بطّلت مطلوبة كلياً**.

---

## القرارات (مُعتمدة ✔)
1. ✔ **اللغة الافتراضية:** تتبع لغة الجهاز (عربي→عربي، وإلا إنجليزي)، ثم يُحفظ اختيار المستخدم.
2. ✔ **الأرقام:** غربية (1,2,3) للاتساق.
3. ✔ **الترجمة العربية:** أصيغها كمسودّة ضمن ملفات ARB، تُراجَع لاحقاً من مترجم.

</div>
