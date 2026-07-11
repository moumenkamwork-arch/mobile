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
}
