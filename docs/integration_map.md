<div dir="rtl">

# Promoo — خريطة الربط المعتمدة (Backend ↔ Mobile Integration Map)

> **هذا الملف هو المرجع المعتمد لمرحلة الربط (Phase B).** أُنشئ بعد فحص عميق ومُتحقَّق منه لـ:
> - كامل عقد الـ API بالباك إند: `promoo-api-reference.json` + كل ملفات `src/routes/**` + كل نتائج الاختبار الحيّة في `docs/Apis-Resaults/` (21 مجلد).
> - كامل طبقة البيانات بالموبايل: كل `*_dto.dart` و `*_remote_data_source.dart` و `*_repository_impl.dart` و entities، حقلاً بحقل.
> - إعدادات الشبكة والمصادقة الفعلية بالموبايل (`api_client.dart`, `app_config.dart`, `auth_session_store.dart`).
>
> يَحلّ هذا الملف محل المسودة `promo_backend/docs/justdraft.md` ويصحّح أرقامها. (لم نعدّل أي ملف بالباك — القاعدة الذهبية.)
>
> آخر تحديث: 2026-07-09

---

## 0. الخلاصة التنفيذية (اقرأ هذا أولاً)

**الاكتشاف الأهم:** التطبيق **ليس مجرد Mock**. العَلَم `PROMOO_USE_MOCKS` قيمته الافتراضية **`false`**، وكل الـ `RemoteDataSource` **مكتوبة ومربوطة فعلاً بالـ endpoints الحقيقية**. نسخة الـ APK للعميل بُنيت بـ `--dart-define=PROMOO_USE_MOCKS=true` فقط للعرض، لكن الكود الأساسي جاهز يضرب الباك الحقيقي.

**بمعنى آخر:** الربط أبعد بكثير مما توحي به المستندات القديمة ("لسا ما اتربط"). القصة الحقيقية:
- **مكتوب ومربوط** (يضرب endpoint حقيقي): auth, home, services, seats, leaderboard, search, chat, notifications.
- **مختلط**: profile (العرض العام حقيقي؛ بروفايلي أنا + التعديل يستخدمان بيانات وهمية دائماً).
- **الفجوة الحقيقية ليست "بناء طبقة بيانات"، بل 3 أشياء فقط:**
  1. **سباكة المصادقة (Auth plumbing):** لا يوجد Dio interceptor يحقن الـ Bearer token تلقائياً، و`AuthSessionStore` **في الذاكرة فقط** (`InMemoryAuthSessionStore`) — التوكن يضيع عند إعادة التشغيل. `flutter_secure_storage` موجودة بالـ deps لكن **غير مستخدمة**. → هذا أهم عائق، لأنه يمنع كل الـ endpoints المحمية من العمل.
  2. **تدفق البروفايل الشخصي:** `updateMyProfile` عبارة عن **stub ثابت** (يرجّع فشل دائماً بدون طلب شبكة)، وبروفايلي أنا يستخدم `getDemoProfile()` الوهمي.
  3. **أزرار مدعومة بالباك لكن مش موصولة بعد** (Follow, حفظ التعديل, نشر الإعلان, رفع الأفاتار).

**الأرقام:**

| المقياس | القيمة | ملاحظة |
| --- | --- | --- |
| إجمالي endpoints بالباك | **111** | 108 موثّقة + 3 admin content غير موثّقة (مكتشفة بالكود) |
| endpoints يحتاجها الموبايل بـ v1 | **~50** | القراءة + المصادقة + follow/saved/upload/chat |
| endpoints مؤجلة لـ v2 (Stripe/Notifications/Reports/Featured) | **~27** | تفصيلها بالقسم 6 |
| endpoints خاصة بالداشبورد فقط (لا يستخدمها الموبايل) | **23** | كل `/admin/*` |
| endpoints أخرى (Auth مؤجل، Webhook، إدارة المالك) | **~11** | phone/oauth/otp، webhook، PUT/DELETE للمالك |
| نسبة التوافق الإجمالية (حقول ↔ حقول) | **~89%** | محسوبة حقلاً بحقل، القسم 4 |
| صفحات ناقصة بالموبايل | **صفر** | كل المسارات الـ 23 تفتح شاشة حقيقية (القسم 7) |

