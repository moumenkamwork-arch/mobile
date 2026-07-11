<div dir="rtl">

# قائمة تعديلات الزبون — تحقّق نهائي

> هاد الملف بيوثّق **كل بند** من قائمة التعديلات المطلوبة من الزبون، مع إشارة ✔ للبنود يلي تمّت فعلاً، ومكان كل تعديل بالمشروع (اسم الملف + تفاصيل).
>
> **الخلاصة: كل البنود التمانية منفَّذة ✔** (بعضها كان شغّال من مراحل سابقة، وبعضها انصلح ضمن جولة التحقّق الأخيرة).
>
> آخر تحقّق: 2026-07-10 · 160 اختبار يمرّ · `flutter analyze` نظيف.

---

## 1) صفحة تسجيل الدخول

- ✔ **زر "تسجيل كضيف"** — موجود تحت زر Sign Up.
  📍 [`lib/features/auth/presentation/screens/login_screen.dart`](../lib/features/auth/presentation/screens/login_screen.dart) — `PromooButton.tertiary(label: 'Continue as Guest', ...)` بينقل مباشرة لصفحة الهوم (`context.go(AppRoutes.home)`) بدون تسجيل دخول.

- ✔ **اللوجو الصحيح** — لوجو مخصّص لكل ثيم (بلا صندوق/مستطيل حوله)، أصفر بالدارك وأسود+زيتوني بالفاتح.
  📍 [`lib/features/auth/presentation/widgets/auth_screen_frame.dart`](../lib/features/auth/presentation/widgets/auth_screen_frame.dart) — يستخدم `PromooLogo.full(width: 280, height: 96)`.
  📍 [`lib/shared/widgets/promoo_logo.dart`](../lib/shared/widgets/promoo_logo.dart) — منطق اختيار الصورة حسب الثيم (`fullAssetDark` / `fullAssetLight`).

---

## 2) الصفحة الرئيسية (Home)

- ✔ **الخروج من الستوري بطريقة غير زر X** (سحب لتحت، متل انستا) — موجود مع الحفاظ على زر X كمان.
  📍 [`lib/features/home/presentation/widgets/home_story_viewer.dart`](../lib/features/home/presentation/widgets/home_story_viewer.dart) — `onVerticalDragEnd` بيسكّر الستوري لما سرعة السحب لتحت > 420 (بالإضافة لزر Close الموجود).

- ✔ **أيقونات الرسائل + التنبيهات** — بنفس تصميم النسخة القديمة (فقاعتين متراكبتين للرسائل، جرس للتنبيهات)، مو أيقونات Material الافتراضية.
  📍 [`lib/shared/widgets/promoo_page_header.dart`](../lib/shared/widgets/promoo_page_header.dart) — `SvgPicture.asset('assets/brand/icons/chat.svg')` و`'assets/brand/icons/notification.svg'` بالهيدر (يظهر بكل الصفحات).

- ✔ **اللوجو الصحيح بدون كتابة تحته** — نفس نظام اللوجو أعلاه، بدون أي subtitle/tagline تحت الكلمة.
  📍 [`lib/shared/widgets/promoo_page_header.dart`](../lib/shared/widgets/promoo_page_header.dart) — `PromooLogo.full(width: 132, height: 40)`.

- ✔ **Top Offers: أكتر من 3 سلايدات + زر See All** — 5 سلايدات hero بحجم كامل الشاشة.
  📍 [`lib/features/home/presentation/screens/home_screen.dart`](../lib/features/home/presentation/screens/home_screen.dart) — `final topOffers = content.offers.take(5)`.
  📍 [`lib/features/home/presentation/widgets/home_preview_sections.dart`](../lib/features/home/presentation/widgets/home_preview_sections.dart) — `HomeOfferPreviewLayout.hero` + مؤشرات سلايد (`_CarouselIndicator`) + زر "See All" (`PromooSectionHeader.actionLabel`).

- ✔ **زر See All بكل أقسام الـ Home** — موجود بكل قسم بدون استثناء.
  📍 [`lib/features/home/presentation/screens/home_screen.dart`](../lib/features/home/presentation/screens/home_screen.dart) — `onSeeAll` مُمرَّر لـ: Stories، Top Offers، For You، Promoo of the Day، Services (بيروح كل واحد لصفحته/فلترته الصحيحة عبر `AppRoutes.homeSeeAll(...)` أو `AppRoutes.services`).

