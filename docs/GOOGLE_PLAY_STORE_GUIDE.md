<div dir="rtl">

# دليل رفع Promoo على Google Play Store

هاد دليل خطوة بخطوة مخصص لمشروع Promoo تحديداً (مو دليل عام) — مبني على فحص حقيقي لإعدادات المشروع الحالية بتاريخ 2026-07-25.

---

## حالة التقدّم (محدّثة 2026-07-26)

| الموضوع | الحالة |
|---|---|
| اسم الحزمة (`applicationId`) | ✅ **قرّرنا وطبّقناه**: `com.promoo.app` — تغيّر فعلياً بـ `build.gradle.kts` + مجلد الكود Kotlin + `MainActivity.kt` (وكمان macOS، لقيناها ناقصة وصلحناها). بناء تجريبي (`flutter build apk --debug`) نجح. |
| Firebase (أندرويد) | ✅ مشروع Firebase جديد (`promoo-9d3f1`)، تطبيق أندرويد مسجّل بـ`com.promoo.app`، `google-services.json` بمكانه الصح. |
| مفاتيح Firebase بالباك اند (`.env`) | ✅ محدّثة، اتفحصت (السيرفر اشتغل صحي بدون أخطاء). |
| **التوقيع (Keystore)** | ✅ **خلص بالكامل ومتحقق منو مرتين** — `promoo-release.jks` مولّد، `key.properties` مربوط بـ`build.gradle.kts`، بنينا `.aab` كامل (58.3MB) وتأكدنا من الشهادة مباشرة (`keytool -printcert`) إنو موقّع فعلياً بالمفتاح الجديد مو debug. صاحب المشروع جرّب كلمة السر بنفسه (`keytool -list -v`) ونجحت. |
| رقم النسخة | ⬜ جاهز حسب الافتراضي (`1.0.0+1`)، ما يحتاج تغيير هلق. |
| سياسة الخصوصية + Data Safety Form | ⬜ لسا ما اتعملوا — **هاد الخطوة الجاية**. |
| حساب Google Play Console | ⬜ لسا ما اتعمل. |

⚠️ **تذكير مهم**: انسخ ملف `android/promoo-release.jks` + كلمتي السر (keystore + key) لمكان آمن منفصل عن هالجهاز (مدير كلمات سر، أو نسخة Drive خاصة) — هاد الملف لو ضاع بدون نسخة احتياطية بيصير تحديث التطبيق مستقبلاً معقّد جداً.

*(الآيفون مؤجّل مؤقتاً بقرار المالك — كل التفاصيل بملف `APPLE_APP_STORE_GUIDE.md` المنفصل، ما رح تتخلط هون.)*

---

## 0) أول شي: شو ناقص فعلياً قبل ما تقدر ترفع

فحصت الإعدادات الحالية بـ `android/app/build.gradle.kts` ولقيت هاي النقاط **لازم تتحل قبل أي رفع فعلي** (مو اختيارية):

| الموضوع | الوضع الحالي | ليش مشكلة |
|---|---|---|
| ~~**التوقيع (Signing)**~~ | ✅ **خلص** — `signingConfigs.getByName("release")` بمفتاح `promoo-release.jks` الحقيقي | — |
| ~~اسم الحزمة~~ | ✅ **خلص — `com.promoo.app`** | — |
| **رقم النسخة** | `1.0.0+1` (بملف `pubspec.yaml`) | جاهز، بس لازم تفهم آلية الترقيم (شرح بخطوة 4). |
| **أيقونة التطبيق** | ✅ موجودة ومولّدة عبر `flutter_launcher_icons` (مو الأيقونة الافتراضية) | تمام، ما في شي مطلوب هون. |
| **صلاحيات التطبيق** | `INTERNET`, `CAMERA` معرّفين بـ `AndroidManifest.xml` | تمام. |
| **سياسة الخصوصية (Privacy Policy)** | ما لقيت صفحة ويب حقيقية أو رابط منشور | **Google Play يفرض رابط سياسة خصوصية منشور وشغال** (مش بس شاشة جوا التطبيق) — لازم تجهزها قبل خطوة "معلومات المتجر". |
| **Data Safety Form** | ما اتعبى لسا (بتتعبى من داخل Play Console) | إلزامي — لازم تعرف بالضبط شو بيانات بتجمعها (إيميل، صور، موقع؟ إلخ) قبل ما توصلها. |

---

## 1) إنشاء حساب Google Play Console

