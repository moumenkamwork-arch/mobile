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
  static const seatCheckoutPreview = 'seatCheckoutPreview';
  static const profile = 'profile';
  static const profileDetail = 'profileDetail';
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
  static const seatCheckoutPreview = '/seats/checkout';
  static const profile = '/profile';
  static const profileDetail = '/profiles/:id';
  static const search = '/search';
  static const login = '/login';
  static const register = '/register';
  static const chats = '/chats';
  static const chatRoomPath = '/chats/:roomId';
  static const notifications = '/notifications';

  static String profileById(String id) => '/profiles/$id';

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
}
