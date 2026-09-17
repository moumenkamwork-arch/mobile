# تقرير استكشاف الأخطاء وإصلاحها وحل مشاكل بناء التطبيق (APK Build Troubleshooting Report)

تم إنشاء هذا المستند لتوضيح المشاكل التي واجهت عملية بناء نسخة الـ APK الخاصة بتطبيق **Promoo Mobile** وكيف تم حلها، مع ذكر الملفات المعدلة بالتفصيل لتسهيل تتبع أي مشاكل مستقبلية قد تطرأ بسبب هذه التغييرات.

---

## 1. المشاكل التي تم تحديدها وحلولها بالتفصيل

### المشكلة الأولى: تعارض إصدارات الـ Android SDK وSdkVersion في مكتبات Firebase و Secure Storage
* **السبب**: كانت بعض الحزم (مثل `flutter_secure_storage` و `firebase_messaging`) تتطلب إصدارات أحدث من Android SDK للعمل بشكل صحيح (الحد الأدنى للمشروع كان 21، بينما `firebase_messaging` تتطلب على الأقل 23، ومكتبة Secure storage تتطلب `compileSdk` بحدود 33+).
* **الحل**: 
  * قمنا بزيادة `compileSdk` إلى **36** في ملف إعدادات Gradle للتطبيق.
  * قمنا بزيادة `minSdk` للمشروع إلى **23** ليناسب متطلبات Firebase.
  * قمنا بتحديث إعدادات حقن الخصائص الفرعية (Subprojects block) لضمان تمرير إصدارات الـ SDK الصحيحة لكافة الحزم التابعة.