</div>

---

## 1. Total API inventory — 111 endpoints

| # | Module | Count | Mobile v1? | Notes |
|---|---|---|---|---|
| 1 | Health | 1 | ➖ | `GET /health` — infra only |
| 2 | Auth | 11 | 4 kept | login/email, register/email, refresh, logout kept; **7 deferred** (phone×2, oauth, verify-otp, forgot, reset, delete-account) |
| 3 | Profiles | 7 | 6 | me(GET/PUT), avatar, cover, :id, :id/media used; verify-request = v2 |
| 4 | Follows | 5 | 5 | all v1 |
| 5 | Offers | 7 | ~4 | list/detail/by-profile/create v1; PUT/DELETE(owner), feature(Stripe)=v2 |
| 6 | Ads | 8 | ~4 | active/impression/click/create v1; toggle/stats/PUT(owner)=later |
| 7 | Services | 5 | 5 | GET×2 read; POST/PUT/DELETE for provider/company |
| 8 | Seats | 4 | 2 | GET, GET me = v1; **book/cancel (Stripe) = v2** |
| 9 | Stories | 5 | ~2 | GET feeds v1 (via /home); POST/DELETE = v2 |
| 10 | Saved Items | 3 | 3 | all v1 |
| 11 | Home & Leaderboard | 2 | 2 | both v1 (core) |
| 12 | Subscriptions | 4 | 0 | **ALL v2** (Stripe; `POST /subscriptions` = open 500 bug) |
| 13 | Chats | 6 | 6 | all v1 (chat is a kept feature) |
| 14 | Notifications | 5 | 0* | whole feature deferred v2 (demoable skeleton kept) |
| 15 | Upload | 4 | 4 | needed for avatar/cover/ad-image (currently "next phase") |
| 16 | Search & Categories | 3 | 3 | all v1 |
| 17 | Featured | 2 | 0 | **v2** (Stripe) |
| 18 | Payments | 3 | 0 | **v2** (Stripe) |
| 19 | Reports | 2 | 0 | **v2** (no report UI in v1) |
| 20 | Admin | 23 | 0 | **dashboard-only**, mobile never calls these |
| 21 | Webhooks | 1 | 0 | Stripe→server only |
| | **Total** | **111** | **~50 v1** | |

> **3 endpoints موجودة بالكود لكن غير موثّقة بالـ reference JSON** (أُضيفت بعد توليد الـ JSON): `GET /admin/content/{offers,ads,services}`. خاصة بالداشبورد، لا تؤثر على الموبايل.

---

## 2. حقيقة المصادقة والسباكة (الأهم للربط)

<div dir="rtl">

| العنصر | الحالة الفعلية بالكود | ما يحتاجه الربط |
| --- | --- | --- |
| **Dio interceptor للتوكن** | ❌ **غير موجود** — `api_client.dart` فيه صفر interceptors. الـ chat/notifications data sources تحقن `Authorization: Bearer` **يدوياً**، لكن باقي الـ endpoints المحمية (profiles/me, follows, saved, ads, offers, book seat) **لا تحقن التوكن**. | إضافة `InterceptorsWrapper` يحقن `Authorization: Bearer <token>` من `AuthSessionStore` على كل طلب محمي + auto-refresh عند 401. |
| **تخزين التوكن** | ⚠️ `InMemoryAuthSessionStore` — **بالذاكرة فقط**، يضيع عند إعادة التشغيل. `flutter_secure_storage` موجودة بالـ pubspec لكن **غير مستخدمة**. | تنفيذ `SecureAuthSessionStore` يكتب/يقرأ الـ tokens من `flutter_secure_storage`. |
| **الـ envelope** | ✅ جاهز — `ApiResponse.parse` يفهم `{ success, data, message, meta?, error{code,details} }` **أو** كائن/قائمة مجردة. الباك يرجّع نفس الشكل بالضبط. | لا شيء — متوافق 100%. |
| **Base URL** | ✅ `http://localhost:3000/api/v1` افتراضي، يتغيّر بـ `--dart-define PROMOO_BASE_URL`. | تحديده لـ IP الشبكة/السيرفر المستضاف عند التشغيل على جهاز حقيقي. |
| **`PROMOO_USE_MOCKS`** | ✅ افتراضي `false` (يضرب الحقيقي). | إبقاؤه `false` بالإنتاج؛ استخدامه `true` فقط للعروض. |

