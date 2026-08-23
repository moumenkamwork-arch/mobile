# Shorebird — دليل مرجعي لأي مشروع Flutter

هذا الملف مرجع **قابل لإعادة الاستخدام** لإعداد [Shorebird](https://docs.shorebird.dev) (OTA code push) في أي مشروع Flutter، بنفس الطريقة المطبّقة في هذا المشروع.

> **الفكرة:** Release واحد يُرفع للمتجر → بعدها تصلحات Dart تُرسل عبر `shorebird patch` بدون انتظار مراجعة المتجر (ضمن حدود Shorebird: Dart/assets فقط، لا native code).

---

## متى تستخدم Shorebird؟

| مناسب | غير مناسب (يحتاج release جديد للمتجر) |
|--------|----------------------------------------|
| إصلاح bugs في Dart | تغيير `AndroidManifest` / Gradle |
| تعديل UI / منطق التطبيق | إضافة/تحديث plugins native |
| تحديث dependencies Dart | تغيير `Info.plist` / entitlements |
| تعديل assets مضمّنة في Flutter | تغيير `applicationId` / Bundle ID |

---

## المتطلبات

- Flutter 3.24+ (أو ما يتوافق مع Shorebird حسب `shorebird doctor`)
- Git
- حساب مجاني على [Shorebird Console](https://console.shorebird.dev)
- المشروع يبني محلياً بدون أخطاء: `flutter build apk` أو `flutter build ios`

---

## الخطوة 1 — تثبيت Shorebird CLI

### macOS / Linux

```bash
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash
```

### Windows (PowerShell)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -UseBasicParsing 'https://raw.githubusercontent.com/shorebirdtech/install/main/install.ps1' | iex
```

أعد فتح الطرفية ثم:

```bash
shorebird doctor
shorebird --version
```

---

## الخطوة 2 — تسجيل الدخول

```bash
shorebird login
```

يفتح المتصفح للمصادقة. بعد النجاح:

```bash
shorebird account
```

---

## الخطوة 3 — تهيئة المشروع (`shorebird init`)

من **جذر** مشروع Flutter:

```bash
cd /path/to/your_flutter_project
flutter pub get
shorebird init
```

### ماذا يفعل `shorebird init`؟

1. ينشئ `app_id` فريداً للتطبيق على خوادم Shorebird
2. ينشئ ملف `shorebird.yaml` في جذر المشروع
3. يضيف `shorebird.yaml` إلى `assets` في `pubspec.yaml` تلقائياً

### مثال `shorebird.yaml` (بعد init)

```yaml
# This file is used to configure the Shorebird updater used by your app.
# Learn more at https://docs.shorebird.dev
# This file does not contain any sensitive information and should be checked into version control.

# Your app_id is the unique identifier assigned to your app.
# It is used to identify your app when requesting patches from Shorebird's servers.
# It is not a secret and can be shared publicly.
app_id: YOUR-APP-UUID-HERE

# auto_update controls if Shorebird should automatically update in the background on launch.
# If auto_update: false, you will need to use package:shorebird_code_push to trigger updates.
# https://pub.dev/packages/shorebird_code_push
# Uncomment the following line to disable automatic updates.
# auto_update: false
```

> **مهم:** ارفع `shorebird.yaml` إلى Git. الـ `app_id` ليس سراً.

### مشروع بـ Flavors

إذا كان لديك flavors (dev/staging/prod):

```bash
shorebird init
```

سيُنشئ `app_id` لكل flavor داخل نفس الملف:

```yaml
app_id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
flavors:
  development: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  production: yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy
```

---

## الخطوة 4 — إضافة الحزمة في `pubspec.yaml`

```bash
flutter pub add shorebird_code_push
```

تأكد أن `shorebird.yaml` مضاف تحت `assets` (عادة `shorebird init` يفعل ذلك):

```yaml
flutter:
  assets:
    - shorebird.yaml
    # ... باقي assets
```

---

## الخطوة 5 — دمج التحديث في `main.dart`

نفس النمط المستخدم في هذا المشروع: فحص صامت عند الإقلاع، بدون تعطيل التطبيق عند الفشل.

### 5.1 الاستيراد

```dart
import 'package:shorebird_code_push/shorebird_code_push.dart';
```

### 5.2 في `State` الخاص بـ `MaterialApp` (StatefulWidget)

```dart
class _MyAppState extends State<MyApp> {
  final ShorebirdUpdater _shorebirdUpdater = ShorebirdUpdater();

  @override
  void initState() {
    super.initState();
    _checkShorebirdUpdateInBackground();
    // ... باقي initState
  }

  Future<void> _checkShorebirdUpdateInBackground() async {
    if (!_shorebirdUpdater.isAvailable) return;

    try {
      final status = await _shorebirdUpdater.checkForUpdate();
      if (status != UpdateStatus.outdated) return;

      await _shorebirdUpdater.update();
    } on Object catch (e) {
      // لا تعطل التطبيق — سجّل فقط
      debugPrint('Shorebird update check failed: $e');
    }
  }

  // ...
}
```

### 5.3 ملاحظات التكامل

- **`isAvailable`:** يكون `false` في debug builds العادية (`flutter run`) — Shorebird يعمل مع builds من `shorebird release` / `shorebird patch`.
- **متى يظهر الـ patch:** عادة بعد **إعادة تشغيل** التطبيق (cold start).
- **Force update من المتجر:** Shorebird **لا يستبدل** شاشة التحديث الإجباري من Google Play / App Store. استخدمهما معاً:
  - **Store version gate** → تحديث إجباري عند تغيير native أو breaking changes
  - **Shorebird patch** → hotfix سريع لـ Dart/UI

---

## الخطوة 6 — أول Release (أساس الـ patches)

قبل أي patch، يجب إنشاء **release** مطابق لما سترفعه للمتجر.

```bash
flutter clean
flutter pub get
shorebird doctor
```

### Android

```bash
shorebird release android
```

ينتج AAB/APK حسب إعدادات المشروع. ارفع نفس البناء للمتجر (Play Console).

### iOS

```bash
shorebird release ios
```

ثم ارفع عبر Xcode / Transporter كالمعتاد.

### مع Flavor + entry point

```bash
shorebird release android --flavor production --target lib/main_prod.dart
shorebird release ios --flavor production --target lib/main_prod.dart
```

### تحديد إصدار Flutter (اختياري)

```bash
shorebird release android --flutter-version=3.24.0
```

---

## الخطوة 7 — إرسال Patch (OTA)

بعد تعديل كود Dart (أو assets):

1. ارفع `version` في `pubspec.yaml` إن لزم (للتتبع — الـ patch يرتبط بـ release version)
2. اختبر محلياً:

```bash
flutter test
flutter analyze
```

3. أنشئ الـ patch:

```bash
# Android
shorebird patch android

# iOS
shorebird patch ios

# مع flavor
shorebird patch android --flavor production --target lib/main_prod.dart
```

4. المستخدمون على **نفس release version** يستلمون الـ patch عند التشغيل التالي.

---

## الخطوة 8 — أوامر يومية (مرجع سريع)

| الهدف | الأمر |
|--------|--------|
| التحقق من البيئة | `shorebird doctor` |
| تحديث CLI | `shorebird upgrade` |
| Release Android | `shorebird release android` |
| Release iOS | `shorebird release ios` |
| Patch Android | `shorebird patch android` |
| Patch iOS | `shorebird patch ios` |
| معاينة release محلياً | `shorebird preview` |
| قائمة releases | `shorebird releases list` |
| قائمة patches | `shorebird patches list` |

---

## Checklist — مشروع Flutter جديد

انسخ هذا القسم وأعطه لأي مشروع أو Agent:

```markdown
- [ ] 1. تثبيت Shorebird CLI + `shorebird doctor`
- [ ] 2. `shorebird login`
- [ ] 3. من جذر المشروع: `flutter pub get` ثم `shorebird init`
- [ ] 4. التحقق من وجود `shorebird.yaml` في الجذر وفي `pubspec.yaml` → assets
- [ ] 5. `flutter pub add shorebird_code_push`
- [ ] 6. إضافة `_checkShorebirdUpdateInBackground()` في `main.dart` (انظر SHOREBIRD.md)
- [ ] 7. `shorebird release android` و/أو `shorebird release ios`
- [ ] 8. رفع نفس البناء للمتجر
- [ ] 9. بعد أي fix في Dart: `shorebird patch android` / `shorebird patch ios`
- [ ] 10. Commit: `shorebird.yaml` + تغييرات `pubspec.yaml` + `main.dart`
```

---

## CI/CD (اختياري)

Shorebird يدعم CI عبر token:

```bash
shorebird login:ci
```

احفظ الـ token في secrets (GitHub Actions / GitLab CI) ثم:

```yaml
# مثال مبسّط — GitHub Actions
- name: Shorebird Patch Android
  env:
    SHOREBIRD_TOKEN: ${{ secrets.SHOREBIRD_TOKEN }}
  run: shorebird patch android --release-version latest
```

راجع [Shorebird CI docs](https://docs.shorebird.dev/ci/) للتفاصيل الكاملة.

---

## استكشاف الأخطاء

| المشكلة | الحل |
|---------|------|
| `isAvailable == false` | شغّل build من `shorebird release` وليس `flutter run` فقط |
| Patch لا يصل | تأكد أن المستخدم على **نفس release version** المُ patched |
| `shorebird init` يفشل | أصلح `flutter build` أولاً؛ راجع Gradle/Xcode |
| تعارض مع force update | Store gate للنسخ الكبيرة؛ Shorebird للـ hotfix |
| iOS لا يطبّق patch | تأكد أن release iOS مُنشأ عبر `shorebird release ios` |

```bash
shorebird doctor -v
flutter doctor -v
```

---

## مرجع هذا المشروع (Barghut / Kotob)

| العنصر | القيمة / المسار |
|--------|------------------|
| Config | `shorebird.yaml` |
| Package | `shorebird_code_push: ^2.0.5` |
| Runtime check | `lib/main.dart` → `_checkShorebirdUpdateInBackground()` |
| App ID (مثال) | `909cbb0f-4b45-4b0d-bd2c-9b6497694ddc` |

> **تحذير:** كل مشروع جديد يحصل على `app_id` **خاص به** عند `shorebird init`. لا تنسخ `app_id` من مشروع لآخر.

---

## Prompt جاهز لـ Cursor / Agent

انسخ النص التالي إلى أي مشروع Flutter:

```
طبّق Shorebird OTA على هذا المشروع حسب docs/SHOREBIRD.md (أو الملف المرفق):

1. shorebird init (إن لم يكن shorebird.yaml موجوداً)
2. flutter pub add shorebird_code_push
3. تأكد من assets: shorebird.yaml في pubspec.yaml
4. أضف _checkShorebirdUpdateInBackground() في main.dart كما في الدليل
5. لا تغيّر applicationId / Bundle ID / Firebase
6. بعد الانتهاء: اذكر أوامر shorebird release و patch للمنصات المتاحة

اتبع نفس نمط barghut_app: فحص صامت عند الإقلاع، بدون blocking UI عند فشل Shorebird.
```

---

## روابط رسمية

- [Shorebird Docs](https://docs.shorebird.dev)
- [Initialize](https://docs.shorebird.dev/code-push/initialize/)
- [Create a Release](https://docs.shorebird.dev/code-push/release/)
- [Create a Patch](https://docs.shorebird.dev/code-push/patch/)
- [shorebird_code_push package](https://pub.dev/packages/shorebird_code_push)
