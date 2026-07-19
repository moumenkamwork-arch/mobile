/// A compact profile row for the Following / Followers lists.
class FollowUser {
  const FollowUser({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
    this.accountType,
  });

  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;

  /// Raw backend value (company / influencer / service_provider / user).
  final String? accountType;
}
