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
  String get tabOffers => 'Offers';

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
  String get menuFollowers => 'Followers';

  @override
  String get menuBlockedUsers => 'Blocked Users';

  @override
  String get menuMyListings => 'My Listings';

  @override
  String get reportAction => 'Report';

  @override
  String get reportSheetTitle => 'Report';

  @override
  String get reportSheetSubtitle => 'Why are you reporting this?';

  @override
  String get reportReasonSpam => 'Spam or misleading';

  @override
  String get reportReasonInappropriate => 'Inappropriate content';

  @override
  String get reportReasonHarassment => 'Harassment or bullying';

  @override
  String get reportReasonScam => 'Scam or fraud';

  @override
  String get reportReasonFalseInfo => 'False information';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportDetailsLabel => 'Details (optional)';

  @override
  String get reportDetailsHint => 'Add anything that helps us review this';

  @override
  String get reportSubmitButton => 'Submit report';

  @override
  String get reportSubmitting => 'Submitting…';

  @override
  String get reportSubmittedSnackbar => 'Thanks — your report was submitted';

  @override
  String get reportFailedSnackbar => 'Couldn\'t submit the report — try again';

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
  String get savedButtonSaveTooltip => 'Save';

  @override
  String get savedButtonUnsaveTooltip => 'Unsave';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get profileBlockAction => 'Block user';

  @override
  String get profileUnblockAction => 'Unblock user';

  @override
  String get profileBlockConfirmTitle => 'Block this user?';

  @override
  String get profileBlockConfirmMessage =>
      'They won\'t be able to message you, and you won\'t see each other\'s content.';

  @override
  String get profileBlockConfirmButton => 'Block';

  @override
  String get profileUnblockConfirmTitle => 'Unblock this user?';

  @override
  String get profileUnblockConfirmMessage =>
      'They will be able to message you again.';

  @override
  String get profileUnblockConfirmButton => 'Unblock';

  @override
  String get profileBlockedSnackbar => 'User blocked';

  @override
  String get profileUnblockedSnackbar => 'User unblocked';

  @override
  String get blockedUsersEmptyTitle => 'No blocked users';

  @override
  String get blockedUsersEmptyMessage => 'Accounts you block will appear here.';

  @override
  String get myListingsEmptyTitle => 'Nothing published yet';

  @override
  String get myListingsEmptyMessage =>
      'Offers, services, and ads you publish will appear here.';

  @override
  String get myListingsOffersSection => 'Offers';

  @override
  String get myListingsServicesSection => 'Services';

  @override
  String get myListingsAdsSection => 'Ads';

  @override
  String get myListingsEditTooltip => 'Edit';

  @override
  String get myListingsDeleteTooltip => 'Delete';

  @override
  String get myListingsDeleteConfirmTitle => 'Delete this listing?';

  @override
  String get myListingsDeleteConfirmMessage => 'This can\'t be undone.';

  @override
  String get myListingsDeleteConfirmButton => 'Delete';

  @override
  String get myListingsDeleteFailed => 'Couldn\'t delete — try again.';

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
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmTitle => 'Delete your account permanently?';

  @override
  String get deleteAccountConfirmMessage =>
      'This permanently deletes your profile, listings, chats, and everything else tied to your account. This cannot be undone.';

  @override
  String get deleteAccountConfirmButton => 'Delete My Account';

  @override
  String get deleteAccountFailed =>
      'Couldn\'t delete your account — try again.';

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
  String get authSessionExpiredNotice =>
      'Your session expired. Please sign in again.';

  @override
  String get authErrorInvalidCredentials => 'Wrong email or password.';

  @override
  String get authErrorNoConnection =>
      'No internet connection. Check your network and try again.';

  @override
  String get authErrorGeneric => 'Something went wrong. Please try again.';

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
  String get homeStoryYourStory => 'Your story';

  @override
  String get homeStoryUploading => 'Uploading story…';

  @override
  String get homeStoryAdded => 'Story added.';

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
  String get homeStoryViewerMoreTooltip => 'More options';

  @override
  String get homeStoryViewerDeleteAction => 'Delete story';

  @override
  String get homeStoryViewerDeleteConfirmTitle => 'Delete this story?';

  @override
  String get homeStoryViewerDeleteConfirmMessage => 'This can\'t be undone.';

  @override
  String get homeStoryViewerDeleteConfirmButton => 'Delete';

  @override
  String get homeStoryViewerCancelButton => 'Cancel';

  @override
  String get homeStoryViewerDeleted => 'Story deleted.';

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
  String get seatsOnlyInfluencersCanBook =>
      'This seat is available for influencers to book.';

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

  @override
  String get leaderboardLoadingMessage => 'Loading leaderboard';

  @override
  String get leaderboardRefreshErrorFallback =>
      'Could not refresh leaderboard.';

  @override
  String get leaderboardErrorTitle => 'Could not load leaderboard';

  @override
  String get leaderboardScreenTitle => 'Cup';

  @override
  String get leaderboardScreenSubtitle =>
      'The Promoo leaderboard ranked by follower reach.';

  @override
  String get leaderboardEmptyTitle => 'No leaderboard yet';

  @override
  String get leaderboardEmptyMessage =>
      'Ranked profiles will appear here when they are available.';

  @override
  String get leaderboardPodiumTitle => 'Top of the Cup';

  @override
  String get leaderboardPodiumSubtitle => 'Followers-based Promoo standings';

  @override
  String leaderboardChampionLine(String followers) {
    return 'Champion / $followers';
  }

  @override
  String get leaderboardRankingTitle => 'Ranking';

  @override
  String get leaderboardRankingSubtitle =>
      'Active companies, influencers, and service providers';

  @override
  String leaderboardFollowersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '1 follower',
      zero: 'No followers',
    );
    return '$_temp0';
  }

  @override
  String leaderboardFollowersCompact(String compact) {
    return '$compact followers';
  }

  @override
  String get leaderboardAccountTypeFallback => 'Promoo profile';

  @override
  String get commonSelectCategory => 'Select category';

  @override
  String get profileLoadingMessage => 'Loading profile';

  @override
  String get profileEmptyTitle => 'Profile not found';

  @override
  String get profileEmptyMessage =>
      'This profile is unavailable or no longer exists.';

  @override
  String get profileRefreshErrorFallback => 'Could not refresh profile.';

  @override
  String get profileErrorTitle => 'Could not load profile';

  @override
  String get profileDetailScreenTitle => 'Profile details';

  @override
  String get profileActionFollow => 'Follow';

  @override
  String get profileActionFollowing => 'Following';

  @override
  String get profileActionMessage => 'Message';

  @override
  String get profileActionEditProfile => 'Edit profile';

  @override
  String get profileFeaturedBadge => 'Featured';

  @override
  String get profileAccountTypeUser => 'User';

  @override
  String get profileStatsFollowers => 'Followers';

  @override
  String get profileStatsLikes => 'Likes';

  @override
  String get profileStatsPosts => 'Posts';

  @override
  String get profileStatsViews => 'Views';

  @override
  String get profilePackagesTitle => 'Packages';

  @override
  String get profilePackagesSubtitle =>
      'Profile services ready for client discovery';

  @override
  String get profilePackagesEmptyTitle => 'No packages yet';

  @override
  String get profilePackagesEmptyMessage =>
      'Profile packages will appear here when available.';

  @override
  String get profilePackageContactOnly => 'Contact only';

  @override
  String get profileMediaTitle => 'Media';

  @override
  String get profileMediaSubtitle =>
      'Recent profile posts and campaign visuals';

  @override
  String get profileMediaEmptyTitle => 'No media yet';

  @override
  String get profileMediaEmptyMessage =>
      'Profile media will appear here when it is available.';

  @override
  String profileMediaItemSemantic(int index) {
    return 'Profile media item $index';
  }

  @override
  String get profileMediaCloseTooltip => 'Close media';

  @override
  String get profileMediaCommentsLabel => 'Comments';

  @override
  String get profileMediaShareLabel => 'Share';

  @override
  String get profileAboutTitle => 'About';

  @override
  String get profileAboutFallback => 'Profile details will appear here soon.';

  @override
  String get profileEditScreenTitle => 'Edit Profile';

  @override
  String get profileEditUnavailableTitle => 'Profile unavailable';

  @override
  String get profileEditUnavailableMessage =>
      'Could not load your profile right now.';

  @override
  String get profileEditChangePhoto => 'Change profile photo';

  @override
  String get profileEditChangePhotoComingSoon =>
      'Changing the profile photo arrives with uploads in the next phase.';

  @override
  String get profileEditFieldName => 'Name';

  @override
  String get profileEditFieldBio => 'Subtitle / Bio';

  @override
  String get profileEditFieldLocation => 'Location';

  @override
  String get profileEditFieldCategory => 'Category';

  @override
  String get profileEditCategoryComingSoon =>
      'Category selection will be enabled in the next phase.';

  @override
  String get profileEditSaveButton => 'Save';

  @override
  String get profileEditSaving => 'Saving...';

  @override
  String get profileEditSaveSuccess => 'Profile updated.';

  @override
  String get profileEditUploadingPhoto => 'Uploading photo…';

  @override
  String get profileEditPhotoUpdated => 'Profile photo updated.';

  @override
  String get profileEditTakePhoto => 'Take photo';

  @override
  String get profileEditChooseFromGallery => 'Choose from gallery';

  @override
  String get profileFollowingEmptyTitle => 'No follows yet';

  @override
  String get profileFollowingEmptyMessage =>
      'Profiles you follow will appear here.';

  @override
  String get profileFollowersEmptyTitle => 'No followers yet';

  @override
  String get profileFollowersEmptyMessage =>
      'People who follow you will appear here.';

  @override
  String get profileMyPackagesBasicTitle => 'Basic Package';

  @override
  String get profileMyPackagesStandardTitle => 'Standard Package';

  @override
  String get profileMyPackagesPremiumTitle => 'Premium Package';

  @override
  String get profileMyPackagesBasicPosts => 'Includes 3 posts';

  @override
  String get profileMyPackagesStandardPosts => 'Includes 6 posts';

  @override
  String get profileMyPackagesPremiumPosts => 'Includes 12 posts';

  @override
  String get profileMyPackagesBullet1 =>
      'Professionally designed social media posts';

  @override
  String get profileMyPackagesBullet2 =>
      'High-quality content tailored to your brand';

  @override
  String get profileMyPackagesBullet3 =>
      'Guaranteed fast delivery within 24 hours';

  @override
  String get profileMyPackagesGuaranteeLabel => 'Guarantee:';

  @override
  String get profileMyPackagesGuaranteeBullet1 =>
      'Trust that your content will reach more than 1,000 people.';

  @override
  String get profileMyPackagesGuaranteeBullet2 =>
      'Your engagement and visibility are our top priority.';

  @override
  String get profileMyPackagesTapToView =>
      'Tap to view details and proceed to secure checkout.';

  @override
  String get profileMyPackagesCheckoutComingSoon =>
      'Package checkout will be available in the next phase.';

  @override
  String get profileSavedEmptyTitle => 'Nothing saved yet';

  @override
  String get profileSavedEmptyMessage =>
      'Bookmark offers and services to find them here.';

  @override
  String get profileSavedRemoveTooltip => 'Remove from saved';

  @override
  String get profileSupportHeroTitle => 'We are here 24/7';

  @override
  String get profileSupportHeroBody =>
      'Questions about offers, seats, or your account? Reach the Promoo team any time.';

  @override
  String get profileSupportChatLabel => 'Chat with support';

  @override
  String get profileSupportMessageTitle => 'Send us a message';

  @override
  String get profileSupportMessageHint => 'Describe your issue or question';

  @override
  String get profileSupportSendButton => 'Send';

  @override
  String get profileSupportComingSoon =>
      'Support messaging will be connected in the next phase.';

  @override
  String get staticInfoAboutBody =>
      'Promoo is a premium marketplace connecting companies, influencers, and service providers across the UAE.\n\nDiscover offers, book influencer seats, promote your brand, and grow your reach — all in one place, in AED.';

  @override
  String get staticInfoTermsTitle => 'Terms And Condition';

  @override
  String get staticInfoTermsBody =>
      'By using Promoo you agree to use the platform fairly and lawfully.\n\n• Content you publish must be accurate and owned by you.\n• Paid placements (seats, featured offers) follow the posted pricing at the time of purchase.\n• Accounts that violate our community standards may be suspended.\n\nThe full legal terms will be published here before the public store release.';

  @override
  String get staticInfoPrivacyBody =>
      'Your privacy matters to Promoo.\n\n• We only collect the data needed to run your account and show relevant content.\n• Your data is never sold to third parties.\n• You can request account deletion at any time.\n\nThe full privacy policy will be published here before the public store release.';

  @override
  String get addCommonTitleLabel => 'Title';

  @override
  String get addCommonDescriptionLabel => 'Description';

  @override
  String get addCommonCategoryLabel => 'Category';

  @override
  String get addCommonTagsLabel => 'Tags';

  @override
  String get addCommonTagsHint => 'Comma separated tags';

  @override
  String get addCommonCancelButton => 'Cancel';

  @override
  String get addCommonUploadCaption => 'JPG, PNG up to 2MB';

  @override
  String get addCommonMediaUploadComingSoon =>
      'Media upload will be enabled in the next phase.';

  @override
  String get addCommonCategoryBeautyWellness => 'Beauty & Wellness';

  @override
  String get addCommonCategoryRestaurantsCafes => 'Restaurants & Cafes';

  @override
  String get addCommonCategoryEventsPhotography => 'Events & Photography';

  @override
  String get addCommonCategoryDigitalMarketing => 'Digital Marketing';

  @override
  String get addCommonUploading => 'Uploading…';

  @override
  String get addCommonReplaceImage => 'Replace';

  @override
  String get addCommonRemoveImage => 'Remove';

  @override
  String get addCommonCategoriesUnavailable =>
      'Couldn\'t load categories. Try again.';

  @override
  String get addCommonPublishing => 'Publishing…';

  @override
  String get addCommonSaving => 'Saving…';

  @override
  String get addCommonSaveButton => 'Save Changes';

  @override
  String get addOfferEditTitle => 'Edit Offer';

  @override
  String get addServiceEditTitle => 'Edit Service';

  @override
  String get addAdEditTitle => 'Edit Ad';

  @override
  String get addOfferUpdated => 'Offer updated';

  @override
  String get addServiceUpdated => 'Service updated';

  @override
  String get addAdUpdated => 'Ad updated';

  @override
  String get addCommonValidationTitle => 'Please complete the required fields.';

  @override
  String addCommonSubmitFailed(Object error) {
    return 'Couldn\'t publish. $error';
  }

  @override
  String get addOfferPublished => 'Offer published.';

  @override
  String get addServicePublished => 'Service published.';

  @override
  String get addAdPublished => 'Ad submitted.';

  @override
  String get addOfferCreateButton => 'Create Offer';

  @override
  String get addOfferDetailsTitle => 'Offer Details';

  @override
  String get addOfferTitleHint => 'Offer title';

  @override
  String get addOfferDescriptionHint =>
      'Describe your offer (at least 10 characters)';

  @override
  String get addOfferPricingTitle => 'Pricing';

  @override
  String get addOfferOriginalPriceLabel => 'Original Price';

  @override
  String get addOfferOfferPriceLabel => 'Offer Price';

  @override
  String get addOfferDiscountLabel => 'Discount %';

  @override
  String get addOfferDiscountOptionalHint => 'Optional';

  @override
  String get addOfferDiscountNote =>
      'Leave empty to auto-calculate from the prices above.';

  @override
  String get addOfferScheduleTitle => 'Schedule';

  @override
  String get addOfferStartDateLabel => 'Start Date';

  @override
  String get addOfferEndDateLabel => 'End Date';

  @override
  String get addOfferSelectDate => 'Select date';

  @override
  String get addOfferMainImageLabel => 'Main Image';

  @override
  String get addOfferAdditionalImageLabel => 'Additional Image';

  @override
  String get addOfferUploadMainImage => 'Upload main image';

  @override
  String get addOfferUploadAdditionalImages => 'Upload additional images';

  @override
  String get addOfferReadySnackbar =>
      'Your offer is ready! Publishing will be enabled in the next phase.';

  @override
  String get addServiceCreateButton => 'Create Service';

  @override
  String get addServiceDetailsTitle => 'Service Details';

  @override
  String get addServiceTitleHint => 'Service title';

  @override
  String get addServiceDescriptionHint =>
      'Describe your service (at least 10 characters)';

  @override
  String get addServicePricingTitle => 'Pricing & Delivery';

  @override
  String get addServiceDeliveryLabel => 'Delivery';

  @override
  String get addServiceDeliveryHint => 'e.g. 3';

  @override
  String get addServiceDaysSuffix => 'days';

  @override
  String get addServiceImagesLabel => 'Images';

  @override
  String get addServiceUploadImages => 'Upload service images';

  @override
  String get addServiceReadySnackbar =>
      'Your service is ready! Publishing will be enabled in the next phase.';

  @override
  String get addAdScreenTitle => 'Add New AD';

  @override
  String get addAdStepBasic => 'Basic Ad Details';

  @override
  String get addAdStepLocation => 'Location Information';

  @override
  String get addAdStepContact => 'Contact Information';

  @override
  String get addAdStepPricing => 'Pricing Information';

  @override
  String get addAdTitleLabel => 'Ad Title';

  @override
  String get addAdUploadImagesLabel => 'Upload additional images';

  @override
  String get addAdPostDateLabel => 'Post Date';

  @override
  String get addAdSelectDateCap => 'Select Date';

  @override
  String get addAdTagsHint => 'Add Tags';

  @override
  String get addAdCityLabel => 'City';

  @override
  String get addAdSelectCity => 'Select City';

  @override
  String get addAdAreaLabel => 'Area';

  @override
  String get addAdSelectArea => 'Select Area';

  @override
  String get addAdFullAddressLabel => 'full Address';

  @override
  String get addAdFullAddressHint => 'Full Address';

  @override
  String get addAdLocationMapLabel => 'Location Map';

  @override
  String get addAdUploadLocationMap => 'Upload Location Map';

  @override
  String get addAdLocationMapCaption => 'Please upload location map';

  @override
  String get addAdPhoneLabel => 'Phone Number';

  @override
  String get addAdWhatsappLabel => 'Whatsapp Number';

  @override
  String get addAdInstagramLabel => 'Instagram Link';

  @override
  String get addAdCurrencyLabel => 'Currency';

  @override
  String get addAdSelectCurrency => 'Select Currency';

  @override
  String get addAdServiceProductLabel => 'Service / Product';

  @override
  String get addAdSelectType => 'Select Type';

  @override
  String get addAdPaymentMethodLabel => 'Payment Method';

  @override
  String get addAdSelectPaymentMethod => 'Select Payment Method';

  @override
  String get addAdNextButton => 'Next';

  @override
  String get addAdCreateButton => 'Create AD';

  @override
  String get addAdReadySnackbar =>
      'Your ad is ready! Publishing will be enabled in the next phase.';

  @override
  String get addAdCityDubai => 'Dubai';

  @override
  String get addAdCityAbuDhabi => 'Abu Dhabi';

  @override
  String get addAdCitySharjah => 'Sharjah';

  @override
  String get addAdCityAjman => 'Ajman';

  @override
  String get addAdCityRasAlKhaimah => 'Ras Al Khaimah';

  @override
  String get addAdCityFujairah => 'Fujairah';

  @override
  String get addAdCityUmmAlQuwain => 'Umm Al Quwain';

  @override
  String get addAdCityAlAin => 'Al Ain';

  @override
  String get commonSomethingWentWrongShort => 'Something went wrong.';

  @override
  String get commonLoginRequiredTitle => 'Login required';

  @override
  String get commonGoToLogin => 'Go to login';

  @override
  String get chatWriteMessageHint => 'Write a message';

  @override
  String get chatSendButton => 'Send';

  @override
  String get chatSendingButton => 'Sending';

  @override
  String get chatNoMessagesYet => 'No messages yet';

  @override
  String get chatListSubtitle => 'Keep campaign conversations in one place.';

  @override
  String get chatLoadingMessage => 'Loading chats';

  @override
  String get chatEmptyTitle => 'No chats yet';

  @override
  String get chatEmptyMessage => 'Your conversations will appear here.';

  @override
  String get chatErrorTitle => 'Could not load chats';

  @override
  String get chatAuthRequiredMessage => 'Sign in to use Promoo chat.';

  @override
  String get chatConversationTitle => 'Conversation';

  @override
  String get chatRoomLoadingMessage => 'Loading messages';

  @override
  String get chatRoomEmptyMessage =>
      'Start the conversation with a short message.';

  @override
  String get chatRoomAuthRequiredMessage =>
      'Sign in to open this conversation.';

  @override
  String get chatRoomErrorTitle => 'Could not load messages';

  @override
  String get chatMessageStatusSending => 'Sending';

  @override
  String get chatMessageStatusSent => 'Sent';

  @override
  String get chatMessageStatusDelivered => 'Delivered';

  @override
  String get chatMessageStatusRead => 'Read';

  @override
  String get chatMessageStatusFailed => 'Failed';

  @override
  String get chatMessageStatusUnknown => 'Unknown';

  @override
  String get notificationDeleteTooltip => 'Delete notification';

  @override
  String notificationsUnreadSubtitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread notifications',
      one: '1 unread notification',
      zero: 'No unread notifications.',
    );
    return '$_temp0';
  }

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsLoadingMessage => 'Loading notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyMessage =>
      'Promoo updates and messages will appear here.';

  @override
  String get notificationsAuthRequiredMessage =>
      'Sign in to view notifications.';

  @override
  String get notificationsErrorTitle => 'Could not load notifications';

  @override
  String get notificationTypeFollow => 'Follow';

  @override
  String get notificationTypeMessage => 'Message';

  @override
  String get notificationTypeOffer => 'Offer';

  @override
  String get notificationTypeSystem => 'System';

  @override
  String get notificationTypePayment => 'Payment';

  @override
  String get notificationTypeUnknown => 'Notification';
}
