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

  /// No description provided for @tabOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get tabOffers;

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

  /// No description provided for @menuFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get menuFollowers;

  /// No description provided for @menuBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get menuBlockedUsers;

  /// No description provided for @menuMyListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get menuMyListings;

  /// No description provided for @reportAction.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportAction;

  /// No description provided for @reportSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportSheetTitle;

  /// No description provided for @reportSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this?'**
  String get reportSheetSubtitle;

  /// No description provided for @reportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or misleading'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get reportReasonInappropriate;

  /// No description provided for @reportReasonHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get reportReasonHarassment;

  /// No description provided for @reportReasonScam.
  ///
  /// In en, this message translates to:
  /// **'Scam or fraud'**
  String get reportReasonScam;

  /// No description provided for @reportReasonFalseInfo.
  ///
  /// In en, this message translates to:
  /// **'False information'**
  String get reportReasonFalseInfo;

  /// No description provided for @reportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportReasonOther;

  /// No description provided for @reportDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get reportDetailsLabel;

  /// No description provided for @reportDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Add anything that helps us review this'**
  String get reportDetailsHint;

  /// No description provided for @reportSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get reportSubmitButton;

  /// No description provided for @reportSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get reportSubmitting;

  /// No description provided for @reportSubmittedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Thanks — your report was submitted'**
  String get reportSubmittedSnackbar;

  /// No description provided for @reportFailedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t submit the report — try again'**
  String get reportFailedSnackbar;

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

  /// No description provided for @savedButtonSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get savedButtonSaveTooltip;

  /// No description provided for @savedButtonUnsaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unsave'**
  String get savedButtonUnsaveTooltip;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @profileBlockAction.
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get profileBlockAction;

  /// No description provided for @profileUnblockAction.
  ///
  /// In en, this message translates to:
  /// **'Unblock user'**
  String get profileUnblockAction;

  /// No description provided for @profileBlockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Block this user?'**
  String get profileBlockConfirmTitle;

  /// No description provided for @profileBlockConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to message you, and you won\'t see each other\'s content.'**
  String get profileBlockConfirmMessage;

  /// No description provided for @profileBlockConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get profileBlockConfirmButton;

  /// No description provided for @profileUnblockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Unblock this user?'**
  String get profileUnblockConfirmTitle;

  /// No description provided for @profileUnblockConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'They will be able to message you again.'**
  String get profileUnblockConfirmMessage;

  /// No description provided for @profileUnblockConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get profileUnblockConfirmButton;

  /// No description provided for @profileBlockedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'User blocked'**
  String get profileBlockedSnackbar;

  /// No description provided for @profileUnblockedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'User unblocked'**
  String get profileUnblockedSnackbar;

  /// No description provided for @blockedUsersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get blockedUsersEmptyTitle;

  /// No description provided for @blockedUsersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Accounts you block will appear here.'**
  String get blockedUsersEmptyMessage;

  /// No description provided for @myListingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing published yet'**
  String get myListingsEmptyTitle;

  /// No description provided for @myListingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Offers, services, and ads you publish will appear here.'**
  String get myListingsEmptyMessage;

  /// No description provided for @myListingsOffersSection.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get myListingsOffersSection;

  /// No description provided for @myListingsServicesSection.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get myListingsServicesSection;

  /// No description provided for @myListingsAdsSection.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get myListingsAdsSection;

  /// No description provided for @myListingsEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get myListingsEditTooltip;

  /// No description provided for @myListingsDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get myListingsDeleteTooltip;

  /// No description provided for @myListingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this listing?'**
  String get myListingsDeleteConfirmTitle;

  /// No description provided for @myListingsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get myListingsDeleteConfirmMessage;

  /// No description provided for @myListingsDeleteConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get myListingsDeleteConfirmButton;

  /// No description provided for @myListingsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete — try again.'**
  String get myListingsDeleteFailed;

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

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account permanently?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your profile, listings, chats, and everything else tied to your account. This cannot be undone.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your account — try again.'**
  String get deleteAccountFailed;

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

  /// No description provided for @homeStoryYourStory.
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get homeStoryYourStory;

  /// No description provided for @homeStoryUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading story…'**
  String get homeStoryUploading;

  /// No description provided for @homeStoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Story added.'**
  String get homeStoryAdded;

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

  /// No description provided for @homeStoryViewerMoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get homeStoryViewerMoreTooltip;

  /// No description provided for @homeStoryViewerDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete story'**
  String get homeStoryViewerDeleteAction;

  /// No description provided for @homeStoryViewerDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this story?'**
  String get homeStoryViewerDeleteConfirmTitle;

  /// No description provided for @homeStoryViewerDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get homeStoryViewerDeleteConfirmMessage;

  /// No description provided for @homeStoryViewerDeleteConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get homeStoryViewerDeleteConfirmButton;

  /// No description provided for @homeStoryViewerCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get homeStoryViewerCancelButton;

  /// No description provided for @homeStoryViewerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Story deleted.'**
  String get homeStoryViewerDeleted;

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

  /// No description provided for @seatsOnlyInfluencersCanBook.
  ///
  /// In en, this message translates to:
  /// **'This seat is available for influencers to book.'**
  String get seatsOnlyInfluencersCanBook;

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

  /// No description provided for @leaderboardLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading leaderboard'**
  String get leaderboardLoadingMessage;

  /// No description provided for @leaderboardRefreshErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh leaderboard.'**
  String get leaderboardRefreshErrorFallback;

  /// No description provided for @leaderboardErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load leaderboard'**
  String get leaderboardErrorTitle;

  /// No description provided for @leaderboardScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Cup'**
  String get leaderboardScreenTitle;

  /// No description provided for @leaderboardScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Promoo leaderboard ranked by follower reach.'**
  String get leaderboardScreenSubtitle;

  /// No description provided for @leaderboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard yet'**
  String get leaderboardEmptyTitle;

  /// No description provided for @leaderboardEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Ranked profiles will appear here when they are available.'**
  String get leaderboardEmptyMessage;

  /// No description provided for @leaderboardPodiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Top of the Cup'**
  String get leaderboardPodiumTitle;

  /// No description provided for @leaderboardPodiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Followers-based Promoo standings'**
  String get leaderboardPodiumSubtitle;

  /// No description provided for @leaderboardChampionLine.
  ///
  /// In en, this message translates to:
  /// **'Champion / {followers}'**
  String leaderboardChampionLine(String followers);

  /// No description provided for @leaderboardRankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get leaderboardRankingTitle;

  /// No description provided for @leaderboardRankingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active companies, influencers, and service providers'**
  String get leaderboardRankingSubtitle;

  /// No description provided for @leaderboardFollowersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No followers} =1{1 follower} other{{count} followers}}'**
  String leaderboardFollowersCount(num count);

  /// No description provided for @leaderboardFollowersCompact.
  ///
  /// In en, this message translates to:
  /// **'{compact} followers'**
  String leaderboardFollowersCompact(String compact);

  /// No description provided for @leaderboardAccountTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'Promoo profile'**
  String get leaderboardAccountTypeFallback;

  /// No description provided for @commonSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get commonSelectCategory;

  /// No description provided for @profileLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading profile'**
  String get profileLoadingMessage;

  /// No description provided for @profileEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileEmptyTitle;

  /// No description provided for @profileEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This profile is unavailable or no longer exists.'**
  String get profileEmptyMessage;

  /// No description provided for @profileRefreshErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh profile.'**
  String get profileRefreshErrorFallback;

  /// No description provided for @profileErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile'**
  String get profileErrorTitle;

  /// No description provided for @profileDetailScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profileDetailScreenTitle;

  /// No description provided for @profileActionFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profileActionFollow;

  /// No description provided for @profileActionFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileActionFollowing;

  /// No description provided for @profileActionMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get profileActionMessage;

  /// No description provided for @profileActionEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileActionEditProfile;

  /// No description provided for @profileFeaturedBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get profileFeaturedBadge;

  /// No description provided for @profileAccountTypeUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileAccountTypeUser;

  /// No description provided for @profileStatsFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileStatsFollowers;

  /// No description provided for @profileStatsLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get profileStatsLikes;

  /// No description provided for @profileStatsPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profileStatsPosts;

  /// No description provided for @profileStatsViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get profileStatsViews;

  /// No description provided for @profilePackagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get profilePackagesTitle;

  /// No description provided for @profilePackagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile services ready for client discovery'**
  String get profilePackagesSubtitle;

  /// No description provided for @profilePackagesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No packages yet'**
  String get profilePackagesEmptyTitle;

  /// No description provided for @profilePackagesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile packages will appear here when available.'**
  String get profilePackagesEmptyMessage;

  /// No description provided for @profilePackageContactOnly.
  ///
  /// In en, this message translates to:
  /// **'Contact only'**
  String get profilePackageContactOnly;

  /// No description provided for @profileMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get profileMediaTitle;

  /// No description provided for @profileMediaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent profile posts and campaign visuals'**
  String get profileMediaSubtitle;

  /// No description provided for @profileMediaEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No media yet'**
  String get profileMediaEmptyTitle;

  /// No description provided for @profileMediaEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile media will appear here when it is available.'**
  String get profileMediaEmptyMessage;

  /// No description provided for @profileMediaItemSemantic.
  ///
  /// In en, this message translates to:
  /// **'Profile media item {index}'**
  String profileMediaItemSemantic(int index);

  /// No description provided for @profileMediaCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close media'**
  String get profileMediaCloseTooltip;

  /// No description provided for @profileMediaCommentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get profileMediaCommentsLabel;

  /// No description provided for @profileMediaShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get profileMediaShareLabel;

  /// No description provided for @profileAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAboutTitle;

  /// No description provided for @profileAboutFallback.
  ///
  /// In en, this message translates to:
  /// **'Profile details will appear here soon.'**
  String get profileAboutFallback;

  /// No description provided for @profileEditScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditScreenTitle;

  /// No description provided for @profileEditUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile unavailable'**
  String get profileEditUnavailableTitle;

  /// No description provided for @profileEditUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile right now.'**
  String get profileEditUnavailableMessage;

  /// No description provided for @profileEditChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get profileEditChangePhoto;

  /// No description provided for @profileEditChangePhotoComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Changing the profile photo arrives with uploads in the next phase.'**
  String get profileEditChangePhotoComingSoon;

  /// No description provided for @profileEditFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileEditFieldName;

  /// No description provided for @profileEditFieldBio.
  ///
  /// In en, this message translates to:
  /// **'Subtitle / Bio'**
  String get profileEditFieldBio;

  /// No description provided for @profileEditFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileEditFieldLocation;

  /// No description provided for @profileEditFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get profileEditFieldCategory;

  /// No description provided for @profileEditCategoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Category selection will be enabled in the next phase.'**
  String get profileEditCategoryComingSoon;

  /// No description provided for @profileEditSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditSaveButton;

  /// No description provided for @profileEditSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get profileEditSaving;

  /// No description provided for @profileEditSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileEditSaveSuccess;

  /// No description provided for @profileEditUploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo…'**
  String get profileEditUploadingPhoto;

  /// No description provided for @profileEditPhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated.'**
  String get profileEditPhotoUpdated;

  /// No description provided for @profileEditTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get profileEditTakePhoto;

  /// No description provided for @profileEditChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profileEditChooseFromGallery;

  /// No description provided for @profileFollowingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No follows yet'**
  String get profileFollowingEmptyTitle;

  /// No description provided for @profileFollowingEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Profiles you follow will appear here.'**
  String get profileFollowingEmptyMessage;

  /// No description provided for @profileFollowersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get profileFollowersEmptyTitle;

  /// No description provided for @profileFollowersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'People who follow you will appear here.'**
  String get profileFollowersEmptyMessage;

  /// No description provided for @profileMyPackagesBasicTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Package'**
  String get profileMyPackagesBasicTitle;

  /// No description provided for @profileMyPackagesStandardTitle.
  ///
  /// In en, this message translates to:
  /// **'Standard Package'**
  String get profileMyPackagesStandardTitle;

  /// No description provided for @profileMyPackagesPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Package'**
  String get profileMyPackagesPremiumTitle;

  /// No description provided for @profileMyPackagesBasicPosts.
  ///
  /// In en, this message translates to:
  /// **'Includes 3 posts'**
  String get profileMyPackagesBasicPosts;

  /// No description provided for @profileMyPackagesStandardPosts.
  ///
  /// In en, this message translates to:
  /// **'Includes 6 posts'**
  String get profileMyPackagesStandardPosts;

  /// No description provided for @profileMyPackagesPremiumPosts.
  ///
  /// In en, this message translates to:
  /// **'Includes 12 posts'**
  String get profileMyPackagesPremiumPosts;

  /// No description provided for @profileMyPackagesBullet1.
  ///
  /// In en, this message translates to:
  /// **'Professionally designed social media posts'**
  String get profileMyPackagesBullet1;

  /// No description provided for @profileMyPackagesBullet2.
  ///
  /// In en, this message translates to:
  /// **'High-quality content tailored to your brand'**
  String get profileMyPackagesBullet2;

  /// No description provided for @profileMyPackagesBullet3.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed fast delivery within 24 hours'**
  String get profileMyPackagesBullet3;

  /// No description provided for @profileMyPackagesGuaranteeLabel.
  ///
  /// In en, this message translates to:
  /// **'Guarantee:'**
  String get profileMyPackagesGuaranteeLabel;

  /// No description provided for @profileMyPackagesGuaranteeBullet1.
  ///
  /// In en, this message translates to:
  /// **'Trust that your content will reach more than 1,000 people.'**
  String get profileMyPackagesGuaranteeBullet1;

  /// No description provided for @profileMyPackagesGuaranteeBullet2.
  ///
  /// In en, this message translates to:
  /// **'Your engagement and visibility are our top priority.'**
  String get profileMyPackagesGuaranteeBullet2;

  /// No description provided for @profileMyPackagesTapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details and proceed to secure checkout.'**
  String get profileMyPackagesTapToView;

  /// No description provided for @profileMyPackagesCheckoutComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Package checkout will be available in the next phase.'**
  String get profileMyPackagesCheckoutComingSoon;

  /// No description provided for @profileSavedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get profileSavedEmptyTitle;

  /// No description provided for @profileSavedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Bookmark offers and services to find them here.'**
  String get profileSavedEmptyMessage;

  /// No description provided for @profileSavedRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get profileSavedRemoveTooltip;

  /// No description provided for @profileSupportHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'We are here 24/7'**
  String get profileSupportHeroTitle;

  /// No description provided for @profileSupportHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Questions about offers, seats, or your account? Reach the Promoo team any time.'**
  String get profileSupportHeroBody;

  /// No description provided for @profileSupportChatLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat with support'**
  String get profileSupportChatLabel;

  /// No description provided for @profileSupportMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get profileSupportMessageTitle;

  /// No description provided for @profileSupportMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or question'**
  String get profileSupportMessageHint;

  /// No description provided for @profileSupportSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get profileSupportSendButton;

  /// No description provided for @profileSupportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Support messaging will be connected in the next phase.'**
  String get profileSupportComingSoon;

  /// No description provided for @staticInfoAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Promoo is a premium marketplace connecting companies, influencers, and service providers across the UAE.\n\nDiscover offers, book influencer seats, promote your brand, and grow your reach — all in one place, in AED.'**
  String get staticInfoAboutBody;

  /// No description provided for @staticInfoTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms And Condition'**
  String get staticInfoTermsTitle;

  /// No description provided for @staticInfoTermsBody.
  ///
  /// In en, this message translates to:
  /// **'By using Promoo you agree to use the platform fairly and lawfully.\n\n• Content you publish must be accurate and owned by you.\n• Paid placements (seats, featured offers) follow the posted pricing at the time of purchase.\n• Accounts that violate our community standards may be suspended.\n\nThe full legal terms will be published here before the public store release.'**
  String get staticInfoTermsBody;

  /// No description provided for @staticInfoPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters to Promoo.\n\n• We only collect the data needed to run your account and show relevant content.\n• Your data is never sold to third parties.\n• You can request account deletion at any time.\n\nThe full privacy policy will be published here before the public store release.'**
  String get staticInfoPrivacyBody;

  /// No description provided for @addCommonTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get addCommonTitleLabel;

  /// No description provided for @addCommonDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addCommonDescriptionLabel;

  /// No description provided for @addCommonCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addCommonCategoryLabel;

  /// No description provided for @addCommonTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get addCommonTagsLabel;

  /// No description provided for @addCommonTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Comma separated tags'**
  String get addCommonTagsHint;

  /// No description provided for @addCommonCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get addCommonCancelButton;

  /// No description provided for @addCommonUploadCaption.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG up to 2MB'**
  String get addCommonUploadCaption;

  /// No description provided for @addCommonMediaUploadComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Media upload will be enabled in the next phase.'**
  String get addCommonMediaUploadComingSoon;

  /// No description provided for @addCommonCategoryBeautyWellness.
  ///
  /// In en, this message translates to:
  /// **'Beauty & Wellness'**
  String get addCommonCategoryBeautyWellness;

  /// No description provided for @addCommonCategoryRestaurantsCafes.
  ///
  /// In en, this message translates to:
  /// **'Restaurants & Cafes'**
  String get addCommonCategoryRestaurantsCafes;

  /// No description provided for @addCommonCategoryEventsPhotography.
  ///
  /// In en, this message translates to:
  /// **'Events & Photography'**
  String get addCommonCategoryEventsPhotography;

  /// No description provided for @addCommonCategoryDigitalMarketing.
  ///
  /// In en, this message translates to:
  /// **'Digital Marketing'**
  String get addCommonCategoryDigitalMarketing;

  /// No description provided for @addCommonUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get addCommonUploading;

  /// No description provided for @addCommonReplaceImage.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get addCommonReplaceImage;

  /// No description provided for @addCommonRemoveImage.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get addCommonRemoveImage;

  /// No description provided for @addCommonCategoriesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load categories. Try again.'**
  String get addCommonCategoriesUnavailable;

  /// No description provided for @addCommonPublishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get addCommonPublishing;

  /// No description provided for @addCommonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get addCommonSaving;

  /// No description provided for @addCommonSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get addCommonSaveButton;

  /// No description provided for @addOfferEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Offer'**
  String get addOfferEditTitle;

  /// No description provided for @addServiceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get addServiceEditTitle;

  /// No description provided for @addAdEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Ad'**
  String get addAdEditTitle;

  /// No description provided for @addOfferUpdated.
  ///
  /// In en, this message translates to:
  /// **'Offer updated'**
  String get addOfferUpdated;

  /// No description provided for @addServiceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Service updated'**
  String get addServiceUpdated;

  /// No description provided for @addAdUpdated.
  ///
  /// In en, this message translates to:
  /// **'Ad updated'**
  String get addAdUpdated;

  /// No description provided for @addCommonValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Please complete the required fields.'**
  String get addCommonValidationTitle;

  /// No description provided for @addCommonSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t publish. {error}'**
  String addCommonSubmitFailed(Object error);

  /// No description provided for @addOfferPublished.
  ///
  /// In en, this message translates to:
  /// **'Offer published.'**
  String get addOfferPublished;

  /// No description provided for @addServicePublished.
  ///
  /// In en, this message translates to:
  /// **'Service published.'**
  String get addServicePublished;

  /// No description provided for @addAdPublished.
  ///
  /// In en, this message translates to:
  /// **'Ad submitted.'**
  String get addAdPublished;

  /// No description provided for @addOfferCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Offer'**
  String get addOfferCreateButton;

  /// No description provided for @addOfferDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offer Details'**
  String get addOfferDetailsTitle;

  /// No description provided for @addOfferTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Offer title'**
  String get addOfferTitleHint;

  /// No description provided for @addOfferDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your offer (at least 10 characters)'**
  String get addOfferDescriptionHint;

  /// No description provided for @addOfferPricingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get addOfferPricingTitle;

  /// No description provided for @addOfferOriginalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Original Price'**
  String get addOfferOriginalPriceLabel;

  /// No description provided for @addOfferOfferPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer Price'**
  String get addOfferOfferPriceLabel;

  /// No description provided for @addOfferDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get addOfferDiscountLabel;

  /// No description provided for @addOfferDiscountOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get addOfferDiscountOptionalHint;

  /// No description provided for @addOfferDiscountNote.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to auto-calculate from the prices above.'**
  String get addOfferDiscountNote;

  /// No description provided for @addOfferScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get addOfferScheduleTitle;

  /// No description provided for @addOfferStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get addOfferStartDateLabel;

  /// No description provided for @addOfferEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get addOfferEndDateLabel;

  /// No description provided for @addOfferSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get addOfferSelectDate;

  /// No description provided for @addOfferMainImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Main Image'**
  String get addOfferMainImageLabel;

  /// No description provided for @addOfferAdditionalImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Image'**
  String get addOfferAdditionalImageLabel;

  /// No description provided for @addOfferUploadMainImage.
  ///
  /// In en, this message translates to:
  /// **'Upload main image'**
  String get addOfferUploadMainImage;

  /// No description provided for @addOfferUploadAdditionalImages.
  ///
  /// In en, this message translates to:
  /// **'Upload additional images'**
  String get addOfferUploadAdditionalImages;

  /// No description provided for @addOfferReadySnackbar.
  ///
  /// In en, this message translates to:
  /// **'Your offer is ready! Publishing will be enabled in the next phase.'**
  String get addOfferReadySnackbar;

  /// No description provided for @addServiceCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Service'**
  String get addServiceCreateButton;

  /// No description provided for @addServiceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get addServiceDetailsTitle;

  /// No description provided for @addServiceTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Service title'**
  String get addServiceTitleHint;

  /// No description provided for @addServiceDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your service (at least 10 characters)'**
  String get addServiceDescriptionHint;

  /// No description provided for @addServicePricingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Delivery'**
  String get addServicePricingTitle;

  /// No description provided for @addServiceDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get addServiceDeliveryLabel;

  /// No description provided for @addServiceDeliveryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3'**
  String get addServiceDeliveryHint;

  /// No description provided for @addServiceDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get addServiceDaysSuffix;

  /// No description provided for @addServiceImagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get addServiceImagesLabel;

  /// No description provided for @addServiceUploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload service images'**
  String get addServiceUploadImages;

  /// No description provided for @addServiceReadySnackbar.
  ///
  /// In en, this message translates to:
  /// **'Your service is ready! Publishing will be enabled in the next phase.'**
  String get addServiceReadySnackbar;

  /// No description provided for @addAdScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New AD'**
  String get addAdScreenTitle;

  /// No description provided for @addAdStepBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Ad Details'**
  String get addAdStepBasic;

  /// No description provided for @addAdStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get addAdStepLocation;

  /// No description provided for @addAdStepContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get addAdStepContact;

  /// No description provided for @addAdStepPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing Information'**
  String get addAdStepPricing;

  /// No description provided for @addAdTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Ad Title'**
  String get addAdTitleLabel;

  /// No description provided for @addAdUploadImagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload additional images'**
  String get addAdUploadImagesLabel;

  /// No description provided for @addAdPostDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Post Date'**
  String get addAdPostDateLabel;

  /// No description provided for @addAdSelectDateCap.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get addAdSelectDateCap;

  /// No description provided for @addAdTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Add Tags'**
  String get addAdTagsHint;

  /// No description provided for @addAdCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addAdCityLabel;

  /// No description provided for @addAdSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get addAdSelectCity;

  /// No description provided for @addAdAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get addAdAreaLabel;

  /// No description provided for @addAdSelectArea.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get addAdSelectArea;

  /// No description provided for @addAdFullAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'full Address'**
  String get addAdFullAddressLabel;

  /// No description provided for @addAdFullAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get addAdFullAddressHint;

  /// No description provided for @addAdLocationMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Location Map'**
  String get addAdLocationMapLabel;

  /// No description provided for @addAdUploadLocationMap.
  ///
  /// In en, this message translates to:
  /// **'Upload Location Map'**
  String get addAdUploadLocationMap;

  /// No description provided for @addAdLocationMapCaption.
  ///
  /// In en, this message translates to:
  /// **'Please upload location map'**
  String get addAdLocationMapCaption;

  /// No description provided for @addAdPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get addAdPhoneLabel;

  /// No description provided for @addAdWhatsappLabel.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp Number'**
  String get addAdWhatsappLabel;

  /// No description provided for @addAdInstagramLabel.
  ///
  /// In en, this message translates to:
  /// **'Instagram Link'**
  String get addAdInstagramLabel;

  /// No description provided for @addAdCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get addAdCurrencyLabel;

  /// No description provided for @addAdSelectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get addAdSelectCurrency;

  /// No description provided for @addAdServiceProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Service / Product'**
  String get addAdServiceProductLabel;

  /// No description provided for @addAdSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get addAdSelectType;

  /// No description provided for @addAdPaymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get addAdPaymentMethodLabel;

  /// No description provided for @addAdSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get addAdSelectPaymentMethod;

  /// No description provided for @addAdNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get addAdNextButton;

  /// No description provided for @addAdCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create AD'**
  String get addAdCreateButton;

  /// No description provided for @addAdReadySnackbar.
  ///
  /// In en, this message translates to:
  /// **'Your ad is ready! Publishing will be enabled in the next phase.'**
  String get addAdReadySnackbar;

  /// No description provided for @addAdCityDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get addAdCityDubai;

  /// No description provided for @addAdCityAbuDhabi.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi'**
  String get addAdCityAbuDhabi;

  /// No description provided for @addAdCitySharjah.
  ///
  /// In en, this message translates to:
  /// **'Sharjah'**
  String get addAdCitySharjah;

  /// No description provided for @addAdCityAjman.
  ///
  /// In en, this message translates to:
  /// **'Ajman'**
  String get addAdCityAjman;

  /// No description provided for @addAdCityRasAlKhaimah.
  ///
  /// In en, this message translates to:
  /// **'Ras Al Khaimah'**
  String get addAdCityRasAlKhaimah;

  /// No description provided for @addAdCityFujairah.
  ///
  /// In en, this message translates to:
  /// **'Fujairah'**
  String get addAdCityFujairah;

  /// No description provided for @addAdCityUmmAlQuwain.
  ///
  /// In en, this message translates to:
  /// **'Umm Al Quwain'**
  String get addAdCityUmmAlQuwain;

  /// No description provided for @addAdCityAlAin.
  ///
  /// In en, this message translates to:
  /// **'Al Ain'**
  String get addAdCityAlAin;

  /// No description provided for @commonSomethingWentWrongShort.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get commonSomethingWentWrongShort;

  /// No description provided for @commonLoginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get commonLoginRequiredTitle;

  /// No description provided for @commonGoToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get commonGoToLogin;

  /// No description provided for @chatWriteMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get chatWriteMessageHint;

  /// No description provided for @chatSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSendButton;

  /// No description provided for @chatSendingButton.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get chatSendingButton;

  /// No description provided for @chatNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessagesYet;

  /// No description provided for @chatListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep campaign conversations in one place.'**
  String get chatListSubtitle;

  /// No description provided for @chatLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading chats'**
  String get chatLoadingMessage;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your conversations will appear here.'**
  String get chatEmptyMessage;

  /// No description provided for @chatErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load chats'**
  String get chatErrorTitle;

  /// No description provided for @chatAuthRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to use Promoo chat.'**
  String get chatAuthRequiredMessage;

  /// No description provided for @chatConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get chatConversationTitle;

  /// No description provided for @chatRoomLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading messages'**
  String get chatRoomLoadingMessage;

  /// No description provided for @chatRoomEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation with a short message.'**
  String get chatRoomEmptyMessage;

  /// No description provided for @chatRoomAuthRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to open this conversation.'**
  String get chatRoomAuthRequiredMessage;

  /// No description provided for @chatRoomErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages'**
  String get chatRoomErrorTitle;

  /// No description provided for @chatMessageStatusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get chatMessageStatusSending;

  /// No description provided for @chatMessageStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get chatMessageStatusSent;

  /// No description provided for @chatMessageStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get chatMessageStatusDelivered;

  /// No description provided for @chatMessageStatusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get chatMessageStatusRead;

  /// No description provided for @chatMessageStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get chatMessageStatusFailed;

  /// No description provided for @chatMessageStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get chatMessageStatusUnknown;

  /// No description provided for @notificationDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete notification'**
  String get notificationDeleteTooltip;

  /// No description provided for @notificationsUnreadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No unread notifications.} =1{1 unread notification} other{{count} unread notifications}}'**
  String notificationsUnreadSubtitle(num count);

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications'**
  String get notificationsLoadingMessage;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Promoo updates and messages will appear here.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationsAuthRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications.'**
  String get notificationsAuthRequiredMessage;

  /// No description provided for @notificationsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications'**
  String get notificationsErrorTitle;

  /// No description provided for @notificationTypeFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get notificationTypeFollow;

  /// No description provided for @notificationTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get notificationTypeMessage;

  /// No description provided for @notificationTypeOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get notificationTypeOffer;

  /// No description provided for @notificationTypeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notificationTypeSystem;

  /// No description provided for @notificationTypePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get notificationTypePayment;

  /// No description provided for @notificationTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationTypeUnknown;
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
