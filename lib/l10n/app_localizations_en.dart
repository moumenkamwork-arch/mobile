// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionOk => 'OK';

  @override
  String settingsGreeting(String name) {
    return 'Hi $name';
  }

  @override
  String get settingsWelcomeSubtitle => 'Welcome to Promoo';

  @override
  String get settingsGuest => 'Guest';

  @override
  String get menuFollowing => 'Following';

  @override
  String get menuProfileManagement => 'Profile Management';

  @override
  String get menuAddOffer => 'Add New Offer';

  @override
  String get menuAddAd => 'Add New Ad';

  @override
  String get menuAddService => 'Add New Service';

  @override
  String get menuSaved => 'Saved';

  @override
  String get menuPackages => 'My Packages';

  @override
  String get menuSupport => 'Support';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsArabic => 'Arabic';

  @override
  String get settingsThemeMode => 'Theme Mode';

  @override
  String get settingsBlackMode => 'Black Mode';

  @override
  String get settingsLightMode => 'Light Mode';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get logoutDialogTitle => 'Logout';

  @override
  String get logoutDialogBody => 'Are you sure you want to log out of Promoo?';

  @override
  String get footerAbout => 'About';

  @override
  String get footerTerms => 'Terms & Conditions';

  @override
  String get footerPrivacy => 'Privacy Policy';
}
