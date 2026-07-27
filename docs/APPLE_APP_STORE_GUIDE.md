<div dir="rtl">

# دليل رفع Promoo على Apple App Store

هاد دليل خطوة بخطوة مخصص لمشروع Promoo تحديداً — مبني على فحص حقيقي لإعدادات مشروع iOS الحالية بتاريخ 2026-07-25.

---

## ⏸️ مؤجّل مؤقتاً (بقرار المالك، 2026-07-26)

ركّزنا على Google Play أول (`GOOGLE_PLAY_STORE_GUIDE.md`) بما إنو ما في Mac متاح حالياً. **بس شغلنا شوي هون قبل التأجيل** — خليك تعرف وين وصلنا بالضبط:

| الموضوع | الحالة |
|---|---|
| **Bundle Identifier** | ✅ **خلص فعلياً** — تغيّر من `com.example.promooApp` لـ `com.promoo.app` بملف `ios/Runner.xcodeproj/project.pbxproj` مباشرة (كل الـ 6 مواضع: Runner + RunnerTests، كل الـ build configs). ما احتجنا Xcode لهالتعديل بالذات لأنو تبديل نص بسيط. |
| **Firebase iOS** | 🔄 **قيد التنفيذ** — نفس مشروع Firebase (`promoo-9d3f1`) يلي فيه تطبيق أندرويد، بتضيفله تطبيق iOS بـBundle ID `com.promoo.app` وتنزّل `GoogleService-Info.plist`. لسا ما انربط فعلياً بمشروع Xcode (هاد الجزء **لازم Xcode**، مش بس نسخ ملف). |
| **حساب Apple Developer Program** | ⬜ لسا ما اتعمل. |
| **قرار حل الـ"بدون Mac"** | تقرر: **Codemagic** (بدل استئجار Mac) — شوف قسم 0 تحت، صار موصى فيه كـ**الحل الأساسي** مو مجرد بديل. |

**لما ترجع لهالملف:** ابلش من قسم 2 (Apple Developer Program) — قسم 3 (Bundle Identifier) خلص، وتخطى الأجزاء يلي بتقول "من الـ Mac بالـ terminal" لأنك رح تستخدم Codemagic بدالها.

---

## 0) أول شي: لازم Mac — أو Codemagic بدالو (الحل الموصى فيه لحالتك)

**Apple ما بتسمح ببناء أو رفع تطبيقات iOS إلا من خلال Xcode**، و Xcode بيشتغل بس على macOS. هاد مو اختياري ومافي حل تقني يلفّ عليه.

بما إنو **ما في Mac متاح حالياً** (تأكّد هاد بمحادثة 2026-07-26)، الحل المناسب إلك:

