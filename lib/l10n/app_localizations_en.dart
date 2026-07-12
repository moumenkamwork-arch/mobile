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
  String get commonLoading => 'Loading';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String commonComingSoon(String feature) {
    return '$feature coming soon';
  }

  @override
  String get commonSeeAll => 'See All';

  @override
  String get commonSomethingWentWrong => 'Something went wrong. Try again.';

  @override
  String get commonPrice => 'Price';

  @override
  String get commonContactForPricing => 'Contact for pricing';

  @override
  String get commonDescription => 'Description';

  @override
  String get commonProvider => 'Provider';

  @override
  String get commonDetails => 'Details';

  @override
  String get commonOpenChats => 'Open chats';

  @override
  String get commonViewProviderProfile => 'View provider profile';

  @override
  String get commonContactFlowComingSoon =>
      'Contact flow coming soon. You can open chats or view the provider profile.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabInfluencer => 'Influencer';

  @override
  String get tabPromoo => 'Promoo';

  @override
  String get tabServices => 'Services';

  @override
  String get tabProfile => 'Profile';

  @override
  String tabSemanticLabel(String label) {
    return '$label tab';
  }

  @override
  String get snackbarPressBackAgainToExit => 'Press back again to exit';

  @override
  String get headerSwitchToLightMode => 'Switch to light mode';

  @override
  String get headerSwitchToDarkMode => 'Switch to dark mode';

  @override
  String get headerChats => 'Chats';

  @override
  String get headerNotifications => 'Notifications';

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

  @override
  String get authFieldEmail => 'Email';

  @override
  String get authFieldPassword => 'Password';

  @override
  String get authFieldFullName => 'Full name';

  @override
  String get authFieldAccountType => 'Account type';

  @override
  String get authPasswordShow => 'Show password';

  @override
  String get authPasswordHide => 'Hide password';

  @override
  String get authLogin => 'Login';

  @override
  String get authLoggingIn => 'Signing in...';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authCreatingAccount => 'Creating account...';

  @override
  String get authAlreadyHaveAccount => 'Already have an account';

  @override
  String get authContinueAsGuest => 'Continue as Guest';

  @override
  String get authForgetPassword => 'forget password?';

  @override
  String get authSignedInTitle => 'Signed in';

  @override
  String get authContinue => 'Continue';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authSigningOut => 'Signing out...';

  @override
  String get authSocialLoginCaption => 'Log in with account';

  @override
  String get authSocialSignupCaption => 'Sign up with account';

  @override
  String get authAccountTypeUser => 'User';

  @override
  String get authAccountTypeCompany => 'Company';

  @override
  String get authAccountTypeInfluencer => 'Influencer';

  @override
  String get authAccountTypeServiceProvider => 'Service provider';

  @override
  String get authValidationEmailRequired => 'Email is required.';

  @override
  String get authValidationEmailInvalid => 'Enter a valid email address.';

  @override
  String get authValidationPasswordRequired => 'Password is required.';

  @override
  String get authValidationFullNameTooShort =>
      'Full name must be at least 2 characters.';

  @override
  String get authValidationPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get authRegistrationPendingVerification =>
      'Registration created. Please verify your account before signing in.';

  @override
  String get homeLoadingMessage => 'Loading Promoo home';

  @override
  String get homeEmptyTitle => 'Nothing to show yet';

  @override
  String get homeEmptyMessage =>
      'Promoo home content will appear here when it is available.';

  @override
  String get homeErrorTitle => 'Could not load home';

  @override
  String get homeRefreshErrorFallback => 'Could not refresh home content.';

  @override
  String get homeSectionStoriesTitle => 'Stories';

  @override
  String get homeSectionStoriesSubtitle => 'Fresh updates from Promoo partners';

  @override
  String get homeSectionTopOffersTitle => 'Top Offers';

  @override
  String get homeSectionTopOffersSubtitle =>
      'Featured offers from Promoo partners';

  @override
  String get homeSectionForYouTitle => 'For You';

  @override
  String get homeSectionForYouSubtitle => 'Selected offers for today';

  @override
  String get homeSectionServicesSubtitle =>
      'Premium campaign services ready for contact';

  @override
  String get homeSectionPromooOfDayTitle => 'Promoo of the Day';

  @override
  String get homeSectionPromooOfDaySubtitle => 'Today\'s featured Promoo pick';

  @override
  String get homeTopOfferBadge => 'Top offer';

  @override
  String get homeServiceBadge => 'Service';

  @override
  String get homeServiceFallbackSubtitle => 'Provider service';

  @override
  String get homeSeeAllTitleBrowse => 'Browse';

  @override
  String get homeSeeAllErrorTitle => 'Could not load';

  @override
  String get homeSeeAllEmptyTitle => 'Nothing here yet';

  @override
  String get homeSeeAllEmptyMessage =>
      'Items for this section will appear here soon.';

  @override
  String get homeStoryViewerCloseTooltip => 'Close story';

  @override
  String get homeDetailLoadingMessage => 'Loading details';

  @override
  String get homeDetailErrorTitle => 'Could not load details';

  @override
  String get homeDetailTypeOffer => 'Offer';

  @override
  String get homeDetailTypeAd => 'Promotion';

  @override
  String get homeDetailTypeUnknown => 'Promoo item';

  @override
  String homeDetailLocationComingSoon(String location) {
    return 'Location details coming soon. The current location is $location.';
  }

  @override
  String get homeDetailAvailabilityLabel => 'Availability';

  @override
  String get homeDetailAvailabilityFallback => 'Confirm with provider';

  @override
  String get homeDetailNextStepTitle => 'Next step';

  @override
  String get homeDetailNextStepSubtitle =>
      'Connect with the provider before taking action';

  @override
  String get homeDetailContact => 'Contact';

  @override
  String get homeDetailLocation => 'Location';

  @override
  String get servicesLoadingMessage => 'Loading services';

  @override
  String get servicesRefreshErrorFallback => 'Could not refresh services.';

  @override
  String get servicesErrorTitle => 'Could not load services';

  @override
  String get servicesSearchResultsTitle => 'Search results';

  @override
  String servicesResultsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '1 service',
      zero: 'No services',
    );
    return '$_temp0';
  }

  @override
  String get servicesBackToCategoriesTooltip => 'Back to categories';

  @override
  String get servicesAllCategory => 'All services';

  @override
  String servicesCategorySemanticLabel(String label) {
    return '$label category';
  }

  @override
  String get servicesSearchHint => 'Search services';

  @override
  String get servicesClearSearchTooltip => 'Clear search';

  @override
  String get servicesEmptyFilteredTitle => 'No service found.';

  @override
  String get servicesEmptyFilteredMessage =>
      'We couldn\'t find this service yet.';

  @override
  String get servicesEmptyDefaultTitle => 'No services yet';

  @override
  String get servicesEmptyDefaultMessage =>
      'Search or choose a category to discover services.';

  @override
  String servicesDeliveryDaysLabel(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days delivery',
      one: '1 day delivery',
    );
    return '$_temp0';
  }

  @override
  String get serviceDetailLoadingMessage => 'Loading service details';

  @override
  String get serviceDetailErrorTitle => 'Could not load service';

  @override
  String get serviceDetailScreenTitle => 'Service details';

  @override
  String get serviceDetailTimelineLabel => 'Timeline';

  @override
  String get serviceDetailDiscussWithProvider => 'Discuss with provider';

  @override
  String serviceDetailDaysCount(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get serviceDetailTagsSubtitle =>
      'Useful signals before contacting the provider';

  @override
  String get serviceDetailProviderPending =>
      'Provider details will appear when available.';

  @override
  String get serviceDetailProviderFallbackSemantic => 'Service provider';

  @override
  String get serviceDetailContactSubtitle =>
      'Connect with the provider before taking the next step';

  @override
  String get serviceDetailContactProvider => 'Contact provider';

  @override
  String get seatsLoadingMessage => 'Loading seats';

  @override
  String get seatsSearchHint => 'Search';

  @override
  String get seatsStatsInfluencers => 'Influencers';

  @override
  String get seatsStatsAvailable => 'Available seats';

  @override
  String get seatsErrorTitle => 'Seats unavailable';

  @override
  String get seatsErrorFallback => 'Could not load seats right now.';

  @override
  String get seatsEmptyTitle => 'No seats yet';

  @override
  String get seatsEmptyMessage => 'No seats available yet.';

  @override
  String get seatsMoreSeatsOpeningSoon => 'More seats are opening soon.';

  @override
  String get seatsBookSeatLabel => 'Book Seat';

  @override
  String get seatsFollow => 'Follow';

  @override
  String get seatsFollowComingSoon => 'Follow is coming soon.';

  @override
  String get seatsViewProfile => 'View profile';

  @override
  String get seatsBookNow => 'Book Now';

  @override
  String seatsLegendLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'gold': 'Gold Seats',
      'silver': 'Silver Seats',
      'bronze': 'Bronze Seats',
      'other': 'Seats',
    });
    return '$_temp0';
  }

  @override
  String seatsSingularLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'gold': 'Gold Seat',
      'silver': 'Silver Seat',
      'bronze': 'Bronze Seat',
      'other': 'Seat',
    });
    return '$_temp0';
  }

  @override
  String seatsVisibilityPlacementLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'gold': 'Gold visibility placement',
      'silver': 'Silver visibility placement',
      'bronze': 'Bronze visibility placement',
      'other': 'Seat visibility placement',
    });
    return '$_temp0';
  }

  @override
  String get seatsTierDescriptionGold =>
      'Gold seats provide a premium viewing experience with the highest level of comfort and visibility. These seats are positioned in the most strategic locations to ensure perfect coverage and maximum exposure. Influencers seated here enjoy top-tier placement for enhanced visibility during events. Designed for VIP guests, they offer exclusive benefits such as faster access and priority interaction. Gold seating represents luxury, exclusivity, and guaranteed premium engagement.';

  @override
  String get seatsTierDescriptionSilver =>
      'Silver seats offer excellent value with strong visibility and great overall positioning within the layout. These seats are ideal for influencers looking for balanced exposure without the premium cost. Silver seating provides comfort and a clear line of sight while still being close to the core areas. Perfect for mid-range promotions and events requiring consistent, reliable engagement. A smart choice for those who want quality placement at an affordable rate.';

  @override
  String get seatsTierDescriptionBronze =>
      'Bronze seats offer an accessible entry point while still maintaining good overall visibility. Influencers in this category benefit from cost-effective placement suitable for general campaigns. These seats provide steady engagement and broad audience reach without premium pricing. Ideal for newcomers or those exploring event participation for the first time. A practical and budget-friendly choice that still ensures a good presence within the venue.';

  @override
  String get seatsCheckoutBackTooltip => 'Back to seats';

  @override
  String get seatsCheckoutTitle => 'Checkout preview';

  @override
  String get seatsCheckoutSubtitle =>
      'Confirm the placement before payment is enabled.';

  @override
  String get seatsCheckoutFallbackTitle => 'Influencer Seat';

  @override
  String get seatsCheckoutFallbackTier => 'Visibility seat';

  @override
  String get seatsCheckoutFallbackPrice => 'Price shown after seat selection';

  @override
  String get seatsCheckoutSeatIdLabel => 'Seat ID';

  @override
  String get seatsCheckoutPlacementLabel => 'Placement';

  @override
  String get seatsCheckoutAmountLabel => 'Amount';

  @override
  String get seatsCheckoutPaymentDetailsTitle => 'Payment details';

  @override
  String get seatsCheckoutCardholderName => 'Cardholder name';

  @override
  String get seatsCheckoutNameOnCard => 'Name on card';

  @override
  String get seatsCheckoutCardNumber => 'Card number';

  @override
  String get seatsCheckoutExpiry => 'Expiry';

  @override
  String get seatsCheckoutCvv => 'CVV';

  @override
  String get seatsCheckoutPreviewPayment => 'Preview payment';

  @override
  String get seatsCheckoutPreviewOnlyNotice =>
      'Checkout preview only. No payment was processed.';

  @override
  String get seatsCheckoutNextPhaseNotice =>
      'Booking and payment open in the next phase.';
}