> **القاعدة الحاكمة:** كل الـ endpoints المحمية (Bearer) لن تعمل قبل إنجاز أول بندين أعلاه. **ابدأ الربط منهما.**

</div>

---

## 3. خريطة الربط لكل قسم (Section → API)

> **الأعمدة:** الـ endpoint · الحالة بالباك (من الاختبار الحيّ) · حالة الربط بالموبايل الآن · التوافق (حقول) · العمل المطلوب.
> **حالة الربط:** 🟢 موصول بحقيقي · 🟡 موصول لكن ناقص سباكة · 🟠 stub/وهمي · ⏸️ مؤجل v2.

### 3.1 — Auth (Login / Register)
| Endpoint | Method | Backend | ربط الآن | توافق | العمل المطلوب |
|---|---|---|---|---|---|
| `/auth/login/email` | POST | ✅200 | 🟡 | 95% | يعمل؛ لكن لازم **حفظ `session.access_token`+`refresh_token`** بـ secure storage. الـ DTO يقرأ `user_metadata.account_type/full_name` + `session.*` بشكل دفاعي — مطابق. |
| `/auth/register/email` | POST | ✅(⚠️rate-limit بالتست) | 🟡 | 95% | الحقول مطابقة 100% (`email/password/full_name/account_type`). انتبه: قد يرجع `session:null` لو التحقق بالإيميل مطلوب → عالج الحالة. |
| `/auth/refresh` | POST | ✅200 | 🟠 | 90% | الدالة موجودة لكن **غير مستدعاة** — تُربط داخل الـ 401-interceptor. |
| `/auth/logout` | POST | ✅200 | 🟢 | 100% | يعمل. |
| مؤجل v2 | — | — | ⏸️ | — | phone login/register, oauth (google/apple), verify-otp, forgot/reset-password, delete-account. |

### 3.2 — Home (شاشة واحدة تجيب كل شي)
`GET /home` يرجّع: `stories[] · categories[] · featured_profiles[] · promoo_of_the_day · latest_offers[] · services[] · ads[]`. الـ `HomeContentDto` يقرأ **نفس المفاتيح بالضبط** (`promoo_of_the_day`, `ads`, `stories`, `categories`, `featured_profiles`, `latest_offers`, `services`).

| القسم بالشاشة | مصدره من `/home` | ربط | توافق | ملاحظة حقول |
|---|---|---|---|---|
| Stories | `stories[]` | 🟢 | 80% | الباك: كل ستوري = `media_url` + `profile` واحد. الفرونت يتوقع `items[]` متعددة → **كل ستوري ستظهر عنصر واحد**. تعديل DTO بسيط. |
| Services (مصغّرة) | `services[]` | 🟢 | 88% | Service فيه `profile`+`category`. لا يوجد حقل `location` بالباك للخدمة → يظهر فاضي (مقبول). |
| Top Offers / For You | `latest_offers[]` + `ads[]` | 🟢 | 85% | **تنبيه:** الباك يرجّع صور العرض بـ `media_urls[]` (مصفوفة)، لكن `HomeOfferPreviewDto` يقرأ `image_url/cover_url` (مفردة). → أضف قراءة `media_urls[0]`. |
| Categories | `categories[]` | 🟢 | 90% | `name_ar/name_en/icon_url/slug` — مطابق. |
| Promoo of the Day | `promoo_of_the_day` | 🟢 | 85% | قد يكون `null` — الفرونت مجهّز. |
| **تفاصيل عرض/إعلان** | `GET /offers/:id` أو `GET /ads/active` | 🟢 | 85% | **لا يوجد `GET /ads/:id` عام** — الفرونت يجيب `/ads/active` ويفلتر بالـ id محلياً (موجود ويعمل). |

