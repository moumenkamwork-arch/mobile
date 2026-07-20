# خطوات تفعيل FCM Push Notifications (بالتفصيل الممل)

لقد قمنا بتجهيز الجانب المتبقي من تطبيق الموبايل ليكون قادراً على استلام إشعارات Push من الباك إند. في هذه الوثيقة، أستعرض كل ملف قمنا بتعديله وماذا فعلنا به بالضبط.

---

## 1. تعديلات ملفات الـ Gradle (الأندرويد)
لكي يتمكن تطبيق Flutter من استخدام خدمات Firebase، يجب ربط مكتبات Google Services بمشروع الأندرويد.

**الملف الأول: `android/settings.gradle.kts`**
> أضفنا الـ plugin الخاص بـ `google-services` إلى المشروع:
```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false // ← هذا السطر
}
```

**الملف الثاني: `android/app/build.gradle.kts`**
> فعلنا الـ plugin داخل التطبيق وأضفنا الـ Firebase BoM (Bill of Materials) لضمان توافق إصدارات مكاتب Firebase:
```kotlin
plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ← هذا السطر
}

// وفي الأسفل أضفنا:
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
}
```

---

## 2. إضافة مكتبات Flutter
قمنا بتنفيذ أمر `flutter pub add` لإضافة المكتبتين الأساسيتين للـ `pubspec.yaml`:
1. `firebase_core`: المكتبة الأساسية لتهيئة اتصال Firebase.
2. `firebase_messaging`: المكتبة المسؤولة عن الإشعارات الدافعة، استخراج التوكن، واستقبال الرسائل.

---

## 3. إنشاء خدمة `PushNotificationService`
قمنا بإنشاء ملف جديد في `lib/core/push/push_notification_service.dart`. هذا الملف هو "العقل المدبر" للإشعارات في الموبايل. وظيفته:
1. **طلب الصلاحيات:** يطلب إذن المستخدم لإظهار الإشعارات (خصوصاً على نظام iOS وأندرويد 13+).
2. **استخراج التوكن (`getToken`)**: يسأل Firebase عن التوكن المميز لهذا الهاتف بالذات.
3. **مراقبة حالة تسجيل الدخول (`ref.listen(authControllerProvider)`)**: بمجرد أن يسجل المستخدم دخوله بنجاح، تقوم الخدمة بطلب التوكن وإرساله فوراً إلى الباك إند عبر `repository.registerDeviceToken`.
4. **تحديث التوكن**: في حال انتهت صلاحية التوكن وقامت جوجل بتغييره، الخدمة تلتقط التغيير وترسله مجدداً للباك إند للحفاظ على استمرارية الإشعارات.
5. **استقبال الإشعارات (Foreground / Background)**: يحتوي على `FirebaseMessaging.onMessage` للتعامل مع الإشعارات بينما التطبيق مفتوح، ودالة `firebaseMessagingBackgroundHandler` للتعامل معها والتطبيق مغلق.

---

## 4. تهيئة Firebase عند بدء التطبيق (`main.dart`)
التطبيق يجب أن يتصل بسيرفرات Firebase قبل أن يرسم أي شاشة على الموبايل.
عدّلنا `lib/main.dart` وأضفنا:
```dart
  try {
    await Firebase.initializeApp(); // ← الاتصال بـ Firebase
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler); // ← تفعيل معالج الخلفية
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }
```

---

## 5. ربط الخدمة بدورة حياة التطبيق (`app.dart`)
بما أن خدمة الـ Push Notifications تعتمد على `Riverpod` للاستماع لتغيرات تسجيل الدخول، يجب أن نجعلها "تعمل" بشكل دائم بمجرد فتح التطبيق.
قمنا بتعديل `lib/app.dart`:
```dart
    // مراقبة الخدمة لتبقيها حية
    final pushService = ref.watch(pushNotificationServiceProvider);
    
    // تشغيل الدالة الابتدائية (التي تطلب الصلاحيات) بعد رسم أول فريم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pushService.init();
    });
```

---

## الخطوات اليدوية (تمت بنجاح)
- تم إنشاء التطبيق في Firebase Console باسم حزمة `com.MO2MIN.promoo_app`.
- تم تنزيل ملف `google-services.json` ووضعه في `android/app/google-services.json`.
- تم تحديث الـ Package Name في الـ `build.gradle.kts` ليتطابق مع ما تم إدخاله في الـ Firebase.