**Codemagic** ([codemagic.io](https://codemagic.io)) — خدمة CI/CD مبنية خصيصاً لـFlutter، بتعمل كل شي (`pod install`، البناء، التوقيع، **والرفع لـApp Store Connect**) على أجهزة Mac تبعها بالسحابة — إنت ما بتلمس Mac إطلاقاً. عندها واجهة ويب بسيطة (فورمات، مو Terminal)، وخطة مجانية محدودة كافية لمشروع فردي. بتحتاج تربطها بحساب Apple Developer تبعك (قسم 2 تحت) عشان توقّع وترفع نيابة عنك.

بدائل تانية (أقل ملاءمة لحالتك، مذكورة للعلم فقط):
- استئجار Mac بالسحابة لساعات (MacStadium، MacinCloud) — بيحتاج تتعامل مع Terminal/Xcode بنفسك، أصعب من Codemagic.
- صديق/زميل عندو Mac يساعدك بخطوات البناء والرفع بس.

**كل الخطوات الجاية يلي بتقول "من الـ Mac بالـ terminal" — استبدلها بـCodemagic (رح نشرح كيف نربطها لما نوصل لهالخطوة). باقي الخطوات (حساب المطور، Firebase، App Store Connect) بتشتغل من أي متصفح عادي.**

---

## 1) شو ناقص فعلياً بمشروع iOS الحالي (فحصته مباشرة)

| الموضوع | الوضع الحالي | ليش مشكلة |
|---|---|---|
| ~~**Bundle Identifier**~~ | ✅ **خلص** — `com.promoo.app` | — |
| **GoogleService-Info.plist** (Firebase لـ iOS) | 🔄 قيد التسجيل بـFirebase Console (نفس مشروع `promoo-9d3f1`) | لسا ما انربط بمشروع Xcode فعلياً — هاي الخطوة (السحب جوا Xcode) لازم تصير عبر Codemagic أو Mac، مش نسخ-لصق عادي. |
| **أيقونة التطبيق** | ✅ موجودة بكل المقاسات المطلوبة (`Assets.xcassets/AppIcon.appiconset`) | تمام. |
| **أوصاف الصلاحيات (Usage Descriptions)** | ✅ موجودة لـ Camera و Photo Library بـ `Info.plist` | تمام — Apple بترفض التطبيق فوراً لو استخدم صلاحية بدون وصف نصي، وعندك هيك موجودين. |
| **اسم التطبيق المعروض** | `CFBundleDisplayName` = "Promoo App" | راجعو، ممكن تفضل "Promoo" بس بدون "App" — قرار تسويقي بسيط. |
| **حساب مطوّر Apple** | غير مذكور — لازم تتأكد إنو عندك | 99 دولار سنوياً، لازم قبل أي خطوة تانية. |

---

## 2) اشترك بـ Apple Developer Program

1. روح لـ [developer.apple.com/programs](https://developer.apple.com/programs/enroll/).
2. سجل بـ Apple ID (يفضل حساب مخصص للشركة مو شخصي).
3. اختار "Individual" (لو رح تسجل باسمك الشخصي) أو "Organization" (لو عندك D-U-N-S Number لشركة مسجلة — بياخد وقت أطول للموافقة).
4. ادفع **99 دولار سنوياً**.
5. الموافقة عادة بتاخد من ساعات لحتى 48 ساعة (أطول لو "Organization").

---

## 3) صلّح الـ Bundle Identifier — ✅ خلص (2026-07-26)

القيمة تغيّرت فعلياً بكل الـ 6 مواضع بملف `ios/Runner.xcodeproj/project.pbxproj` (Runner + RunnerTests، Debug/Release/Profile) من `com.example.promooApp` لـ **`com.promoo.app`** — نفس الاسم المستخدم بأندرويد.

**الباقي من هالخطوة (لما توصل لـXcode أو Codemagic):**
1. اختار **Team** (حساب المطوّر يلي سجلت فيه بالخطوة 2) — هاد ما فينا نعملو من غير Xcode/Codemagic لأنو مرتبط بحسابك الشخصي بـApple.
2. فعّل "Automatically manage signing" (أسهل بكتير من التوقيع اليدوي لأول مرة).

---

## 4) سجّل الـ App ID بحساب Apple Developer

عادة Xcode بيسويها تلقائياً لما تفعّل "Automatically manage signing" وتختار Team — بس لو حبيت تتأكد يدوياً:
1. روح [developer.apple.com/account](https://developer.apple.com/account) → **Certificates, Identifiers & Profiles** → **Identifiers**.
2. تأكد إنو في App ID بنفس الـ Bundle Identifier يلي حطيتو (`com.promoo.app`).

---

## 5) جهّز Firebase لـ iOS (عشان الإشعارات تشتغل) — 🔄 قيد التنفيذ

بما إنو Android مسجّل بـ Firebase أصلاً (نفس المشروع `promoo-9d3f1`)، ضيف تطبيق iOS لنفس مشروع Firebase:

1. روح [console.firebase.google.com](https://console.firebase.google.com) → مشروع Promoo (`promoo-9d3f1`).
2. **"Add app"** → اختار أيقونة iOS.
3. حط الـ Bundle ID **نفسو بالضبط**: `com.promoo.app`.
4. نزّل ملف **`GoogleService-Info.plist`** وخزّنو (مو لازم تحطو بالمشروع هلق).
5. **الخطوة الأخيرة (الربط الفعلي جوا Xcode) مؤجّلة** — لازم تصير من Xcode أو Codemagic، مش بس نسخ-لصق: الملف لازم ينضاف كـ"Resource" مسجّل بملف مشروع Xcode (`project.pbxproj`)، وهاد شي **ما بعملو يدوياً بتعديل نصي** (خطر يخرب بنية ملف المشروع) — لازم يصير عبر واجهة Xcode (أو خطوة مكافئة بـCodemagic) لما توصل لهيك.

بدون هالخطوة الأخيرة، الإشعارات ما رح توصل لمستخدمي iOS إطلاقاً — التطبيق بيشتغل عادي بس بدون push notifications.

---

## 6) رقم النسخة (نفس المنطق متل أندرويد)

بملف `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
هون `1.0.0` = `CFBundleShortVersionString` (الرقم يلي المستخدم بيشوفه)، و`1` = `CFBundleVersion` (لازم يزيد بكل رفعة، حتى لو نفس الـ `1.0.0`).

---

## 7) ابنِ نسخة الإنتاج

**إذا عم تستخدم Codemagic** (الحل الموصى فيه لحالتك، قسم 0): هالخطوة بتصير من واجهة Codemaget نفسها (بتحدد إعدادات البناء مرة وحدة، وبعدها بتضغط زر "Start new build" — ما فيك تحتاج تكتب أوامر Terminal). التفاصيل بتضاف هون لما توصلها فعلياً.

**إذا عندك Mac فعلياً**، من الـ Terminal:

```bash
cd /path/to/promo_mobile
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release
```

الناتج بيطلع بـ:
```
build/ios/ipa/promoo_app.ipa
```

لو صار خطأ signing أثناء البناء، ارجع تأكد من خطوة 3 (Team + Bundle ID) بـ Xcode.

---

## 8) أنشئ التطبيق بـ App Store Connect

1. روح [appstoreconnect.apple.com](https://appstoreconnect.apple.com).
2. **"My Apps" → "+" → "New App"**.
3. اختار المنصة (iOS)، اسم التطبيق، اللغة الأساسية، الـ Bundle ID (بيطلعلك بقائمة منسدلة من الحسابات المسجّلة — اختار `com.promoo.app`)، و SKU (رقم/اسم داخلي أنت تختارو، مو ظاهر للمستخدمين).

---

## 9) ارفع الـ Build

طريقتين:

**أ) من Xcode مباشرة (أسهل):**
1. بـ Xcode، اختار **Product → Archive** (بدل `flutter build ipa`، هاد بيبني وبيفتحلك نافذة Organizer).
2. بعد ما يخلص الأرشفة، دوس **"Distribute App" → "App Store Connect" → "Upload"**.
3. اتبع الخطوات (بتستخدم نفس الـ signing يلي جهزته بخطوة 3).

**ب) عبر Transporter (لو بنيت الـ IPA من الـ terminal بـ `flutter build ipa`):**
1. حمّل تطبيق **Transporter** من الـ Mac App Store.
2. افتحو، سجل دخول بنفس Apple ID، اسحب ملف `promoo_app.ipa` جواه.
3. دوس "Deliver".

بعد الرفع، الـ build بياخد من دقايق لربع ساعة لحتى يظهر بـ App Store Connect (بتتم معالجته/فحصه آلياً أولاً).

---

## 10) اختبار عبر TestFlight (قبل النشر الحقيقي — بشدة موصى فيه)

1. من App Store Connect → التطبيق → تبويب **"TestFlight"**.
2. اختار الـ build يلي رفعته.
3. ضيف "Internal Testers" (لازم يكونوا أعضاء بفريقك على App Store Connect، لغاية 100 شخص، بدون مراجعة Apple — بيوصلهم رابط فوراً).
4. لو بدك مختبرين خارج فريقك (External Testing)، هاد بيحتاج مراجعة خفيفة من Apple (عادة أسرع بكتير من مراجعة النشر الكامل).

---

## 11) عبّي معلومات المتجر (App Store Listing)

من App Store Connect → التطبيق → **"App Store"** tab:

- **اسم التطبيق**: "Promoo" (فريد عالمياً على المتجر — تأكد محدا اخدو).
- **الفئة (Category)**: Business / Social Networking / Lifestyle.
- **وصف التطبيق**: نفس المحتوى يلي حضرته لـ Google Play تقريباً.
- **الكلمات المفتاحية (Keywords)**: كلمات بحث مفصولة بفاصلة.
- **لقطات الشاشة (Screenshots)**: **إلزامية لكل حجم شاشة iPhone تدعمه** (6.7" على الأقل إلزامي حالياً، الباقي اختياري بس محبب). خدها من محاكي iPhone بـ Xcode أو جهاز حقيقي.
- **رابط سياسة الخصوصية**: إلزامي، رابط ويب فعلي (نفس الصفحة يلي بتجهزها لـ Google Play تقدر تستخدمها هون).
- **App Privacy (nutrition label)**: استبيان مشابه لـ Data Safety بگوگل — شو بيانات بتجمعها (إيميل، صور، اسم، دردشة) وهل مرتبطة بهوية المستخدم. جاوب بأمانة حسب الباك اند.
- **Age Rating**: استبيان قصير (وجود دردشة بين مستخدمين بيأثر على التصنيف).
- **معلومات تواصل الدعم**: إيميل + رابط دعم (اختياري بس محبب).
- **App Review Information**: لو التطبيق بيحتاج تسجيل دخول، **لازم تعطي حساب تجريبي (username/password) للمراجع** — وإلا المراجعة بترفض أو بتتأخر لأنو المراجع ما بيقدر يفوت عالتطبيق.

---

## 12) قدّم للمراجعة

1. بعد ما تعبّي كل شي، اختار الـ build يلي رفعته من TestFlight/الأرشيف.
2. دوس **"Submit for Review"**.
3. مراجعة Apple عادة بتاخد **من يوم لـ 48 ساعة** لأول رفعة (ممكن تطول لو فيه ملاحظات — رح يوصلك إيميل لو رفضوه مع السبب بالتفصيل، وبتقدر تصلح وترفع تاني بدون رسوم إضافية).
4. بعد الموافقة، تقدر تختار نشر فوري أو تحدد تاريخ/تنشرها يدوياً بنفسك.

---

## 13) لأي تحديث مستقبلي (checklist سريع)

1. زيد رقم الـ `version` بـ `pubspec.yaml`.
2. `flutter build ipa --release` (أو Archive من Xcode).
3. ارفعه (Xcode Organizer أو Transporter) — بيصير "build" جديد لنفس التطبيق.
4. اربطه بنسخة جديدة على App Store Connect، اكتب "What's New"، قدّم للمراجعة.

</div>