**عمل مطلوب:** تعديلا DTO صغيران (`media_urls[0]` للصور، ستوري = عنصر واحد). لا مصادقة (كله public).

### 3.3 — Services Tab + Service Detail
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /categories` | GET | ✅200 | 🟢 | 90% | `id/name_ar/name_en/slug/icon_url` — مطابق (DTO يقرأ `icon_url`). |
| `GET /services?category_id=&q=` | GET | ✅200 | 🟢 | 88% | مع `profile`+`category` مضمّنين. الباك يدعم `category_id` و`q`. |
| `GET /services/:id` | GET | ✅200 | 🟢 | 88% | مطابق. لا يوجد `location` للخدمة (فاضي). |
| `GET /categories/:id/content` | GET | ✅200 | 🟠 غير مستخدم | — | بديل اختياري: الفرونت حالياً يفلتر `/services` بدل هذا. يرجّع Offers لا Services. |

### 3.4 — Influencer / Seats
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /seats?tier=` | GET | ✅200 | 🟢 | 90% (حقول) | **الفجوة الحرجة data:** الباك مزروع فيه **~مقعد واحد لكل tier** (اختبار `?tier=gold` رجّع 1). الفرونت يرسم شبكة 144. الحقول متطابقة (`tier/price/status/position/profile`). |
| `GET /seats/me` | GET | ✅200 | 🟡 | 90% | يحتاج Bearer. |
| `POST /seats/:id/book` | POST | ✅200 (Stripe) | ⏸️ | — | يرجّع `checkoutUrl` — **مؤجل v2** (Payments). زر Book Now يفتح preview محلي فقط. |
| `DELETE /seats/:id/cancel` | DELETE | ✅200 | ⏸️ | — | مؤجل v2. |

**عمل مطلوب:** الباك لازم **يزرع مقاعد أكثر** لكل tier (seed)، ثم `GET /seats` يملأ الشبكة تلقائياً. الحجز/الدفع يبقى v2.

### 3.5 — Cup / Leaderboard
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /leaderboard?page=&limit=&type=` | GET | ✅200 | 🟢 | **98%** | أفضل توافق بالتطبيق. الباك يرجّع `rank/id/full_name/username/avatar_url/bio/account_type/followers_count/is_verified/is_featured` — الـ DTO يقرأها **كلها**. `type=all` يستثني `user`. جاهز فعلياً. |

### 3.6 — Profile (بروفايلي + العام + التعديل)
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /profiles/:idOrUsername` | GET | ✅200 | 🟢 | 88% | البروفايل العام موصول حقيقي. |
| `GET /profiles/me` | GET | ✅200 | 🟠 | 88% | الدالة موجودة (real) لكن **الـ UI لا يستدعيها** — بروفايلي أنا يستخدم `getDemoProfile()` الوهمي. |
| `PUT /profiles/me` | PUT | ✅200 | 🟠 **stub** | 90% | **`updateMyProfile` stub ثابت — يرجّع فشل دائماً بدون طلب.** الحقول (`full_name/bio/location/website/category_id/social_links`) مطابقة `updateProfileSchema`. |
| `POST /profiles/me/avatar` · `/cover` | POST | ✅200 | 🟠 | 85% | يحتاج ربط مع Upload أولاً (يرسل `avatar_url` نصّي بعد الرفع). |
| `GET /profiles/:id/media` | GET | ✅200 | 🟠 غير مستخدم | — | البروفايل حالياً يقرأ الميديا من كائن البروفايل؛ **لا يستدعي هذا الـ endpoint** → شبكة الميديا تحتاج ربطه. |

