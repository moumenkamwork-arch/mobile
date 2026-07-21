class ApiEndpoints {
  const ApiEndpoints._();

  static const home = '/home';
  static const stories = '/stories';
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
  static const saved = '/saved';
  static const subscriptionPlans = '/subscriptions/plans';
  static const subscriptions = '/subscriptions';
  static const chats = '/chats';
  static const notifications = '/notifications';
  static const markAllNotificationsRead = '/notifications/read-all';
  static const notificationToken = '/notifications/token';

  // Upload — multipart. The image route rejects non-image mimetypes; the file
  // route rejects images/videos. All require Bearer auth.
  static const uploadImage = '/upload/image';
  static const uploadVideo = '/upload/video';
  static const uploadFile = '/upload/file';

  // Avatar/cover are NOT part of `PUT /profiles/me` (updateProfileSchema has no
  // avatar_url/cover_url) — they have their own persist endpoints, called with
  // the URL returned by the upload step above.
  static const myAvatar = '/profiles/me/avatar';
  static const myCover = '/profiles/me/cover';

  static String serviceById(String id) => '/services/$id';

  static String offerById(String id) => '/offers/$id';

  static String bookSeat(String id) => '/seats/$id/book';

  static String profileByIdOrUsername(String idOrUsername) {
    return '/profiles/$idOrUsername';
  }

  // Follow (POST to follow, DELETE to unfollow, both on the same path).
  static String savedById(String savedId) => '/saved/$savedId';

  static String follow(String profileId) => '/follows/$profileId';

  static String followStatus(String profileId) => '/follows/$profileId/status';

  static String followingList(String profileId) => '/follows/following/$profileId';

  static String followersList(String profileId) => '/follows/followers/$profileId';

  static String chatMessages(String roomId) => '/chats/$roomId/messages';

  static String markChatRead(String roomId) => '/chats/$roomId/read';

  static String markNotificationRead(String id) => '/notifications/$id/read';

  static String notificationById(String id) => '/notifications/$id';

  static String uploadById(String fileId) => '/upload/$fileId';
}