- ✔ **تصغير حجم صور الخدمات بالـ Home + زيادة عددها** — كروت أصغر (3 بعرض الشاشة تقريباً) بدل كارت كبير واحد، وعدد الخدمات المعروضة صار 5.
  📍 [`lib/features/home/presentation/widgets/home_preview_sections.dart`](../lib/features/home/presentation/widgets/home_preview_sections.dart) — `HomeServicesPreviewSection`: `height: 148`, `viewportFraction: 0.33`.
  📍 [`lib/features/home/data/dto/home_content_dto.dart`](../lib/features/home/data/dto/home_content_dto.dart) — بيانات fixture فيها 5 خدمات (`services: [...]`).

---

## 3) صفحة الخدمات (Services)

- ✔ **صور بدل الأيقونات لكل تصنيف** — نفس أسلوب التصميم القديم (صورة حقيقية لكل تصنيف بدل أيقونة رمزية).
  📍 [`lib/features/services/presentation/widgets/services_category_list.dart`](../lib/features/services/presentation/widgets/services_category_list.dart).

- ✔ **إزالة القسم تحت الخدمات + مربع بحث يُظهر النتائج أو "لا يوجد"** — القسم القديم (الثابت تحت) انشال، وصار في مربع بحث + عند البحث أو اختيار تصنيف يظهر إما النتائج أو رسالة صريحة بعدم الوجود.
  📍 [`lib/features/services/presentation/widgets/services_search_field.dart`](../lib/features/services/presentation/widgets/services_search_field.dart) — مربع البحث.
  📍 [`lib/features/services/presentation/screens/services_screen.dart`](../lib/features/services/presentation/screens/services_screen.dart) — `_ServicesEmptyState` (رسالة `'No service found.'` عند البحث/الفلترة، أو `'No services yet'` لو القسم فاضي أصلاً) + `_ResultsContextBar` (شريط رجوع للتصنيفات).

---

## 4) القائمة السفلية (Footer) — أيقونة P بدل Cup

- ✔ **علامة الـ P المرتفعة بالمنتصف صارت تودّي لصفحة Cup وتحمل اسم "Promoo"** بدل ما كانت تودّي لـ Services.
  📍 [`lib/shell/promoo_shell.dart`](../lib/shell/promoo_shell.dart) — `PromooShellTab(label: 'Promoo', route: AppRoutes.cup, ...)` هو التبويب رقم 3 (index 2، الـ P المرتفعة)؛ Services صارت تبويب عادي جنبه (index 4).
  📍 [`lib/routing/app_router.dart`](../lib/routing/app_router.dart) — `_selectedIndexForPath` مُحدَّث ليطابق الترتيب الجديد.
  > **ترتيب الفوتر الحالي:** Home · Influencer · **[P] Promoo (→Cup)** · Services · Profile.

---

## 5) شريط شفاف (Glass) عند التمرير للهيدر والفوتر

- ✔ **الفوتر** — كان شغّال من قبل (`_PromooBottomNavigation` بيتزجّج مع البلور تلقائياً حسب التمرير).
  📍 [`lib/shell/promoo_shell.dart`](../lib/shell/promoo_shell.dart).

- ✔ **الهيدر** — كان مثبّت وما بيتفاعل مع التمرير بمعظم الصفحات (Services / Cup / Profile)، صار يتزجّج فعلياً متل الهوم بالضبط (المحتوى يمرّ **تحت** الهيدر ويصير شفاف/مبلور).
  📍 [`lib/shared/state/shell_scroll_provider.dart`](../lib/shared/state/shell_scroll_provider.dart) — provider مشترك بيحفظ حالة "تم التمرير" (يقرأها الهيدر والفوتر مع بعض، ينصفّر عند تبديل التبويب).
  📍 [`lib/shared/widgets/promoo_page_header.dart`](../lib/shared/widgets/promoo_page_header.dart) — `PromooPinnedHeaderDelegate` (هيدر مثبّت كـ sliver بيكشف حالة overlap تلقائياً).
  📍 مطبَّق على: [`services_screen.dart`](../lib/features/services/presentation/screens/services_screen.dart)، [`leaderboard_screen.dart`](../lib/features/leaderboard/presentation/screens/leaderboard_screen.dart) (صفحة Cup)، [`profile_menu_screen.dart`](../lib/features/profile/presentation/screens/profile_menu_screen.dart).
  > ملاحظة: صفحة المؤثرين (Seats) شريط البحث/الفئات فيها ثابت مثل التصميم القديم بالتحديد (بند 6)، فهيدرها بيتفاعل بلون خفيف بس مش بتأثير الزجاج الكامل — إذا حابب نفس تأثير الزجاج فيها بالكامل، خبرنا.

