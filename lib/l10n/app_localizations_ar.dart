// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionOk => 'حسناً';

  @override
  String get commonLoading => 'جارِ التحميل';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonDismiss => 'إغلاق';

  @override
  String commonComingSoon(String feature) {
    return '$feature قريباً';
  }

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonSomethingWentWrong => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get commonPrice => 'السعر';

  @override
  String get commonContactForPricing => 'تواصل لمعرفة السعر';

  @override
  String get commonDescription => 'الوصف';

  @override
  String get commonProvider => 'المزوّد';

  @override
  String get commonDetails => 'التفاصيل';

  @override
  String get commonOpenChats => 'فتح المحادثات';

  @override
  String get commonViewProviderProfile => 'عرض ملف المزوّد';

  @override
  String get commonContactFlowComingSoon =>
      'ميزة التواصل قريباً. يمكنك فتح المحادثات أو عرض ملف المزوّد.';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabInfluencer => 'المؤثرون';

  @override
  String get tabOffers => 'العروض';

  @override
  String get tabPromoo => 'بروموو';

  @override
  String get tabServices => 'الخدمات';

  @override
  String get tabProfile => 'حسابي';

  @override
  String tabSemanticLabel(String label) {
    return 'تبويب $label';
  }

  @override
  String get snackbarPressBackAgainToExit => 'اضغط رجوع مرة أخرى للخروج';

  @override
  String get headerSwitchToLightMode => 'التبديل للوضع الفاتح';

  @override
  String get headerSwitchToDarkMode => 'التبديل للوضع الداكن';

  @override
  String get headerChats => 'المحادثات';

  @override
  String get headerNotifications => 'التنبيهات';

  @override
  String settingsGreeting(String name) {
    return 'مرحباً $name';
  }

  @override
  String get settingsWelcomeSubtitle => 'أهلاً بك في بروموو';

  @override
  String get settingsGuest => 'ضيف';

  @override
  String get menuFollowing => 'المتابَعون';

  @override
  String get menuProfileManagement => 'إدارة الحساب';

  @override
  String get menuAddOffer => 'إضافة عرض جديد';

  @override
  String get menuAddAd => 'إضافة إعلان جديد';

  @override
  String get menuAddService => 'إضافة خدمة جديدة';

  @override
  String get menuSaved => 'المحفوظات';

  @override
  String get menuPackages => 'باقاتي';

  @override
  String get menuSupport => 'الدعم';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsEnglish => 'الإنجليزية';

  @override
  String get settingsArabic => 'العربية';

  @override
  String get settingsThemeMode => 'المظهر';

  @override
  String get settingsBlackMode => 'الوضع الأسود';

  @override
  String get settingsLightMode => 'الوضع الفاتح';

  @override
  String get settingsLogout => 'تسجيل الخروج';

  @override
  String get logoutDialogTitle => 'تسجيل الخروج';

  @override
  String get logoutDialogBody => 'هل أنت متأكد من تسجيل الخروج من بروموو؟';

  @override
  String get footerAbout => 'من نحن';

  @override
  String get footerTerms => 'الشروط والأحكام';

  @override
  String get footerPrivacy => 'سياسة الخصوصية';

  @override
  String get authFieldEmail => 'البريد الإلكتروني';

  @override
  String get authFieldPassword => 'كلمة المرور';

  @override
  String get authFieldFullName => 'الاسم الكامل';

  @override
  String get authFieldAccountType => 'نوع الحساب';

  @override
  String get authPasswordShow => 'إظهار كلمة المرور';

  @override
  String get authPasswordHide => 'إخفاء كلمة المرور';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authLoggingIn => 'جارِ تسجيل الدخول...';

  @override
  String get authSignUp => 'إنشاء حساب';

  @override
  String get authCreateAccount => 'إنشاء الحساب';

  @override
  String get authCreatingAccount => 'جارِ إنشاء الحساب...';

  @override
  String get authAlreadyHaveAccount => 'لدي حساب بالفعل';

  @override
  String get authContinueAsGuest => 'المتابعة كضيف';

  @override
  String get authSignedInTitle => 'تم تسجيل الدخول';

  @override
  String get authContinue => 'متابعة';

  @override
  String get authSignOut => 'تسجيل الخروج';

  @override
  String get authSigningOut => 'جارِ تسجيل الخروج...';

  @override
  String get authSocialLoginCaption => 'تسجيل الدخول بحساب';

  @override
  String get authSocialSignupCaption => 'إنشاء حساب باستخدام';

  @override
  String get authAccountTypeUser => 'مستخدم';

  @override
  String get authAccountTypeCompany => 'شركة';

  @override
  String get authAccountTypeInfluencer => 'مؤثر';

  @override
  String get authAccountTypeServiceProvider => 'مزوّد خدمة';

  @override
  String get authValidationEmailRequired => 'البريد الإلكتروني مطلوب.';

  @override
  String get authValidationEmailInvalid => 'الرجاء إدخال بريد إلكتروني صحيح.';

  @override
  String get authValidationPasswordRequired => 'كلمة المرور مطلوبة.';

  @override
  String get authValidationFullNameTooShort =>
      'يجب أن يتكوّن الاسم الكامل من حرفين على الأقل.';

  @override
  String get authValidationPasswordTooShort =>
      'يجب أن تتكوّن كلمة المرور من 8 أحرف على الأقل.';

  @override
  String get authRegistrationPendingVerification =>
      'تم إنشاء الحساب. الرجاء تفعيل حسابك قبل تسجيل الدخول.';

  @override
  String get homeLoadingMessage => 'جارِ تحميل الرئيسية';

  @override
  String get homeEmptyTitle => 'لا يوجد شيء للعرض بعد';

  @override
  String get homeEmptyMessage => 'سيظهر محتوى بروموو هنا عند توفره.';

  @override
  String get homeErrorTitle => 'تعذّر تحميل الرئيسية';

  @override
  String get homeRefreshErrorFallback => 'تعذّر تحديث محتوى الرئيسية.';

  @override
  String get homeSectionStoriesTitle => 'القصص';

  @override
  String get homeSectionStoriesSubtitle => 'آخر تحديثات شركاء بروموو';

  @override
  String get homeSectionTopOffersTitle => 'أفضل العروض';

  @override
  String get homeSectionTopOffersSubtitle => 'عروض مميزة من شركاء بروموو';

  @override
  String get homeSectionForYouTitle => 'لك أنت';

  @override
  String get homeSectionForYouSubtitle => 'عروض مختارة لهذا اليوم';

  @override
  String get homeSectionServicesSubtitle => 'خدمات حملات مميزة جاهزة للتواصل';

  @override
  String get homeSectionPromooOfDayTitle => 'بروموو اليوم';

  @override
  String get homeSectionPromooOfDaySubtitle => 'اختيار بروموو المميز لليوم';

  @override
  String get homeTopOfferBadge => 'أفضل عرض';

  @override
  String get homeServiceBadge => 'خدمة';

  @override
  String get homeServiceFallbackSubtitle => 'خدمة مزوّد';

  @override
  String get homeSeeAllTitleBrowse => 'تصفّح';

  @override
  String get homeSeeAllErrorTitle => 'تعذّر التحميل';

  @override
  String get homeSeeAllEmptyTitle => 'لا يوجد شيء هنا بعد';

  @override
  String get homeSeeAllEmptyMessage => 'ستظهر عناصر هذا القسم هنا قريباً.';

  @override
  String get homeStoryViewerCloseTooltip => 'إغلاق القصة';

  @override
  String get homeDetailLoadingMessage => 'جارِ تحميل التفاصيل';

  @override
  String get homeDetailErrorTitle => 'تعذّر تحميل التفاصيل';

  @override
  String get homeDetailTypeOffer => 'عرض';

  @override
  String get homeDetailTypeAd => 'إعلان ترويجي';

  @override
  String get homeDetailTypeUnknown => 'عنصر بروموو';

  @override
  String homeDetailLocationComingSoon(String location) {
    return 'تفاصيل الموقع قريباً. الموقع الحالي هو $location.';
  }

  @override
  String get homeDetailAvailabilityLabel => 'التوفر';

  @override
  String get homeDetailAvailabilityFallback => 'أكّد مع المزوّد';

  @override
  String get homeDetailNextStepTitle => 'الخطوة التالية';

  @override
  String get homeDetailNextStepSubtitle =>
      'تواصل مع المزوّد قبل اتخاذ أي إجراء';

  @override
  String get homeDetailContact => 'تواصل';

  @override
  String get homeDetailLocation => 'الموقع';

  @override
  String get servicesLoadingMessage => 'جارِ تحميل الخدمات';

  @override
  String get servicesRefreshErrorFallback => 'تعذّر تحديث الخدمات.';

  @override
  String get servicesErrorTitle => 'تعذّر تحميل الخدمات';

  @override
  String get servicesSearchResultsTitle => 'نتائج البحث';

  @override
  String servicesResultsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خدمة',
      many: '$count خدمة',
      few: '$count خدمات',
      two: 'خدمتان',
      one: 'خدمة واحدة',
      zero: 'لا توجد خدمات',
    );
    return '$_temp0';
  }

  @override
  String get servicesBackToCategoriesTooltip => 'الرجوع للتصنيفات';

  @override
  String get servicesAllCategory => 'كل الخدمات';

  @override
  String servicesCategorySemanticLabel(String label) {
    return 'تصنيف $label';
  }

  @override
  String get servicesSearchHint => 'ابحث عن خدمات';

  @override
  String get servicesClearSearchTooltip => 'مسح البحث';

  @override
  String get servicesEmptyFilteredTitle => 'لا توجد خدمة مطابقة.';

  @override
  String get servicesEmptyFilteredMessage =>
      'لم نتمكن من إيجاد هذه الخدمة بعد.';

  @override
  String get servicesEmptyDefaultTitle => 'لا توجد خدمات بعد';

  @override
  String get servicesEmptyDefaultMessage =>
      'ابحث أو اختر تصنيفاً لاكتشاف الخدمات.';

  @override
  String servicesDeliveryDaysLabel(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'تسليم خلال $days يوم',
      many: 'تسليم خلال $days يوماً',
      few: 'تسليم خلال $days أيام',
      two: 'تسليم خلال يومين',
      one: 'تسليم خلال يوم واحد',
      zero: 'تسليم فوري',
    );
    return '$_temp0';
  }

  @override
  String get serviceDetailLoadingMessage => 'جارِ تحميل تفاصيل الخدمة';

  @override
  String get serviceDetailErrorTitle => 'تعذّر تحميل الخدمة';

  @override
  String get serviceDetailScreenTitle => 'تفاصيل الخدمة';

  @override
  String get serviceDetailTimelineLabel => 'المدة الزمنية';

  @override
  String get serviceDetailDiscussWithProvider => 'ناقش مع المزوّد';

  @override
  String serviceDetailDaysCount(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يوماً',
      few: '$days أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: 'اليوم',
    );
    return '$_temp0';
  }

  @override
  String get serviceDetailTagsSubtitle =>
      'معلومات مفيدة قبل التواصل مع المزوّد';

  @override
  String get serviceDetailProviderPending => 'ستظهر تفاصيل المزوّد عند توفرها.';

  @override
  String get serviceDetailProviderFallbackSemantic => 'مزوّد خدمة';

  @override
  String get serviceDetailContactSubtitle =>
      'تواصل مع المزوّد قبل الخطوة التالية';

  @override
  String get serviceDetailContactProvider => 'تواصل مع المزوّد';

  @override
  String get seatsLoadingMessage => 'جارِ تحميل المقاعد';

  @override
  String get seatsSearchHint => 'بحث';

  @override
  String get seatsStatsInfluencers => 'المؤثرون';

  @override
  String get seatsStatsAvailable => 'المقاعد المتاحة';

  @override
  String get seatsErrorTitle => 'المقاعد غير متاحة';

  @override
  String get seatsErrorFallback => 'تعذّر تحميل المقاعد حالياً.';

  @override
  String get seatsEmptyTitle => 'لا توجد مقاعد بعد';

  @override
  String get seatsEmptyMessage => 'لا توجد مقاعد متاحة بعد.';

  @override
  String get seatsMoreSeatsOpeningSoon => 'مقاعد إضافية ستُفتح قريباً.';

  @override
  String get seatsBookSeatLabel => 'احجز مقعد';

  @override
  String get seatsFollow => 'متابعة';

  @override
  String get seatsFollowComingSoon => 'ميزة المتابعة قريباً.';

  @override
  String get seatsViewProfile => 'عرض الملف الشخصي';

  @override
  String get seatsBookNow => 'احجز الآن';

  @override
  String get seatsOnlyInfluencersCanBook => 'هذا المقعد متاح للمؤثرين للحجز.';

  @override
  String seatsLegendLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'gold': 'مقاعد ذهبية',
      'silver': 'مقاعد فضية',
      'bronze': 'مقاعد برونزية',
      'other': 'مقاعد',
    });
    return '$_temp0';
  }

  @override
  String seatsSingularLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'gold': 'مقعد ذهبي',
      'silver': 'مقعد فضي',
      'bronze': 'مقعد برونزي',
      'other': 'مقعد',
    });
    return '$_temp0';
  }

  @override
  String seatsVisibilityPlacementLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'gold': 'تموضع ذهبي مميّز',
      'silver': 'تموضع فضي مميّز',
      'bronze': 'تموضع برونزي مميّز',
      'other': 'تموضع مميّز',
    });
    return '$_temp0';
  }

  @override
  String get seatsTierDescriptionGold =>
      'توفر المقاعد الذهبية تجربة مشاهدة مميزة بأعلى مستوى من الراحة والوضوح. تتوضع هذه المقاعد في أكثر المواقع استراتيجية لضمان تغطية مثالية وأقصى ظهور. يتمتع المؤثرون هنا بتموضع من الفئة الأولى لظهور أفضل خلال الفعاليات. مصمَّمة لضيوف كبار الشخصيات، وتقدّم مزايا حصرية مثل الوصول الأسرع والتفاعل ذو الأولوية. المقاعد الذهبية تمثّل الفخامة والحصرية وضمان تفاعل مميز.';

  @override
  String get seatsTierDescriptionSilver =>
      'توفر المقاعد الفضية قيمة ممتازة مع وضوح قوي وتموضع رائع ضمن التصميم العام. هذه المقاعد مثالية للمؤثرين الباحثين عن ظهور متوازن دون التكلفة المميزة. توفر المقاعد الفضية راحة ووضوح رؤية مع البقاء قريباً من المناطق الأساسية. خيار مثالي للحملات متوسطة المستوى والفعاليات التي تتطلب تفاعلاً موثوقاً ومستمراً. اختيار ذكي لمن يريد تموضعاً جيداً بسعر معقول.';

  @override
  String get seatsTierDescriptionBronze =>
      'توفر المقاعد البرونزية نقطة دخول ميسورة مع الحفاظ على وضوح جيد بشكل عام. يستفيد المؤثرون في هذه الفئة من تموضع فعّال من حيث التكلفة يناسب الحملات العامة. توفر هذه المقاعد تفاعلاً ثابتاً ووصولاً واسعاً للجمهور دون تسعير مميز. مثالية للمبتدئين أو الراغبين باستكشاف المشاركة بالفعاليات لأول مرة. خيار عملي واقتصادي يضمن حضوراً جيداً ضمن المكان.';

  @override
  String get seatsCheckoutBackTooltip => 'الرجوع للمقاعد';

  @override
  String get seatsCheckoutTitle => 'معاينة الدفع';

  @override
  String get seatsCheckoutSubtitle => 'أكّد التموضع قبل تفعيل الدفع.';

  @override
  String get seatsCheckoutFallbackTitle => 'مقعد مؤثر';

  @override
  String get seatsCheckoutFallbackTier => 'مقعد ظهور';

  @override
  String get seatsCheckoutFallbackPrice => 'يظهر السعر بعد اختيار المقعد';

  @override
  String get seatsCheckoutSeatIdLabel => 'رقم المقعد';

  @override
  String get seatsCheckoutPlacementLabel => 'التموضع';

  @override
  String get seatsCheckoutAmountLabel => 'المبلغ';

  @override
  String get seatsCheckoutPaymentDetailsTitle => 'تفاصيل الدفع';

  @override
  String get seatsCheckoutCardholderName => 'اسم حامل البطاقة';

  @override
  String get seatsCheckoutNameOnCard => 'الاسم على البطاقة';

  @override
  String get seatsCheckoutCardNumber => 'رقم البطاقة';

  @override
  String get seatsCheckoutExpiry => 'تاريخ الانتهاء';

  @override
  String get seatsCheckoutCvv => 'رمز التحقق';

  @override
  String get seatsCheckoutPreviewPayment => 'معاينة الدفع';

  @override
  String get seatsCheckoutPreviewOnlyNotice =>
      'هذه معاينة فقط. لم تتم معالجة أي دفعة.';

  @override
  String get seatsCheckoutNextPhaseNotice =>
      'الحجز والدفع سيُفعّلان بالمرحلة القادمة.';

  @override
  String get leaderboardLoadingMessage => 'جارِ تحميل لائحة المتصدرين';

  @override
  String get leaderboardRefreshErrorFallback => 'تعذّر تحديث لائحة المتصدرين.';

  @override
  String get leaderboardErrorTitle => 'تعذّر تحميل لائحة المتصدرين';

  @override
  String get leaderboardScreenTitle => 'الكأس';

  @override
  String get leaderboardScreenSubtitle =>
      'لائحة بروموو مرتّبة حسب عدد المتابعين.';

  @override
  String get leaderboardEmptyTitle => 'لا توجد لائحة بعد';

  @override
  String get leaderboardEmptyMessage =>
      'ستظهر الملفات المرتّبة هنا عند توفرها.';

  @override
  String get leaderboardPodiumTitle => 'الأول على الكأس';

  @override
  String get leaderboardPodiumSubtitle => 'تصنيف بروموو حسب عدد المتابعين';

  @override
  String leaderboardChampionLine(String followers) {
    return 'البطل / $followers';
  }

  @override
  String get leaderboardRankingTitle => 'الترتيب';

  @override
  String get leaderboardRankingSubtitle =>
      'الشركات والمؤثرون ومزوّدو الخدمات النشطون';

  @override
  String leaderboardFollowersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متابع',
      many: '$count متابعاً',
      few: '$count متابعين',
      two: 'متابعان',
      one: 'متابع واحد',
      zero: 'لا يوجد متابعون',
    );
    return '$_temp0';
  }

  @override
  String leaderboardFollowersCompact(String compact) {
    return '$compact متابع';
  }

  @override
  String get leaderboardAccountTypeFallback => 'ملف بروموو';

  @override
  String get commonSelectCategory => 'اختر الفئة';

  @override
  String get profileLoadingMessage => 'جارِ تحميل الملف الشخصي';

  @override
  String get profileEmptyTitle => 'الملف الشخصي غير موجود';

  @override
  String get profileEmptyMessage =>
      'هذا الملف الشخصي غير متاح أو لم يعد موجوداً.';

  @override
  String get profileRefreshErrorFallback => 'تعذّر تحديث الملف الشخصي.';

  @override
  String get profileErrorTitle => 'تعذّر تحميل الملف الشخصي';

  @override
  String get profileDetailScreenTitle => 'تفاصيل الحساب';

  @override
  String get profileActionFollow => 'متابعة';

  @override
  String get profileActionFollowing => 'متابَع';

  @override
  String get profileActionMessage => 'رسالة';

  @override
  String get profileActionEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileFeaturedBadge => 'مميّز';

  @override
  String get profileAccountTypeUser => 'مستخدم';

  @override
  String get profileStatsFollowers => 'المتابعون';

  @override
  String get profileStatsLikes => 'الإعجابات';

  @override
  String get profileStatsPosts => 'المنشورات';

  @override
  String get profileStatsViews => 'المشاهدات';

  @override
  String get profilePackagesTitle => 'الباقات';

  @override
  String get profilePackagesSubtitle => 'باقات خدمات جاهزة ليكتشفها العملاء';

  @override
  String get profilePackagesEmptyTitle => 'لا توجد باقات بعد';

  @override
  String get profilePackagesEmptyMessage =>
      'ستظهر باقات الملف الشخصي هنا عند توفرها.';

  @override
  String get profilePackageContactOnly => 'بالتواصل فقط';

  @override
  String get profileMediaTitle => 'الوسائط';

  @override
  String get profileMediaSubtitle => 'أحدث منشورات الملف الشخصي وصور الحملات';

  @override
  String get profileMediaEmptyTitle => 'لا توجد وسائط بعد';

  @override
  String get profileMediaEmptyMessage =>
      'ستظهر وسائط الملف الشخصي هنا عند توفرها.';

  @override
  String profileMediaItemSemantic(int index) {
    return 'عنصر وسائط الملف الشخصي $index';
  }

  @override
  String get profileMediaCloseTooltip => 'إغلاق الوسائط';

  @override
  String get profileMediaCommentsLabel => 'التعليقات';

  @override
  String get profileMediaShareLabel => 'مشاركة';

  @override
  String get profileAboutTitle => 'نبذة';

  @override
  String get profileAboutFallback => 'ستظهر تفاصيل الملف الشخصي هنا قريباً.';

  @override
  String get profileEditScreenTitle => 'تعديل الملف الشخصي';

  @override
  String get profileEditUnavailableTitle => 'الملف الشخصي غير متاح';

  @override
  String get profileEditUnavailableMessage => 'تعذّر تحميل ملفك الشخصي الآن.';

  @override
  String get profileEditChangePhoto => 'تغيير صورة الملف الشخصي';

  @override
  String get profileEditChangePhotoComingSoon =>
      'تغيير صورة الملف الشخصي سيُتاح مع ميزة الرفع بالمرحلة القادمة.';

  @override
  String get profileEditFieldName => 'الاسم';

  @override
  String get profileEditFieldBio => 'العنوان الفرعي / النبذة';

  @override
  String get profileEditFieldLocation => 'الموقع';

  @override
  String get profileEditFieldCategory => 'الفئة';

  @override
  String get profileEditCategoryComingSoon =>
      'اختيار الفئة سيُفعّل بالمرحلة القادمة.';

  @override
  String get profileEditSaveButton => 'حفظ';

  @override
  String get profileEditSaving => 'جارٍ الحفظ...';

  @override
  String get profileEditSaveSuccess => 'تم تحديث الملف الشخصي.';

  @override
  String get profileFollowingEmptyTitle => 'لا يوجد متابَعون بعد';

  @override
  String get profileFollowingEmptyMessage => 'ستظهر هنا الملفات التي تتابعها.';

  @override
  String get profileMyPackagesBasicTitle => 'الباقة الأساسية';

  @override
  String get profileMyPackagesStandardTitle => 'الباقة القياسية';

  @override
  String get profileMyPackagesPremiumTitle => 'الباقة المميزة';

  @override
  String get profileMyPackagesBasicPosts => 'تشمل 3 منشورات';

  @override
  String get profileMyPackagesStandardPosts => 'تشمل 6 منشورات';

  @override
  String get profileMyPackagesPremiumPosts => 'تشمل 12 منشوراً';

  @override
  String get profileMyPackagesBullet1 =>
      'منشورات مصممة باحترافية لوسائل التواصل الاجتماعي';

  @override
  String get profileMyPackagesBullet2 =>
      'محتوى عالي الجودة مصمم خصيصاً لعلامتك التجارية';

  @override
  String get profileMyPackagesBullet3 => 'تسليم سريع مضمون خلال 24 ساعة';

  @override
  String get profileMyPackagesGuaranteeLabel => 'الضمان:';

  @override
  String get profileMyPackagesGuaranteeBullet1 =>
      'ثق بأن محتواك سيصل إلى أكثر من 1,000 شخص.';

  @override
  String get profileMyPackagesGuaranteeBullet2 =>
      'تفاعلك وظهورك هما أولويتنا القصوى.';

  @override
  String get profileMyPackagesTapToView =>
      'اضغط لعرض التفاصيل والمتابعة إلى الدفع الآمن.';

  @override
  String get profileMyPackagesCheckoutComingSoon =>
      'الدفع مقابل الباقات سيُتاح بالمرحلة القادمة.';

  @override
  String get profileSavedEmptyTitle => 'لا يوجد محفوظات بعد';

  @override
  String get profileSavedEmptyMessage => 'احفظ العروض والخدمات لتجدها هنا.';

  @override
  String get profileSavedRemoveTooltip => 'إزالة من المحفوظات';

  @override
  String get profileSupportHeroTitle => 'نحن هنا على مدار الساعة';

  @override
  String get profileSupportHeroBody =>
      'لديك أسئلة حول العروض أو المقاعد أو حسابك؟ تواصل مع فريق بروموو في أي وقت.';

  @override
  String get profileSupportChatLabel => 'محادثة مع الدعم';

  @override
  String get profileSupportMessageTitle => 'أرسل لنا رسالة';

  @override
  String get profileSupportMessageHint => 'صف مشكلتك أو سؤالك';

  @override
  String get profileSupportSendButton => 'إرسال';

  @override
  String get profileSupportComingSoon =>
      'مراسلة الدعم ستُربط بالمرحلة القادمة.';

  @override
  String get staticInfoAboutBody =>
      'بروموو هي سوق متميز يربط الشركات والمؤثرين ومزوّدي الخدمات في جميع أنحاء الإمارات.\n\nاكتشف العروض، واحجز مقاعد المؤثرين، وروّج لعلامتك التجارية، ووسّع انتشارك — كل ذلك في مكان واحد، بالدرهم الإماراتي.';

  @override
  String get staticInfoTermsTitle => 'الشروط والأحكام';

  @override
  String get staticInfoTermsBody =>
      'باستخدامك بروموو فإنك توافق على استخدام المنصة بعدل وبما يتوافق مع القانون.\n\n• يجب أن يكون المحتوى الذي تنشره دقيقاً ومملوكاً لك.\n• المواضع المدفوعة (المقاعد، العروض المميزة) تخضع للتسعير المعلن وقت الشراء.\n• الحسابات التي تخالف معايير مجتمعنا قد تُعلَّق.\n\nستُنشر الشروط القانونية الكاملة هنا قبل الإطلاق العام في المتاجر.';

  @override
  String get staticInfoPrivacyBody =>
      'خصوصيتك تهمّ بروموو.\n\n• نجمع فقط البيانات اللازمة لتشغيل حسابك وعرض المحتوى المناسب.\n• لا تُباع بياناتك أبداً لأطراف ثالثة.\n• يمكنك طلب حذف حسابك في أي وقت.\n\nستُنشر سياسة الخصوصية الكاملة هنا قبل الإطلاق العام في المتاجر.';

  @override
  String get addCommonTitleLabel => 'العنوان';

  @override
  String get addCommonDescriptionLabel => 'الوصف';

  @override
  String get addCommonCategoryLabel => 'الفئة';

  @override
  String get addCommonTagsLabel => 'الوسوم';

  @override
  String get addCommonTagsHint => 'وسوم مفصولة بفواصل';

  @override
  String get addCommonCancelButton => 'إلغاء';

  @override
  String get addCommonUploadCaption => 'JPG أو PNG حتى 2 ميغابايت';

  @override
  String get addCommonMediaUploadComingSoon =>
      'رفع الوسائط سيُفعّل بالمرحلة القادمة.';

  @override
  String get addCommonCategoryBeautyWellness => 'الجمال والعافية';

  @override
  String get addCommonCategoryRestaurantsCafes => 'المطاعم والمقاهي';

  @override
  String get addCommonCategoryEventsPhotography => 'الفعاليات والتصوير';

  @override
  String get addCommonCategoryDigitalMarketing => 'التسويق الرقمي';

  @override
  String get addOfferCreateButton => 'إنشاء عرض';

  @override
  String get addOfferDetailsTitle => 'تفاصيل العرض';

  @override
  String get addOfferTitleHint => 'عنوان العرض';

  @override
  String get addOfferDescriptionHint => 'صف عرضك (10 أحرف على الأقل)';

  @override
  String get addOfferPricingTitle => 'التسعير';

  @override
  String get addOfferOriginalPriceLabel => 'السعر الأصلي';

  @override
  String get addOfferOfferPriceLabel => 'سعر العرض';

  @override
  String get addOfferDiscountLabel => 'نسبة الخصم %';

  @override
  String get addOfferDiscountOptionalHint => 'اختياري';

  @override
  String get addOfferDiscountNote =>
      'اتركه فارغاً لحسابه تلقائياً من السعرَين أعلاه.';

  @override
  String get addOfferScheduleTitle => 'الجدول الزمني';

  @override
  String get addOfferStartDateLabel => 'تاريخ البدء';

  @override
  String get addOfferEndDateLabel => 'تاريخ الانتهاء';

  @override
  String get addOfferSelectDate => 'اختر التاريخ';

  @override
  String get addOfferMainImageLabel => 'الصورة الرئيسية';

  @override
  String get addOfferAdditionalImageLabel => 'صورة إضافية';

  @override
  String get addOfferUploadMainImage => 'رفع الصورة الرئيسية';

  @override
  String get addOfferUploadAdditionalImages => 'رفع صور إضافية';

  @override
  String get addOfferReadySnackbar =>
      'عرضك جاهز! سيُفعّل النشر بالمرحلة القادمة.';

  @override
  String get addServiceCreateButton => 'إنشاء خدمة';

  @override
  String get addServiceDetailsTitle => 'تفاصيل الخدمة';

  @override
  String get addServiceTitleHint => 'عنوان الخدمة';

  @override
  String get addServiceDescriptionHint => 'صف خدمتك (10 أحرف على الأقل)';

  @override
  String get addServicePricingTitle => 'التسعير والتسليم';

  @override
  String get addServiceDeliveryLabel => 'مدة التسليم';

  @override
  String get addServiceDeliveryHint => 'مثال: 3';

  @override
  String get addServiceDaysSuffix => 'أيام';

  @override
  String get addServiceImagesLabel => 'الصور';

  @override
  String get addServiceUploadImages => 'رفع صور الخدمة';

  @override
  String get addServiceReadySnackbar =>
      'خدمتك جاهزة! سيُفعّل النشر بالمرحلة القادمة.';

  @override
  String get addAdScreenTitle => 'إضافة إعلان جديد';

  @override
  String get addAdStepBasic => 'تفاصيل الإعلان الأساسية';

  @override
  String get addAdStepLocation => 'معلومات الموقع';

  @override
  String get addAdStepContact => 'معلومات التواصل';

  @override
  String get addAdStepPricing => 'معلومات التسعير';

  @override
  String get addAdTitleLabel => 'عنوان الإعلان';

  @override
  String get addAdUploadImagesLabel => 'رفع صور إضافية';

  @override
  String get addAdPostDateLabel => 'تاريخ النشر';

  @override
  String get addAdSelectDateCap => 'اختر التاريخ';

  @override
  String get addAdTagsHint => 'أضف وسوماً';

  @override
  String get addAdCityLabel => 'المدينة';

  @override
  String get addAdSelectCity => 'اختر المدينة';

  @override
  String get addAdAreaLabel => 'المنطقة';

  @override
  String get addAdSelectArea => 'اختر المنطقة';

  @override
  String get addAdFullAddressLabel => 'العنوان الكامل';

  @override
  String get addAdFullAddressHint => 'العنوان الكامل';

  @override
  String get addAdLocationMapLabel => 'خريطة الموقع';

  @override
  String get addAdUploadLocationMap => 'رفع خريطة الموقع';

  @override
  String get addAdLocationMapCaption => 'يرجى رفع خريطة الموقع';

  @override
  String get addAdPhoneLabel => 'رقم الهاتف';

  @override
  String get addAdWhatsappLabel => 'رقم واتساب';

  @override
  String get addAdInstagramLabel => 'رابط إنستغرام';

  @override
  String get addAdCurrencyLabel => 'العملة';

  @override
  String get addAdSelectCurrency => 'اختر العملة';

  @override
  String get addAdServiceProductLabel => 'خدمة / منتج';

  @override
  String get addAdSelectType => 'اختر النوع';

  @override
  String get addAdPaymentMethodLabel => 'طريقة الدفع';

  @override
  String get addAdSelectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get addAdNextButton => 'التالي';

  @override
  String get addAdCreateButton => 'إنشاء الإعلان';

  @override
  String get addAdReadySnackbar =>
      'إعلانك جاهز! سيُفعّل النشر بالمرحلة القادمة.';

  @override
  String get addAdCityDubai => 'دبي';

  @override
  String get addAdCityAbuDhabi => 'أبوظبي';

  @override
  String get addAdCitySharjah => 'الشارقة';

  @override
  String get addAdCityAjman => 'عجمان';

  @override
  String get addAdCityRasAlKhaimah => 'رأس الخيمة';

  @override
  String get addAdCityFujairah => 'الفجيرة';

  @override
  String get addAdCityUmmAlQuwain => 'أم القيوين';

  @override
  String get addAdCityAlAin => 'العين';

  @override
  String get commonSomethingWentWrongShort => 'حدث خطأ ما.';

  @override
  String get commonLoginRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get commonGoToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get chatWriteMessageHint => 'اكتب رسالة';

  @override
  String get chatSendButton => 'إرسال';

  @override
  String get chatSendingButton => 'جارِ الإرسال';

  @override
  String get chatNoMessagesYet => 'لا توجد رسائل بعد';

  @override
  String get chatListSubtitle => 'أبقِ محادثات حملاتك في مكان واحد.';

  @override
  String get chatLoadingMessage => 'جارِ تحميل المحادثات';

  @override
  String get chatEmptyTitle => 'لا توجد محادثات بعد';

  @override
  String get chatEmptyMessage => 'ستظهر محادثاتك هنا.';

  @override
  String get chatErrorTitle => 'تعذّر تحميل المحادثات';

  @override
  String get chatAuthRequiredMessage => 'سجّل الدخول لاستخدام محادثات بروموو.';

  @override
  String get chatConversationTitle => 'المحادثة';

  @override
  String get chatRoomLoadingMessage => 'جارِ تحميل الرسائل';

  @override
  String get chatRoomEmptyMessage => 'ابدأ المحادثة برسالة قصيرة.';

  @override
  String get chatRoomAuthRequiredMessage => 'سجّل الدخول لفتح هذه المحادثة.';

  @override
  String get chatRoomErrorTitle => 'تعذّر تحميل الرسائل';

  @override
  String get chatMessageStatusSending => 'جارِ الإرسال';

  @override
  String get chatMessageStatusSent => 'أُرسلت';

  @override
  String get chatMessageStatusDelivered => 'وصلت';

  @override
  String get chatMessageStatusRead => 'قُرئت';

  @override
  String get chatMessageStatusFailed => 'فشلت';

  @override
  String get chatMessageStatusUnknown => 'غير معروف';

  @override
  String get notificationDeleteTooltip => 'حذف الإشعار';

  @override
  String notificationsUnreadSubtitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إشعار غير مقروء',
      many: '$count إشعاراً غير مقروء',
      few: '$count إشعارات غير مقروءة',
      two: 'إشعاران غير مقروءَين',
      one: 'إشعار واحد غير مقروء',
      zero: 'لا إشعارات غير مقروءة.',
    );
    return '$_temp0';
  }

  @override
  String get notificationsMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get notificationsLoadingMessage => 'جارِ تحميل الإشعارات';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsEmptyMessage => 'ستظهر هنا تحديثات ورسائل بروموو.';

  @override
  String get notificationsAuthRequiredMessage => 'سجّل الدخول لعرض الإشعارات.';

  @override
  String get notificationsErrorTitle => 'تعذّر تحميل الإشعارات';

  @override
  String get notificationTypeFollow => 'متابعة';

  @override
  String get notificationTypeMessage => 'رسالة';

  @override
  String get notificationTypeOffer => 'عرض';

  @override
  String get notificationTypeSystem => 'النظام';

  @override
  String get notificationTypePayment => 'دفع';

  @override
  String get notificationTypeUnknown => 'إشعار';
}