**تنبيه حقول مهم — إحصائيات البروفايل:** كائن البروفايل بالباك يرجّع `followers_count` فقط. لا يرجّع `following_count / posts_count / views_count`. صف الإحصائيات (Followers/Posts/Views) **سيظهر Followers حقيقي والباقي صفر**. (Likes محذوف أصلاً — v2.) → قرار: إمّا الباك يضيف العدّادات، أو الفرونت يخفي ما لا يتوفر.

### 3.7 — Follow / Unfollow
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `POST /follows/:profileId` | POST | ✅200 | 🟠 | 90% | الـ repository جاهز لكن **الأزرار تعرض "coming soon"** (seats sheet + profile action). فقط لازم توصيل الزر بالـ repo + Bearer. |
| `DELETE /follows/:profileId` | DELETE | ✅200 | 🟠 | 90% | نفس الشي. |
| `GET /follows/:profileId/status` | GET | ✅200 | 🟠 | 90% | لتحديد حالة الزر (متابَع/لا). |
| `GET /follows/followers/:id` · `following/:id` | GET | ✅200 | 🟡 | 85% | قائمة "Following" بالبروفايل تستخدم `following`. الباك يرجّع `{created_at, following{id,username,full_name,avatar_url,account_type}}`. |

### 3.8 — Saved Items
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /saved` | GET | ✅200 | 🟠 شاشة ثابتة | **75%** | **فجوة:** الباك يرجّع `item_id`+`item_type` **فقط، بدون تفاصيل العنصر**. الفرونت يحتاج تفاصيل → إمّا الباك يعمل join، أو الفرونت يجيب كل عنصر بطلب إضافي. شاشة Saved حالياً static (بدون طلب). |
| `POST /saved` · `DELETE /saved/:id` | POST/DELETE | ✅ | 🟠 | 90% | يحتاج توصيل زر الحفظ. |

### 3.9 — Chat (v1 feature)
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /chats` | GET | ✅200 | 🟡 | 88% | موصول حقيقي (يحقن Bearer يدوياً). يرجّع `{room, otherParticipant, lastMessage, unreadCount}` — الـ DTO يقرأها. |
| `POST /chats` | POST | ✅201 | 🟡 | 85% | `{participant_id}` → `{room, participant, isNew}`. |
| `GET/POST /chats/:roomId/messages` | GET/POST | ✅ | 🟡 | 88% | الرسائل مع `sender` — مطابق. |
| `PATCH /chats/:roomId/read` | PATCH | ✅200 | 🟡 | 90% | — |
| **Realtime** | Supabase Realtime | — | ⬜ | — | الباك جاهز؛ الفرونت يتصل مباشرة بـ Supabase SDK (غير مضاف بعد — دليل `Realtime-Chat-Flutter-Guide.md`). |

### 3.10 — Notifications (مؤجل v2، لكن مربوط)
| Endpoint | Method | Backend | ربط | ملاحظة |
|---|---|---|---|---|
| `GET /notifications` · read · read-all · delete · token | GET/PATCH/DELETE/POST | ✅ | 🟡 مربوط | الميزة كاملة **مؤجلة v2** (بما فيها FCM)، لكن الـ data source مكتوب. جرس الهيدر يفتح skeleton. لا تستثمر بالربط الآن. |

### 3.11 — إنشاء المحتوى (Add Ad / Add Offer)
| Endpoint | Method | Backend | Role | ربط | ملاحظة |
|---|---|---|---|---|---|
| `POST /ads` | POST | ✅201 | **company, influencer** | 🟠 | wizard 4 خطوات، الحقول تطابق `createAdSchema` (`phone/whatsapp/contact_email/instagram_link/city/area/full_address/location_map_url/media_url/price/currency/tags` + المطلوبة `ad_type/budget/target_url` تحتاج defaults). زر Create AD حالياً "next phase". |
| `POST /offers` | POST | ✅201 | **company, service_provider** | ⬜ لا شاشة منفصلة | راجع **تعارض المنطق** بالقسم 5. |
| `POST /services` | POST | ✅201 | **service_provider, company** | ⬜ لا شاشة | لا توجد شاشة "Add Service" بالـ MVP — قرار v2. |