* **الملفات المعدلة**:
  * [android/app/build.gradle.kts](file:///e:/Personal%20Work%20Projects/promo_mobile/android/app/build.gradle.kts)
  * [android/build.gradle.kts](file:///e:/Personal%20Work%20Projects/promo_mobile/android/build.gradle.kts)

---

### المشكلة الثانية: أخطاء استيراد ملفات الترجمة واللغات (Localization - AppLocalizations)
* **السبب**: كانت العديد من شاشات وعناصر الواجهة (Widgets) تحتوي على استيراد نسبي خاطئ لملفات الترجمة مثل:
  ```dart
  import '../../../../l10n/app_localizations.dart';
  ```
  بما أن التطبيق يولد ملفات الترجمة بشكل تلقائي كحزمة اصطناعية (Synthetic Package) داخل مجلد `.dart_tool` بموجب إعدادات `l10n.yaml` الافتراضية، فإن المسارات النسبية داخل `lib/` لا تكون موجودة فعلياً وتؤدي لفشل الترجمة (Compilation Error).
* **الحل**: 
  * قمنا بإنشاء وتطوير سكربت Dart يقوم بالمرور على جميع ملفات الكود في مجلد `lib/` لتنظيف الاستيرادات النسبية الخاطئة للـ `app_localizations.dart`.
  * قمنا باستبدالها بالاستيراد الرسمي الصحيح من الحزمة المولدة:
    ```dart
    import 'package:flutter_gen/gen_l10n/app_localizations.dart';
    ```
* **الملفات المعدلة**: تم تعديل أكثر من 50 ملفاً برمجياً في الواجهات والتحكم عبر السكربت المؤتمت للتأكد من ربط الترجمة بشكل سليم.

---

### المشكلة الثالثة: عدم توافق متحكمات Riverpod مع نوع الـ Family (.family)
* **السبب**: عند تحديث حزمة Riverpod أو استخدام إصدارات معينة منها، فإن استخدام المزود من نوع عائلة (مثل `NotifierProvider.family`) يتطلب من كلاس التحكم (Controller) أن يرث من كلاس `FamilyNotifier` بدلاً من `Notifier` العادي، ويجب تمرير وسيط العائلة (Argument) مباشرة إلى الدالة `build`. كان الكود القديم يرث من `Notifier` ويمرر الباراميتر عبر الكونستركتور مما يسبب أخطاء عدم توافق في التايب (Type Mismatches).
* **الحل**:
  * قمنا بتحويل كافة الكلاسات التي تستخدم الـ family لترث من `FamilyNotifier` وتستقبل الباراميتر مباشرة في دالة الـ `build(Arg arg)` وتخزينه في خاصية داخلية إذا لزم الأمر.
* **الملفات المعدلة**:
  * [lib/features/services/presentation/controllers/service_detail_controller.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/services/presentation/controllers/service_detail_controller.dart)
  * [lib/features/chat/presentation/controllers/chat_room_controller.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/chat/presentation/controllers/chat_room_controller.dart)
  * [lib/features/home/presentation/controllers/home_content_detail_controller.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/home/presentation/controllers/home_content_detail_controller.dart)

---

### المشكلة الرابعة: تغييرات وخصائص قديمة وغير متوافقة في الـ SDK (Theme / Widgets)
* **السبب**:
  1. كلاسات الـ Theme مثل `CardTheme` و `DialogTheme` تغيرت طريقة تعريف خواصها أو تم تحديثها في نسخ الفلوتر الحالية.
  2. استخدام التابع `withValues(alpha: ...)` على الألوان والذي تسبب بفشل البناء لعدم دعمه في النسخة الحالية من SDK، وتطلب استبداله بـ `withOpacity(...)`.
  3. استخدام الميزة الحديثة `?parameter` كطريقة لتعريف القيم الاختيارية في الـ Map مثل `data: {'device_type': ?deviceType}` وهي صيغة غير صالحة في هذه النسخة من لغة Dart.
* **الحل**:
  * قمنا باستبدال `withValues` بـ `withOpacity`.
  * قمنا بتحديث صياغة العناصر الاختيارية بالـ Map لتصبح شرطية مدعومة رسمياً:
    ```dart
    data: {
      'token': token, 
      if (deviceType != null) 'device_type': deviceType
    }
    ```
  * قمنا بتحديث إعدادات كلاسات الـ `Theme` ليتوافق مع أحدث معايير الماتيريال ديزاين المدعومة في التطبيق.
* **الملفات المعدلة**:
  * [lib/theme/app_theme.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/theme/app_theme.dart)
  * [lib/app.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/app.dart)
  * [lib/features/notifications/data/datasources/notifications_remote_data_source.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/notifications/data/datasources/notifications_remote_data_source.dart)

---

### المشكلة الخامسة: أخطاء القبول بالقيمة Null (Non-promotable nullable fields)
* **السبب**: في الـ Widget المسمى `PromooListHeader` كان هنالك متغير من النوع `Widget? trailing` يتم فحصه للتأكد من أنه ليس نل عبر `if (trailing != null) trailing` ولكن بسبب كونه حقل عام (public field)، فإن الكومبايلر لا يستطيع ضمان ثبات قيمته (Promotion) وبالتالي يرفض تعيينه لـ List تتوقع نوعاً غير نل (`Widget`).
* **الحل**: تم حل المشكلة عن طريق استخدام المعامل غير النل الإجباري (`trailing!`) بعد التأكد التام من عدم كونه نل في الشرط:
  ```dart
  if (trailing != null) trailing!,
  ```
* **الملفات المعدلة**:
  * [lib/shared/widgets/promoo_list_header.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/shared/widgets/promoo_list_header.dart)

---

### المشكلة السادسة: خطأ في وسائط الـ DropdownButtonFormField
* **السبب**: في شاشة `add_ad_wizard_screen.dart` تم تمرير خاصية `initialValue` إلى الـ `DropdownButtonFormField` وهي خاصية غير موجودة في هذا الـ Widget، مما تسبب بخطأ في البناء.
* **الحل**: تم استبدال البرامتر `initialValue` بالبرامتر الصحيح `value`.
* **الملفات المعدلة**:
  * [lib/features/profile/presentation/screens/add_ad_wizard_screen.dart](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/profile/presentation/screens/add_ad_wizard_screen.dart)

---

### المشكلة السابعة: عدم توافق إصدارات Gradle و Android Gradle Plugin (AGP) مع إضافات Flutter الحديثة
* **السبب**: كانت نسخة الـ Gradle المستخدمة في المشروع (8.7.0) ونسخة الـ AGP (8.4.2) قديمة وغير مدعومة من قِبل إضافة Flutter (Flutter Gradle Plugin)، مما أدى إلى فشل البناء مع طلب صريح بضرورة التحديث إلى Gradle 8.14.0 و AGP 8.6.0 كحد أدنى.
* **الحل**:
  * قمنا بتحديث رابط تحميل توزيعة Gradle في ملف الـ Wrapper ليصبح الإصدار `8.14-all`.
  * قمنا بتحديث إصدار إضافة AGP (Android Gradle Plugin) في ملف الإعدادات الأساسي ليصبح `8.6.0`.
  * قمنا بتثبيت قيمة الـ `minSdk = 23` بشكل صريح (Hardcoded) في ملف بناء التطبيق بدلاً من الاعتماد على المتغير التلقائي `flutter.minSdkVersion` الذي كان لا يزال يعيد القيمة 21 ويسبب فشلاً بسبب تعارضه مع متطلبات Firebase.
* **الملفات المعدلة**:
  * `android/gradle/wrapper/gradle-wrapper.properties`
  * `android/settings.gradle.kts`
  * `android/app/build.gradle.kts`

---

## 2. جدول ملخص بالملفات المعدلة وطبيعة التعديل

| مسار الملف | الهدف من التعديل | المخاطر المستقبلية المتوقعة |
| :--- | :--- | :--- |
| `android/app/build.gradle.kts` | رفع `minSdk` إلى 23 و `compileSdk` إلى 36 بشكل صريح. | قد لا يعمل التطبيق على هواتف أندرويد القديمة جداً (أقل من إصدار Android 6.0). |
| `android/build.gradle.kts` | حقن الإصدارات والـ SDK لكافة المشاريع الفرعية التابعة للمكتبات. | قد يتعارض مع ميزات إعداد مشاريع أندرويد الحديثة جداً في حال تم تحديث Gradle لأرقام إصدارات ضخمة. |
| `android/settings.gradle.kts` | تحديث إصدار `agp` إلى `8.6.0` | توافقية مع إضافات Flutter. |
| `android/gradle/wrapper/gradle-wrapper.properties` | تحديث `distributionUrl` إلى `gradle-8.14-all.zip` | يحل مشكلة توافق بناء المشروع. |
| `lib/app.dart` & `lib/theme/app_theme.dart` | إصلاح إعدادات ثيمات الكروت والدايلوج، وحذف الميزات غير المتوافقة مع الألوان. | في حال تعديل الثيم مستقبلاً، يجب مراعاة استخدام الأساليب القياسية المتوافقة مع Flutter SDK الحالي. |
| `lib/features/services/presentation/controllers/service_detail_controller.dart` | استخدام `FamilyNotifier` للـ details. | أي تغيير في نوع بيانات الـ Request الممرر مستقبلاً سيتطلب تعديل دالة الـ build الخاصة بالـ Controller. |
| `lib/features/chat/presentation/controllers/chat_room_controller.dart` | استخدام `FamilyNotifier` لغرف الدردشة. | نفس الملاحظة السابقة عند تغيير صيغة البارامترات الخاصة بالـ ChatRoom. |
| `lib/features/home/presentation/controllers/home_content_detail_controller.dart` | استخدام `FamilyNotifier` لتفاصيل محتوى الشاشة الرئيسية. | نفس الملاحظة السابقة عند تغيير صيغة الـ HomeContentDetail. |
| `lib/features/notifications/data/datasources/notifications_remote_data_source.dart` | تعديل الـ map وصياغة تمرير الـ token للـ API بشكل متوافق. | تأكد دائماً أن API الباك إند يستقبل `device_type` كباراميتر اختياري بدون أي مشاكل. |
| `lib/shared/widgets/promoo_list_header.dart` | تصحيح تمرير الـ trailing widget غير النل عبر `trailing!`. | إذا تم تغيير المتغير ليكون غير نهائي أو تمت وراثته بطريقة مغايرة قد يتطلب كوداً مختلفاً للتأكيد. |
| `lib/features/profile/presentation/screens/add_ad_wizard_screen.dart` | تصحيح بارامتر الـ `DropdownButtonFormField` من `initialValue` إلى `value`. | لا توجد مخاطر متوقعة. |
| ملفات الواجهات المتعددة (ملفات الـ View والـ Widget) | تعديل استيراد الـ الترجمات ليصبح من الحزمة المولدة تلقائياً بدلاً من مجلد نسبى. | عند تشغيل التطبيق محلياً لأول مرة أو بعد مسح الذاكرة المؤقتة، يجب دائماً تشغيل `flutter pub get` أو `flutter gen-l10n` لتوليد ملفات الترجمة محلياً لكي تختفي أي أخطاء استيراد. |

---

## 3. خطة التحقق والوقاية في المستقبل (Safety Checklist)

إذا واجهت أي مشاكل في بناء التطبيق مستقبلاً، تأكد من الخطوات التالية:
1. **تحديث ملفات الترجمة**: تأكد من تشغيل أمر توليد الترجمات لضمان توليد الكلاس `AppLocalizations`:
   ```bash
   flutter gen-l10n
   ```
2. **توافق إصدار الـ SDK**: عند إضافة أي حزمة أو مكتبة جديدة إلى ملف `pubspec.yaml` وتسببها في فشل عملية البناء، راجع ملف `android/app/build.gradle.kts` للتأكد من أن الـ `minSdk` والـ `compileSdk` ملائمين لمتطلبات هذه الحزمة الجديدة.
3. **أخطاء الـ Riverpod Family**: تذكر دائماً أن أي كلاس تحكم بروجكت فلوتر محدد له عائلة (`.family`) يجب أن يرث من كلاس `FamilyNotifier` ويستقبل متغير التعريف بالـ `build` الخاص به وليس عبر الـ constructor.
