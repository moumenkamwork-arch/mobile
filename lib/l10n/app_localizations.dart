import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get commonDismiss;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon'**
  String commonComingSoon(String feature);

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get commonPrice;

  /// No description provided for @commonContactForPricing.
  ///
  /// In en, this message translates to:
  /// **'Contact for pricing'**
  String get commonContactForPricing;

  /// No description provided for @commonDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get commonDescription;

  /// No description provided for @commonProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get commonProvider;

  /// No description provided for @commonDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get commonDetails;

  /// No description provided for @commonOpenChats.
  ///
  /// In en, this message translates to:
  /// **'Open chats'**
  String get commonOpenChats;

  /// No description provided for @commonViewProviderProfile.
  ///
  /// In en, this message translates to:
  /// **'View provider profile'**
  String get commonViewProviderProfile;

  /// No description provided for @commonContactFlowComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Contact flow coming soon. You can open chats or view the provider profile.'**
  String get commonContactFlowComingSoon;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Influencer'**
  String get tabInfluencer;

  /// No description provided for @tabPromoo.
  ///
  /// In en, this message translates to:
  /// **'Promoo'**
  String get tabPromoo;

  /// No description provided for @tabServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get tabServices;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @tabSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} tab'**
  String tabSemanticLabel(String label);

  /// No description provided for @snackbarPressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get snackbarPressBackAgainToExit;

  /// No description provided for @headerSwitchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get headerSwitchToLightMode;

  /// No description provided for @headerSwitchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get headerSwitchToDarkMode;

  /// No description provided for @headerChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get headerChats;

  /// No description provided for @headerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get headerNotifications;

  /// No description provided for @settingsGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}'**
  String settingsGreeting(String name);

  /// No description provided for @settingsWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Promoo'**
  String get settingsWelcomeSubtitle;

  /// No description provided for @settingsGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get settingsGuest;

  /// No description provided for @menuFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get menuFollowing;

  /// No description provided for @menuProfileManagement.
  ///
  /// In en, this message translates to:
  /// **'Profile Management'**
  String get menuProfileManagement;

  /// No description provided for @menuAddOffer.
  ///
  /// In en, this message translates to:
  /// **'Add New Offer'**
  String get menuAddOffer;

  /// No description provided for @menuAddAd.
  ///
  /// In en, this message translates to:
  /// **'Add New Ad'**
  String get menuAddAd;

  /// No description provided for @menuAddService.
  ///
  /// In en, this message translates to:
  /// **'Add New Service'**
  String get menuAddService;

  /// No description provided for @menuSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get menuSaved;

  /// No description provided for @menuPackages.
  ///
  /// In en, this message translates to:
  /// **'My Packages'**
  String get menuPackages;

  /// No description provided for @menuSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get menuSupport;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @settingsArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settingsArabic;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeMode;

  /// No description provided for @settingsBlackMode.
  ///
  /// In en, this message translates to:
  /// **'Black Mode'**
  String get settingsBlackMode;

  /// No description provided for @settingsLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsLightMode;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of Promoo?'**
  String get logoutDialogBody;

  /// No description provided for @footerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get footerAbout;

  /// No description provided for @footerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get footerTerms;

  /// No description provided for @footerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footerPrivacy;

  /// No description provided for @authFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authFieldEmail;

  /// No description provided for @authFieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authFieldPassword;

  /// No description provided for @authFieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFieldFullName;

  /// No description provided for @authFieldAccountType.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get authFieldAccountType;

  /// No description provided for @authPasswordShow.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authPasswordShow;

  /// No description provided for @authPasswordHide.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authPasswordHide;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get authLoggingIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get authCreatingAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get authContinueAsGuest;

  /// No description provided for @authForgetPassword.
  ///
  /// In en, this message translates to:
  /// **'forget password?'**
  String get authForgetPassword;

  /// No description provided for @authSignedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get authSignedInTitle;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out...'**
  String get authSigningOut;

  /// No description provided for @authSocialLoginCaption.
  ///
  /// In en, this message translates to:
  /// **'Log in with account'**
  String get authSocialLoginCaption;

  /// No description provided for @authSocialSignupCaption.
  ///
  /// In en, this message translates to:
  /// **'Sign up with account'**
  String get authSocialSignupCaption;

  /// No description provided for @authAccountTypeUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get authAccountTypeUser;

  /// No description provided for @authAccountTypeCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get authAccountTypeCompany;

  /// No description provided for @authAccountTypeInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Influencer'**
  String get authAccountTypeInfluencer;

  /// No description provided for @authAccountTypeServiceProvider.
  ///
  /// In en, this message translates to:
  /// **'Service provider'**
  String get authAccountTypeServiceProvider;

  /// No description provided for @authValidationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get authValidationEmailRequired;

  /// No description provided for @authValidationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authValidationEmailInvalid;

  /// No description provided for @authValidationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get authValidationPasswordRequired;

  /// No description provided for @authValidationFullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters.'**
  String get authValidationFullNameTooShort;

  /// No description provided for @authValidationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get authValidationPasswordTooShort;

  /// No description provided for @authRegistrationPendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Registration created. Please verify your account before signing in.'**
  String get authRegistrationPendingVerification;

  /// No description provided for @homeLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading Promoo home'**
  String get homeLoadingMessage;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Promoo home content will appear here when it is available.'**
  String get homeEmptyMessage;

  /// No description provided for @homeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load home'**
  String get homeErrorTitle;

  /// No description provided for @homeRefreshErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh home content.'**
  String get homeRefreshErrorFallback;

  /// No description provided for @homeSectionStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get homeSectionStoriesTitle;

  /// No description provided for @homeSectionStoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh updates from Promoo partners'**
  String get homeSectionStoriesSubtitle;

  /// No description provided for @homeSectionTopOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Offers'**
  String get homeSectionTopOffersTitle;

  /// No description provided for @homeSectionTopOffersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Featured offers from Promoo partners'**
  String get homeSectionTopOffersSubtitle;

  /// No description provided for @homeSectionForYouTitle.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get homeSectionForYouTitle;

  /// No description provided for @homeSectionForYouSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Selected offers for today'**
  String get homeSectionForYouSubtitle;

  /// No description provided for @homeSectionServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Premium campaign services ready for contact'**
  String get homeSectionServicesSubtitle;

  /// No description provided for @homeSectionPromooOfDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Promoo of the Day'**
  String get homeSectionPromooOfDayTitle;

  /// No description provided for @homeSectionPromooOfDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s featured Promoo pick'**
  String get homeSectionPromooOfDaySubtitle;

  /// No description provided for @homeTopOfferBadge.
  ///
  /// In en, this message translates to:
  /// **'Top offer'**
  String get homeTopOfferBadge;

  /// No description provided for @homeServiceBadge.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get homeServiceBadge;

  /// No description provided for @homeServiceFallbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Provider service'**
  String get homeServiceFallbackSubtitle;

  /// No description provided for @homeSeeAllTitleBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get homeSeeAllTitleBrowse;

  /// No description provided for @homeSeeAllErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load'**
  String get homeSeeAllErrorTitle;

  /// No description provided for @homeSeeAllEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get homeSeeAllEmptyTitle;

  /// No description provided for @homeSeeAllEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Items for this section will appear here soon.'**
  String get homeSeeAllEmptyMessage;

  /// No description provided for @homeStoryViewerCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close story'**
  String get homeStoryViewerCloseTooltip;

  /// No description provided for @homeDetailLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading details'**
  String get homeDetailLoadingMessage;

  /// No description provided for @homeDetailErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load details'**
  String get homeDetailErrorTitle;

  /// No description provided for @homeDetailTypeOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get homeDetailTypeOffer;

  /// No description provided for @homeDetailTypeAd.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get homeDetailTypeAd;

  /// No description provided for @homeDetailTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Promoo item'**
  String get homeDetailTypeUnknown;

  /// No description provided for @homeDetailLocationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Location details coming soon. The current location is {location}.'**
  String homeDetailLocationComingSoon(String location);

  /// No description provided for @homeDetailAvailabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get homeDetailAvailabilityLabel;

  /// No description provided for @homeDetailAvailabilityFallback.
  ///
  /// In en, this message translates to:
  /// **'Confirm with provider'**
  String get homeDetailAvailabilityFallback;

  /// No description provided for @homeDetailNextStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get homeDetailNextStepTitle;

  /// No description provided for @homeDetailNextStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with the provider before taking action'**
  String get homeDetailNextStepSubtitle;

  /// No description provided for @homeDetailContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get homeDetailContact;

  /// No description provided for @homeDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get homeDetailLocation;

  /// No description provided for @servicesLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading services'**
  String get servicesLoadingMessage;

  /// No description provided for @servicesRefreshErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh services.'**
  String get servicesRefreshErrorFallback;

  /// No description provided for @servicesErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load services'**
  String get servicesErrorTitle;

  /// No description provided for @servicesSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get servicesSearchResultsTitle;

  /// No description provided for @servicesResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No services} =1{1 service} other{{count} services}}'**
  String servicesResultsCount(num count);

  /// No description provided for @servicesBackToCategoriesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to categories'**
  String get servicesBackToCategoriesTooltip;

  /// No description provided for @servicesAllCategory.
  ///
  /// In en, this message translates to:
  /// **'All services'**
  String get servicesAllCategory;

  /// No description provided for @servicesCategorySemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} category'**
  String servicesCategorySemanticLabel(String label);

  /// No description provided for @servicesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search services'**
  String get servicesSearchHint;

  /// No description provided for @servicesClearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get servicesClearSearchTooltip;

  /// No description provided for @servicesEmptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'No service found.'**
  String get servicesEmptyFilteredTitle;

  /// No description provided for @servicesEmptyFilteredMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find this service yet.'**
  String get servicesEmptyFilteredMessage;

  /// No description provided for @servicesEmptyDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'No services yet'**
  String get servicesEmptyDefaultTitle;

  /// No description provided for @servicesEmptyDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Search or choose a category to discover services.'**
  String get servicesEmptyDefaultMessage;

  /// No description provided for @servicesDeliveryDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day delivery} other{{days} days delivery}}'**
  String servicesDeliveryDaysLabel(num days);

  /// No description provided for @serviceDetailLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading service details'**
  String get serviceDetailLoadingMessage;

  /// No description provided for @serviceDetailErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load service'**
  String get serviceDetailErrorTitle;

  /// No description provided for @serviceDetailScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Service details'**
  String get serviceDetailScreenTitle;

  /// No description provided for @serviceDetailTimelineLabel.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get serviceDetailTimelineLabel;

  /// No description provided for @serviceDetailDiscussWithProvider.
  ///
  /// In en, this message translates to:
  /// **'Discuss with provider'**
  String get serviceDetailDiscussWithProvider;

  /// No description provided for @serviceDetailDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String serviceDetailDaysCount(num days);

  /// No description provided for @serviceDetailTagsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Useful signals before contacting the provider'**
  String get serviceDetailTagsSubtitle;

  /// No description provided for @serviceDetailProviderPending.
  ///
  /// In en, this message translates to:
  /// **'Provider details will appear when available.'**
  String get serviceDetailProviderPending;

  /// No description provided for @serviceDetailProviderFallbackSemantic.
  ///
  /// In en, this message translates to:
  /// **'Service provider'**
  String get serviceDetailProviderFallbackSemantic;

  /// No description provided for @serviceDetailContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with the provider before taking the next step'**
  String get serviceDetailContactSubtitle;

  /// No description provided for @serviceDetailContactProvider.
  ///
  /// In en, this message translates to:
  /// **'Contact provider'**
  String get serviceDetailContactProvider;

  /// No description provided for @seatsLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading seats'**
  String get seatsLoadingMessage;

  /// No description provided for @seatsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get seatsSearchHint;

  /// No description provided for @seatsStatsInfluencers.
  ///
  /// In en, this message translates to:
  /// **'Influencers'**
  String get seatsStatsInfluencers;

  /// No description provided for @seatsStatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available seats'**
  String get seatsStatsAvailable;

  /// No description provided for @seatsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Seats unavailable'**
  String get seatsErrorTitle;

  /// No description provided for @seatsErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not load seats right now.'**
  String get seatsErrorFallback;

  /// No description provided for @seatsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No seats yet'**
  String get seatsEmptyTitle;

  /// No description provided for @seatsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No seats available yet.'**
  String get seatsEmptyMessage;

  /// No description provided for @seatsMoreSeatsOpeningSoon.
  ///
  /// In en, this message translates to:
  /// **'More seats are opening soon.'**
  String get seatsMoreSeatsOpeningSoon;

  /// No description provided for @seatsBookSeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Book Seat'**
  String get seatsBookSeatLabel;

  /// No description provided for @seatsFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get seatsFollow;

  /// No description provided for @seatsFollowComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Follow is coming soon.'**
  String get seatsFollowComingSoon;

  /// No description provided for @seatsViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get seatsViewProfile;

  /// No description provided for @seatsBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get seatsBookNow;

  /// No description provided for @seatsLegendLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier, select, gold{Gold Seats} silver{Silver Seats} bronze{Bronze Seats} other{Seats}}'**
  String seatsLegendLabel(String tier);

  /// No description provided for @seatsSingularLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier, select, gold{Gold Seat} silver{Silver Seat} bronze{Bronze Seat} other{Seat}}'**
  String seatsSingularLabel(String tier);

  /// No description provided for @seatsVisibilityPlacementLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier, select, gold{Gold visibility placement} silver{Silver visibility placement} bronze{Bronze visibility placement} other{Seat visibility placement}}'**
  String seatsVisibilityPlacementLabel(String tier);

  /// No description provided for @seatsTierDescriptionGold.
  ///
  /// In en, this message translates to:
  /// **'Gold seats provide a premium viewing experience with the highest level of comfort and visibility. These seats are positioned in the most strategic locations to ensure perfect coverage and maximum exposure. Influencers seated here enjoy top-tier placement for enhanced visibility during events. Designed for VIP guests, they offer exclusive benefits such as faster access and priority interaction. Gold seating represents luxury, exclusivity, and guaranteed premium engagement.'**
  String get seatsTierDescriptionGold;

  /// No description provided for @seatsTierDescriptionSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver seats offer excellent value with strong visibility and great overall positioning within the layout. These seats are ideal for influencers looking for balanced exposure without the premium cost. Silver seating provides comfort and a clear line of sight while still being close to the core areas. Perfect for mid-range promotions and events requiring consistent, reliable engagement. A smart choice for those who want quality placement at an affordable rate.'**
  String get seatsTierDescriptionSilver;

  /// No description provided for @seatsTierDescriptionBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze seats offer an accessible entry point while still maintaining good overall visibility. Influencers in this category benefit from cost-effective placement suitable for general campaigns. These seats provide steady engagement and broad audience reach without premium pricing. Ideal for newcomers or those exploring event participation for the first time. A practical and budget-friendly choice that still ensures a good presence within the venue.'**
  String get seatsTierDescriptionBronze;

  /// No description provided for @seatsCheckoutBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to seats'**
  String get seatsCheckoutBackTooltip;

  /// No description provided for @seatsCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout preview'**
  String get seatsCheckoutTitle;

  /// No description provided for @seatsCheckoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm the placement before payment is enabled.'**
  String get seatsCheckoutSubtitle;

  /// No description provided for @seatsCheckoutFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Influencer Seat'**
  String get seatsCheckoutFallbackTitle;

  /// No description provided for @seatsCheckoutFallbackTier.
  ///
  /// In en, this message translates to:
  /// **'Visibility seat'**
  String get seatsCheckoutFallbackTier;

  /// No description provided for @seatsCheckoutFallbackPrice.
  ///
  /// In en, this message translates to:
  /// **'Price shown after seat selection'**
  String get seatsCheckoutFallbackPrice;

  /// No description provided for @seatsCheckoutSeatIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat ID'**
  String get seatsCheckoutSeatIdLabel;

  /// No description provided for @seatsCheckoutPlacementLabel.
  ///
  /// In en, this message translates to:
  /// **'Placement'**
  String get seatsCheckoutPlacementLabel;

  /// No description provided for @seatsCheckoutAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get seatsCheckoutAmountLabel;

  /// No description provided for @seatsCheckoutPaymentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get seatsCheckoutPaymentDetailsTitle;

  /// No description provided for @seatsCheckoutCardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder name'**
  String get seatsCheckoutCardholderName;

  /// No description provided for @seatsCheckoutNameOnCard.
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get seatsCheckoutNameOnCard;

  /// No description provided for @seatsCheckoutCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get seatsCheckoutCardNumber;

  /// No description provided for @seatsCheckoutExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get seatsCheckoutExpiry;

  /// No description provided for @seatsCheckoutCvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get seatsCheckoutCvv;

  /// No description provided for @seatsCheckoutPreviewPayment.
  ///
  /// In en, this message translates to:
  /// **'Preview payment'**
  String get seatsCheckoutPreviewPayment;

  /// No description provided for @seatsCheckoutPreviewOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Checkout preview only. No payment was processed.'**
  String get seatsCheckoutPreviewOnlyNotice;

  /// No description provided for @seatsCheckoutNextPhaseNotice.
  ///
  /// In en, this message translates to:
  /// **'Booking and payment open in the next phase.'**
  String get seatsCheckoutNextPhaseNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