### 3.12 — Upload (شرط لِـ avatar/cover/ad-image)
| Endpoint | Method | Backend | ربط | ملاحظة |
|---|---|---|---|---|
| `POST /upload/image` · video · file | POST | ✅201 (multipart) | 🟠 | يرجّع `file_url` → يُخزَّن ويُرسل للـ avatar/cover/ad. حقول الرفع بالفرونت حالياً "next phase". |
| `DELETE /upload/:id` | DELETE | ✅200 | ⬜ | — |

### 3.13 — Search
| Endpoint | Method | Backend | ربط | توافق | ملاحظة |
|---|---|---|---|---|---|
| `GET /search?q=&type=&…` | GET | ✅200 | 🟢 | 92% | يرجّع `{profiles[],offers[],ads[],services[]}` — الـ DTO يقرأها مجمّعة. `type` values و pagination (`meta`) مدعومة. |

---

## 4. نسبة التوافق حقلاً بحقل (Compatibility)

<div dir="rtl">

الطريقة: لكل قسم = (حقول الباك المطلوبة والمتوفرة بالـ DTO ÷ إجمالي الحقول المطلوبة) مع خصم للأفعال غير المدعومة. التوافق **عالٍ** لأن التطبيق بُني **backend-first** والـ DTOs **دفاعية جداً** (كل حقل يقبل عدة تهجئات snake_case + camelCase + aliases).

</div>

| القسم | Endpoints | توافق | أهم فجوة |
| --- | --- | --- | --- |
| Login / Register | 2 | **95%** | حفظ التوكن + interceptor |
| Home (كامل) | 3 | **85%** | صور `media_urls[0]`، ستوري = عنصر واحد |
| Search | 1 | **92%** | — |
| Services + Detail | 3 | **88%** | لا `location` للخدمة |
| Leaderboard | 1 | **98%** | — (جاهز) |
| Seats | 2 | **90% حقول / بيانات ناقصة** | **seed 3 مقاعد فقط** |
| Profile (عام) | 2 | **88%** | — |
| Profile (أنا + تعديل) | 3 | **60%** | `updateMyProfile` stub، بروفايلي وهمي، إحصائيات ناقصة |
| Follow/Unfollow | 5 | **88%** | الأزرار مش موصولة |
| Saved | 3 | **75%** | الباك يرجّع id فقط بدون تفاصيل |
| Chat | 6 | **88%** | Realtime غير مضاف |
| Upload | 4 | **80%** | حقول الرفع "next phase" |
| Add Ad | 1 | **85%** | defaults لـ ad_type/budget |
| **الإجمالي المرجّح** | **~50** | **≈89%** | |

---

## 5. ⚠️ تعارض منطقي مهم — Add Offer vs Add Ad (يحتاج قرارك)

<div dir="rtl">

بحسب `roles_logic.md`:
- **العروض (Offers):** يضيفها `company` + `service_provider` (عبر `POST /offers`).
- **الإعلانات (Ads):** يضيفها `company` + `influencer` (عبر `POST /ads`).

لكن بالتطبيق الحالي (قرار `build_plan` A15): **صف واحد اسمه "Add New Offer" يفتح wizard الإعلان** (`POST /ads`). فينتج **ثلاثة تناقضات**:
1. **الاسم** يقول "Offer" لكن **الفعل** ينشئ "Ad".
2. **الصلاحية:** لو المستخدم `service_provider` (مسموح له بالعروض، ممنوع من الإعلانات) وضغط "Add New Offer" الذي ينشئ إعلاناً → الباك يرفض بـ **403**.
3. **لا توجد شاشة "Add Service"** رغم أن `service_provider`/`company` يحق لهم إنشاء خدمات.