1. روح لـ [play.google.com/console](https://play.google.com/console).
2. سجل بحساب Google (يفضل حساب مخصص للشركة/المشروع، مو حسابك الشخصي).
3. ادفع رسوم التسجيل — **25 دولار مرة وحدة فقط** (مو اشتراك سنوي).
4. عبّي معلومات المطوّر (اسم، بلد، إيميل تواصل) — Google بتطلب أحياناً تحقق هوية (D-U-N-S أو هوية شخصية) قبل ما تقدر تنشر، هاد ممكن ياخد كم يوم فحص. ابلشها بدري.

---

## 2) تجهيز مفتاح التوقيع (Keystore) — ✅ خلص بالكامل (2026-07-26)

هاد المفتاح **بيوقع كل نسخة رح ترفعها لباقي عمر التطبيق** — لو ضاع، تحديث التطبيق مستقبلاً بيصير معقّد جداً. **⚠️ لسا ما نُسخ لمكان آمن خارج هالجهاز — لازم يصير قبل ما تنسى.**

### أ) المفتاح مولّد فعلياً
```powershell
cd android
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore promoo-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias promoo-upload
```
- **الملف**: `android/promoo-release.jks` (موجود، 2790 بايت).
- **Alias**: `promoo-upload`
- **صالح لغاية**: 11 ديسمبر 2053.
- **تحقّقنا مرتين**: مرة عبر `keytool -printcert -jarfile app-release.aab` (تأكيد إنو الـ`.aab` موقّع فعلياً بهالمفتاح)، ومرة صاحب المشروع بنفسه جرّب كلمة السر بـ`keytool -list -v -keystore promoo-release.jks` ونجحت.

### ب) الربط بمشروع Flutter — خلص
ملف `android/key.properties` موجود (محمي بـ`.gitignore` — لا `key.properties` ولا `*.jks` بينرفعوا عالـgit):
```properties
storePassword=<كلمة سر الـ keystore>
keyPassword=<كلمة سر الـ alias>
keyAlias=promoo-upload
storeFile=promoo-release.jks
```

### ج) `android/app/build.gradle.kts` — معدّل ومربوط فعلياً
```kotlin
import java.util.Properties
import java.io.FileInputStream

// ... plugins { ... }

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... باقي الإعدادات متل ما هي

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { rootProject.file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```
*(ملاحظة: استخدمنا `rootProject.file(it)` مو `file(it)` العادي — عشان `storeFile` بملف الـproperties مسار نسبي (`promoo-release.jks` بس)، ولازم ينحل نسبة لمجلد `android/` يلي فيه الملفين، مو نسبة لـ`android/app/`.)*

---

## 3) اسم الحزمة — ✅ خلصت (2026-07-26)

قررنا `com.promoo.app` وطبّقناه بالكامل:
1. ✅ `applicationId` و`namespace` بـ `android/app/build.gradle.kts`.
2. ✅ مجلد الكود Kotlin انتقل لـ `android/app/src/main/kotlin/com/promoo/app/MainActivity.kt` (وتصحيح الـ `package` جواه).
3. ✅ مشروع Firebase جديد (`promoo-9d3f1`) وتطبيق أندرويد مسجّل فيه بنفس الاسم، `google-services.json` بمكانه.
4. ✅ مفاتيح الباك اند (`FIREBASE_PROJECT_ID`/`FIREBASE_CLIENT_EMAIL`/`FIREBASE_PRIVATE_KEY`) محدّثة بـ `.env`.
5. ✅ بناء تجريبي (`flutter build apk --debug`) نجح بدون أي مشاكل.

**نفس الاسم (`com.promoo.app`) هيك استخدمناه لآيفون كمان (Bundle Identifier بـXcode) للتناسق — تفاصيل الآيفون بملف `APPLE_APP_STORE_GUIDE.md` المؤجّل مؤقتاً.**

هالقرار نهائي الآن — بعد أول نشر عالمتجر ما رح نقدر نغيّرو.

---

## 4) رقم النسخة (Versioning)

بملف `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
الصيغة: `<versionName>+<versionCode>` → `1.0.0` هو الرقم يلي المستخدم بيشوفه بالمتجر، و`1` هو `versionCode` (رقم داخلي لازم يزيد بكل رفعة جديدة، Google بترفض رفعة برقم أقل من أو يساوي آخر رفعة).

لأي تحديث مستقبلي: زيد الرقم الثاني دايماً (`1.0.0+2`، `1.0.1+3`، إلخ) قبل ما تبني نسخة جديدة.

---

## 5) ابنِ الـ App Bundle — ✅ خلص، جاهز للرفع

Google Play بيطلب صيغة `.aab` (Android App Bundle) مو `.apk` مباشرة (الـ APK لسا مفيد للاختبار المحلي بس). بنينا فعلياً:

```powershell
cd "E:\Personal Work Projects\promo_mobile"
$env:PATH += ";C:\flutter_sdk\flutter\bin"
flutter clean
flutter pub get
flutter build appbundle --release
```

الناتج موجود فعلياً بـ:
```
build/app/outputs/bundle/release/app-release.aab   (58.3MB)
```
**تحقّقنا إنو موقّع صح** (مو بمفتاح debug بالغلط) عبر `keytool -printcert -jarfile app-release.aab` — الشهادة طابقت مفتاح `promoo-release.jks`.

**قبل الرفع النهائي** — يفضّل تجربه محلياً كـ APK عالموبايل كمان (أحياناً في فرق سلوك بين debug و release):
```powershell
flutter build apk --release
flutter install --release
```

**تذكير لأي بناء جديد لاحقاً**: نفس أمر `flutter build appbundle --release` رح يستخدم تلقائياً نفس مفتاح `promoo-release.jks` (مربوط بـ`build.gradle.kts` من قسم 2) — ما في داعي تعيد أي إعداد، بس تأكد رفعت رقم النسخة أول (قسم 4).

---

## 6) أنشئ التطبيق بـ Play Console

1. من Play Console → **"Create app"**.
2. اسم التطبيق (اللي رح يظهر للمستخدمين) — ممكن يكون مختلف عن `applicationId`.
3. اللغة الافتراضية (اقترح: العربية + إنجليزي كلغة إضافية بعدين).
4. نوع التطبيق: App / Game → App. مجاني أو مدفوع → غالباً مجاني.
5. عبّي إقرارات السياسات الأولية (كلها checkboxes بسيطة).

---

## 7) عبّي "معلومات المتجر" (Store Listing) — هاد أطول جزء

من قسم **"Grow" → "Store presence" → "Main store listing"**:

- **عنوان قصير** (30 حرف): "Promoo"
- **وصف قصير** (80 حرف): ملخص سطر واحد عن التطبيق.
- **وصف كامل** (4000 حرف): اشرح فيه Offers + Services + المؤثرين + المقاعد، إلخ.
- **صور الشاشة (Screenshots)**: على الأقل 2 لكل نوع جهاز (Phone إلزامي، Tablet اختياري) — خدها من التطبيق الشغال (استخدم المحاكي أو جهاز حقيقي، `flutter run --release` وبعدين لقط شاشة).
- **أيقونة عالية الدقة**: 512×512 (عندك أصلاً الأصل بـ `assets/brand/new_logo/launcher_icon.png` — تأكد إنو بالدقة الكافية).
- **صورة Feature Graphic**: 1024×500 (بانر عرضي، لازم تصممه لو مو موجود).
- **رابط سياسة الخصوصية**: لازم رابط ويب فعلي شغال (استضف صفحة بسيطة — حتى GitHub Pages أو أي استضافة مجانية تكفي).
- **تصنيف المحتوى (Content Rating)**: قسم منفصل بـ Play Console، فيه استبيان (عنف، محتوى بالغين، دردشة بين مستخدمين — بما إنو فيه شات لازم تجاوب صح عليه).
- **Data Safety**: استبيان يسألك شو بيانات بتجمعها (إيميل، اسم، صور، موقع) ووين بتتخزن (Supabase) وهل بتنشاركها مع طرف ثالث. جاوب بأمانة حسب الباك اند الفعلي (البروفايل، الشات، الإشعارات...).
- **فئة التطبيق**: Business / Lifestyle / Social (اختار الأقرب).
- **بيانات تواصل**: إيميل دعم فعلي.

---

## 8) ارفع الـ Bundle (ابدأ بـ Internal Testing، مش مباشرة Production)

1. من **"Test and release" → "Testing" → "Internal testing"**.
2. أنشئ "release" جديد، ارفع ملف `app-release.aab`.
3. ضيف "testers" (إيميلات Gmail لك ولأي حدا بدك يجرب معك) بقائمة الـ Internal testers.
4. Google بتعطيك رابط اختبار — أي حدا بالقائمة بيقدر يحمّل التطبيق مباشرة بدون انتظار مراجعة (الـ Internal testing ما بيحتاج مراجعة Google تقريباً، بيطلع بدقائق).
5. جرّب كويس هون قبل ما تفكر بالنشر الحقيقي.

---

## 9) الترقية للنشر الفعلي (Production)

بعد ما تتأكد كلشي شغال بالـ Internal testing:
1. **"Production" track** → أنشئ release جديد، ارفع نفس الـ `.aab` (أو نسخة أحدث لو عدلت شي).
2. اختار الدول يلي بدك التطبيق يظهر فيها.
3. قدّم للمراجعة (Submit for review).
4. مراجعة Google عادة بتاخد من ساعات لحتى يوم-يومين لأول رفعة (ممكن تطول أكتر لو فيه صلاحيات حساسة زي الكاميرا).
5. بعد الموافقة، التطبيق بيصير حي على المتجر تلقائياً (أو بتاريخ تحدده انت لو اخترت "Managed publishing").

---

## 10) لأي تحديث مستقبلي (checklist سريع)

1. زيد رقم الـ `version` بـ `pubspec.yaml` (الجزء بعد الـ `+`).
2. `flutter build appbundle --release`.
3. ارفع الـ `.aab` الجديد بـ Play Console (نفس الـ app، "Create new release" بأي track).
4. اكتب "Release notes" (شو تغيّر بهالنسخة).
5. قدّم للمراجعة.

</div>