---

## 6) صفحة المؤثرين (Influencer / الكراسي)

- ✔ **رجوع تصميم الكراسي للشكل القديم** — شبكة كراسي بالألوان (ذهبي/فضي/برونزي) بدل التصميم الجديد.
  📍 [`lib/features/seats/presentation/screens/seats_screen.dart`](../lib/features/seats/presentation/screens/seats_screen.dart) — `_SeatGrid` + الألوان حسب الفئة.

- ✔ **إبقاء القسم الأول (عدد الأشخاص + الكراسي المتاحة) بس بحجم أصغر.**
  📍 نفس الملف — `_StatsStrip` (شريط مضغوط "N Influencers / M Available seats").

- ✔ **إبقاء خيارات الكرسي الذهبي/الفضي/البرونزي بالصفحة.**
  📍 نفس الملف — `_SeatLegend` (Gold Seats / Silver Seats / Bronze Seats).

---

## 7) أيقونة البروفايل (Footer) → قائمة إعدادات

- ✔ **الضغط عليها بيفتح قائمة إعدادات** (متل النسخة القديمة): Following، Profile Management، Saved، My Packages، Support، اللغة، Logout.
  📍 [`lib/features/profile/presentation/screens/profile_menu_screen.dart`](../lib/features/profile/presentation/screens/profile_menu_screen.dart).

- ✔ **خيار البلاك/اللايت مود تحت خيارات اللغة مباشرة.**
  📍 نفس الملف — قسم "Language" (English/Arabic) متبوع مباشرة بقسم "Theme Mode" (Black Mode / Light Mode) بنفس الكارت.

---

## 8) صفحة البروفايل — عدد المتابعين واللايكات (أسلوب إنستغرام)

- ✔ **شريط إحصائيات بأسلوب انستغرام: Followers / Likes / Posts / Views.**
  📍 [`lib/features/profile/presentation/widgets/profile_stats_row.dart`](../lib/features/profile/presentation/widgets/profile_stats_row.dart) — `ProfileStatsRow` (بيختصر الأرقام الكبيرة تلقائياً، مثلاً `185.4K`).
  📍 [`lib/features/profile/presentation/screens/profile_screen.dart`](../lib/features/profile/presentation/screens/profile_screen.dart) — الصفحة العامة للبروفايل (cover + avatar + tags + bio + الإحصائيات + أزرار Follow/Message + الباقات).

---

## جدول ملخّص سريع

| # | البند | الحالة |
| --- | --- | --- |
| 1 | صفحة الدخول: زر ضيف + لوجو صحيح | ✔ ✔ |
| 2 | Home: سحب لإغلاق الستوري / أيقونات / لوجو / Top Offers 5 سلايد / See All بكل قسم / خدمات أصغر وأكتر | ✔ (6/6) |
| 3 | Services: صور تصنيفات + بحث/رسالة عدم وجود | ✔ ✔ |
| 4 | Footer: P → Cup باسم Promoo | ✔ |
| 5 | زجاجية الهيدر والفوتر عند التمرير | ✔ ✔ |
| 6 | صفحة المؤثرين: كراسي قديمة + شريط مصغّر + فئات ذهبي/فضي/برونزي | ✔ ✔ ✔ |
| 7 | أيقونة البروفايل → قائمة إعدادات + ثيم تحت اللغة | ✔ ✔ |
| 8 | بروفايل: إحصائيات بأسلوب إنستغرام | ✔ |

</div>
