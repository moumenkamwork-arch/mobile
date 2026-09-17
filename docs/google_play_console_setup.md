<div dir="rtl">

# إعدادات رفع Promoo على Google Play Console

دليل عملي للقيم الحالية في المشروع + خطوات التوقيع وبناء الـ AAB وملء Play Console.

---

## 1) قيم التطبيق الحالية (من الكود)

| البند | القيمة |
|---|---|
| Application ID / Package name | `com.promoo.app` |
| اسم التطبيق (label) | `Promoo` |
| versionName | `1.0.0` (من `pubspec.yaml`) |
| versionCode | `1` (الرقم بعد `+` في `version: 1.0.0+1`) |
| compileSdk | `36` |
| الأذونات المعلنة | `INTERNET`, `CAMERA` |
| Firebase | `android/app/google-services.json` موجود |
| نوع ملف الرفع المطلوب | **Android App Bundle** (`.aab`) — مو APK للإنتاج |

> عند كل رفع جديد: زِد `versionCode` على الأقل (مثلاً `1.0.0+2` ثم `1.0.1+3`).

---

## 2) توقيع الإصدار (مطلوب قبل البناء)

المشروع جاهز لقراءة التوقيع من `android/key.properties` (انظر `android/app/build.gradle.kts`). الملف غير موجود بعد — لازم تنشئه محلياً.

### أ) إنشاء مفتاح الرفع (مرة واحدة — احفظه بأمان)

من مجلد `android/`:

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

احفظ كلمة المرور والـ alias في مكان آمن. ضياع المفتاح يمنع تحديث نفس التطبيق على Play (إلا إذا فعّلت Play App Signing مسبقاً واحتفظت بمفتاح الرفع).

### ب) إنشاء `android/key.properties`

انسخ المثال:

```bash
cp android/key.properties.example android/key.properties
```

عدّل القيم:

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=upload-keystore.jks
```

ضع `upload-keystore.jks` بجانب `key.properties` داخل `android/` (كلاهما في `.gitignore`).

---

## 3) بناء ملف الرفع (AAB)

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

الملف الناتج:

`build/app/outputs/bundle/release/app-release.aab`

ارفع هذا الملف إلى Play Console → **Testing** (Internal أولاً) ثم Production لاحقاً.

---

## 4) ملء Play Console — قائمة سريعة

### إنشاء التطبيق
- App name: **Promoo**
- Default language: اختر (مثلاً English أو Arabic)
- App / Game: **App**
- Free / Paid: حسب قرار المنتج

### Store listing (حد أدنى)
- Short description (≤ 80 حرف)
- Full description
- App icon: 512×512
- Feature graphic: 1024×500
- Phone screenshots: على الأقل صورتان
- Contact email (دعم)
- Privacy policy URL (**إلزامي** إذا فيه تسجيل/بيانات مستخدمين — وهذا التطبيق فيه)

### App content / Declarations (طابق السلوك الفعلي)
- **Ads**: لا (ما لم تُضَف إعلانات)
- **Target audience**: حدد الفئة العمرية المناسبة
- **Content rating**: أكمل الاستبيان
- **News / COVID / Financial**: لا ما لم ينطبق
- **Data safety**: صرّح بجمع الحساب، التوكنات، الصور (كاميرا/أفاتار)، الإشعارات (FCM)، الشبكة، وخدمات الطرف الثالث (Firebase / Supabase / إلخ)
- **Permissions**: برّر `CAMERA` (رفع صورة الملف الشخصي) و`INTERNET`

### Testing قبل Production
1. Internal testing track
2. ارفع الـ AAB
3. أضف مختبرين
4. بعد الاستقرار → Closed/Open ثم Production (يفضّل staged rollout)

---

## 5) بيانات مراجعة Google (مهمة)

لأن التطبيق فيه تسجيل دخول، جهّز في **App access**:
- حساب تجريبي (إيميل + كلمة مرور) يعمل على بيئة الإنتاج
- ملاحظات مختصرة للمراجع: كيف يسجّل الدخول وأين يجد الوظائف الأساسية

---

## 6) تحذيرات قبل الرفع

1. **سياسة الدفع**: أي ميزة رقمية داخل التطبيق قد تتطلب Google Play Billing بدل Stripe المباشر — راجع `docs/PUBLISHING_CLIENT_REQUIREMENTS.md`.
2. **لا ترفع** نسخة موقّعة بمفتاح debug (بدون `key.properties` البناء الحالي قد يستخدم debug — غير مقبول للإنتاج).
3. **لا ترفع** أسرار (`key.properties`, `.jks`, `.env`) إلى Git.
4. تأكد أن backend الإنتاج ورابط سياسة الخصوصية شغالين قبل Production.

---

## 7) أوامر تحقق سريعة

```bash
# هل ملف التوقيع موجود؟
test -f android/key.properties && echo "signing ready" || echo "missing key.properties"

# بناء الـ AAB
flutter build appbundle --release

# مسار الملف
ls -lh build/app/outputs/bundle/release/app-release.aab
```

</div>
