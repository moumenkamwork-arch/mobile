class RouteNames {
  const RouteNames._();

  static const splash = 'splash';
  static const splashAlias = 'splashAlias';
  static const home = 'home';
  static const homeContentDetail = 'homeContentDetail';
  static const services = 'services';
  static const serviceDetail = 'serviceDetail';
  static const cup = 'cup';
  static const seats = 'seats';
  static const offers = 'offers';
  static const seatCheckoutPreview = 'seatCheckoutPreview';
  static const profile = 'profile';
  static const profileDetail = 'profileDetail';
  static const profileEdit = 'profileEdit';
  static const profileAddAd = 'profileAddAd';
  static const profileAddOffer = 'profileAddOffer';
  static const profileAddService = 'profileAddService';
  static const homeSeeAll = 'homeSeeAll';
  static const profileSaved = 'profileSaved';
  static const profilePackages = 'profilePackages';
  static const profileFollowing = 'profileFollowing';
  static const profileSupport = 'profileSupport';
  static const profileInfo = 'profileInfo';
  static const search = 'search';
  static const login = 'login';
  static const register = 'register';
  static const chats = 'chats';
  static const chatRoom = 'chatRoom';
  static const notifications = 'notifications';
}

class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const splashAlias = '/splash';
  static const home = '/home';
  static const homeContentDetail = '/home/items/:type/:id';
  static const services = '/services';
  static const serviceDetail = '/services/:id';
  static const cup = '/cup';
  static const seats = '/seats';
  static const offers = '/offers';
  static const seatCheckoutPreview = '/seats/checkout';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const profileAddAd = '/profile/add-ad';
  static const profileAddOffer = '/profile/add-offer';
  static const profileAddService = '/profile/add-service';
  static const homeSeeAllPath = '/home/see-all/:section';
  static const profileSaved = '/profile/saved';
  static const profilePackages = '/profile/packages';
  static const profileFollowing = '/profile/following';
  static const profileSupport = '/profile/support';
  static const profileInfoPath = '/profile/info/:topic';
  static const profileDetail = '/profiles/:id';

  static String profileInfo(String topic) => '/profile/info/$topic';
  static const search = '/search';
  static const login = '/login';
  static const register = '/register';
  static const chats = '/chats';
  static const chatRoomPath = '/chats/:roomId';
  static const notifications = '/notifications';

  static String profileById(String id) => '/profiles/$id';

  static String homeSeeAll(String section) => '/home/see-all/$section';

  static String homeItemDetail(String type, String id) {
    return '/home/items/${Uri.encodeComponent(type)}/${Uri.encodeComponent(id)}';
  }

  static String serviceById(String id) => '/services/$id';

  static String seatCheckout({
    required String seatId,
    required String title,
    required String tier,
    required String price,
  }) {
    final query = Uri(
      queryParameters: {
        'seatId': seatId,
        'title': title,
        'tier': tier,
        'price': price,
      },
    ).query;
    return '$seatCheckoutPreview?$query';
  }

  static String chatRoom(String roomId) => '/chats/$roomId';

  /// A `roomId` of `new` is a sentinel the chat room route recognizes to mean
  /// "no room yet — resolve one for `participant` in the background" (see
  /// [ChatRoomScreen.newChat]), so the Message button can navigate instantly
  /// instead of waiting on the `startChat` network round-trip first.
  static String chatWithParticipant(String participantId) =>
      '/chats/new?participant=$participantId';
}
