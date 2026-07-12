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
  String get authForgetPassword => 'نسيت كلمة المرور؟';

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
}