**التوصية للربط:** فصل تدفّق الإنشاء حسب `account_type`:
- `company` → يرى: Add Offer, Add Ad, (اختياري Add Service).
- `service_provider` → يرى: Add Offer, Add Service (لا Ads).
- `influencer` → يرى: Add Ad فقط.
- `user` → لا يرى أي إنشاء.

وإصلاح الاسم/الفعل ليتطابقا. (يمكن تأجيل شاشتَي Offer/Service المنفصلتين لـ v2 لكن يجب **على الأقل إخفاء/تعطيل** الزر حسب الدور لتفادي الـ 403.)

</div>

---

## 6. الأقسام المؤجلة لـ v2 (لا تُربط الآن)

| القسم | Endpoints | السبب |
| --- | --- | --- |
| 💳 Subscriptions | `GET/POST /subscriptions*` (4) | Stripe؛ **`POST /subscriptions` = خطأ 500 مفتوح** (`client_secret`، إصدار Stripe API). |
| 💰 Payments | `/payments/*` (3) | Stripe. |
| ⭐ Featured | `/featured*` (2) | Stripe. |
| 🔔 Notifications | `/notifications*` (5) | الميزة كاملة مؤجلة (+FCM). |
| 🚩 Reports | `/reports*` (2) | لا واجهة تبليغ بـ v1. |
| 🪑 Seat booking/cancel | `POST /seats/:id/book`, `DELETE …/cancel` (2) | Stripe checkout. |
| 📸 Stories create/delete | `POST /stories`, `DELETE /stories/:id` (2) | إنشاء القصص display-only. |
| 🔐 Auth الموسّع | phone×2, oauth, verify-otp, forgot, reset, delete (7) | email-only بـ v1. |
| 🛡️ Admin | `/admin/*` (23) | للداشبورد فقط — الموبايل لا يستعملها. |
| 🔗 Webhook | `/webhooks/stripe` (1) | Stripe→server. |
| 📦 Content Packages | — | **لا يوجد كيان بالباك** (خطط 99/149/249 محذوفة migration 032). شاشة Packages display-only. قرار الكيان مؤجل. |

---

## 7. الصفحات الناقصة — التحقّق النهائي

<div dir="rtl">

**النتيجة: لا توجد صفحات ناقصة.** كل الـ 23 مساراً المُعرَّفة في `route_names.dart` تفتح شاشة حقيقية موجودة في `app_router.dart`. لا يوجد أي زر يشير لصفحة غير موجودة. كل تدفقات الـ MVP (splash → login/register → home/services/influencer/cup/profile + التفاصيل + الشات + الإشعارات + البروفايل العام + البحث + الإعدادات الفرعية) لها وجهة.

**الأزرار المسدودة (dead-ends)** كلها مقصودة، وتنقسم إلى:
- **مؤجل v2 (لا عمل الآن):** social login, password reset, packages checkout, seat booking/payment, location map, See-All على الهوم.
- **مدعوم بالباك لكن يحتاج توصيل بالربط:** حفظ تعديل البروفايل، نشر الإعلان، رفع الأفاتار/الصور، زر Follow.
- **بلا endpoint بالباك:** رسائل الدعم (Support) — لا يوجد endpoint للدعم؛ التعريب (Arabic).

**شاشات قد تحتاجها لاحقاً (قرارات، ليست "ناقصة" بالـ MVP):** شاشة Add Offer منفصلة، شاشة Add Service، شاشة "See All" للقوائم الكاملة. كلها خارج نطاق الـ MVP الحالي.

</div>

---

## 8. ترتيب الربط الموصى به (Priority Order)

