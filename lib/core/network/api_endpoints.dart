class ApiEndpoints {
  const ApiEndpoints._();

  static const home = '/home';
  static const offers = '/offers';
  static const activeAds = '/ads/active';
  static const loginEmail = '/auth/login/email';
  static const registerEmail = '/auth/register/email';
  static const refreshToken = '/auth/refresh';
  static const logout = '/auth/logout';
  static const categories = '/categories';
  static const services = '/services';
  static const seats = '/seats';
  static const mySeats = '/seats/me';
  static const leaderboard = '/leaderboard';
  static const profiles = '/profiles';
  static const myProfile = '/profiles/me';
  static const search = '/search';
  static const subscriptionPlans = '/subscriptions/plans';
  static const subscriptions = '/subscriptions';
  static const chats = '/chats';
  static const notifications = '/notifications';
  static const markAllNotificationsRead = '/notifications/read-all';
  static const notificationToken = '/notifications/token';

  static String serviceById(String id) => '/services/$id';

  static String offerById(String id) => '/offers/$id';

  static String bookSeat(String id) => '/seats/$id/book';

  static String profileByIdOrUsername(String idOrUsername) {
    return '/profiles/$idOrUsername';
  }

  static String chatMessages(String roomId) => '/chats/$roomId/messages';

  static String markChatRead(String roomId) => '/chats/$roomId/read';

  static String markNotificationRead(String id) => '/notifications/$id/read';

  static String notificationById(String id) => '/notifications/$id';
}