| # | الخطوة | Endpoints | لماذا |
| --- | --- | --- | --- |
| 1️⃣ | **سباكة المصادقة** — Dio Bearer interceptor + `flutter_secure_storage` + auto-refresh على 401 | (بنية تحتية) | **يفتح كل الـ endpoints المحمية.** بدونه لا شيء محمي يعمل. |
| 2️⃣ | **Auth wiring** — ربط login/register بالتخزين الآمن | 4 | أساس الجلسة. |
| 3️⃣ | **Profile الشخصي** — استبدال `getDemoProfile` بـ `GET /profiles/me`، وتنفيذ `PUT /profiles/me` (إزالة الـ stub) | 2 | أكبر فجوة "موصولة". |
| 4️⃣ | **Home** — تعديلا DTO (`media_urls[0]`، ستوري واحدة) | 1 | الشاشة الأهم (public، بلا مصادقة). |
| 5️⃣ | **Categories + Services + Search + Leaderboard** — تأكيد فقط (شبه جاهزة) | 5 | سريعة. |
| 6️⃣ | **Seats** — بانتظار **seed** بالباك، ثم `GET /seats` | 2 | يحتاج عمل بالباك. |
| 7️⃣ | **Follow/Unfollow** — توصيل الأزرار + status | 5 | يحدّث `followers_count` → Cup. |
| 8️⃣ | **Upload** — ربط `/upload/image` ثم avatar/cover/ad-image | 4 | شرط للتعديل والإنشاء. |
| 9️⃣ | **Add Ad publish** — `POST /ads` + role-gating | 1 | يعتمد على Upload + Auth. |
| 🔟 | **Saved** — حل الـ join، ثم ربط الشاشة | 3 | يحتاج قرار الباك (join). |
| 1️⃣1️⃣ | **Chat** — تأكيد + إضافة Supabase Realtime | 6 | الأكثر تعقيداً. |
| 1️⃣2️⃣ | **Role-gating** — إظهار/إخفاء أزرار الإنشاء حسب `account_type` + إصلاح تعارض Offer/Ad | — | يمنع أخطاء 403. |

---

## 9. ما ينقص/يحتاج انتباه بالباك (Backend gaps)

| # | الفجوة | الخطورة | الحل |
| --- | --- | --- | --- |
| 1 | **Seats seed** — مقعد واحد لكل tier فقط، الفرونت يريد شبكة كاملة | 🔴 حرجة (للـ Influencer) | توسيع `seed.sql` ليحقن عدداً كافياً لكل tier. |
| 2 | **`POST /subscriptions` = 500** (`client_secret`) | 🟠 (v2) | إصلاح flow الـ PaymentSheet (تثبيت `apiVersion` أو `confirmation_secret`). لا يؤثر v1. |
| 3 | **`GET /saved` بدون تفاصيل** — يرجّع `item_id`+`item_type` فقط | 🟡 | إضافة join يرجّع تفاصيل العنصر (مفضّل)، أو N+1 بالفرونت. |
| 4 | **إحصائيات البروفايل** — لا `following/posts/views count` | 🟡 | إمّا الباك يضيف العدّادات، أو الفرونت يخفي ما لا يتوفر (Followers فقط متاح). |
| 5 | **لا endpoint للدعم (Support)** | 🟢 | رسائل الدعم بلا باك — إمّا mailto/رابط، أو استخدام Reports، أو تأجيل. |
| 6 | **لا كيان Content Packages** (99/149/249) | 🟢 (v2) | قرار: جدول `packages` جديد، أو ربط بـ subscriptions، أو إسقاط. Packages تبقى display-only. |
| 7 | **لا `location` بكائن Service** ولا `GET /ads/:id` عام | 🟢 | تجميلي — الفرونت يتعامل مع الغياب (يفلتر `/ads/active`). |

---

## 10. مراجع

- عقد الـ API الكامل: `promo_backend/docs/promoo-api-reference.json` + `promoo_full_api.postman_collection.json`
- نتائج الاختبار الحيّة: `promo_backend/docs/Apis-Resaults/` (21 مجلد)
- منطق الصلاحيات: `promo_mobile/docs/roles_logic.md`
- المؤجل v2: `promo_mobile/docs/v2_deferred_scope.md`
- قرارات الربط (15 صف): `promo_mobile/docs/build_plan.md` §Phase B
- دليل الشات الفوري: `promo_backend/docs/Realtime-Chat-Flutter-Guide.md`

</div>
