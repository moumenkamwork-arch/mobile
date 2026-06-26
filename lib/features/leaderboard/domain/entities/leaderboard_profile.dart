enum LeaderboardType { all, company, influencer, serviceProvider }

extension LeaderboardTypeApiValue on LeaderboardType {
  String get apiValue {
    return switch (this) {
      LeaderboardType.all => 'all',
      LeaderboardType.company => 'company',
      LeaderboardType.influencer => 'influencer',
      LeaderboardType.serviceProvider => 'service_provider',
    };
  }
}

class LeaderboardRank {
  const LeaderboardRank(this.value);

  final int value;

  bool get isPodium => value >= 1 && value <= 3;

  String get label => '#$value';
}

class LeaderboardProfile {
  const LeaderboardProfile({
    required this.id,
    required this.rank,
    required this.displayName,
    this.username,
    this.avatarUrl,
    this.bio,
    this.accountType,
    this.followersCount = 0,
    this.score,
    this.badgeLabel,
    this.isVerified = false,
    this.isFeatured = false,
  });

  final String id;
  final LeaderboardRank rank;
  final String displayName;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final String? accountType;
  final int followersCount;
  final int? score;
  final String? badgeLabel;
  final bool isVerified;
  final bool isFeatured;

  int get displayScore => score ?? followersCount;

  String get followersLabel {
    if (followersCount >= 1000000) {
      final millions = followersCount / 1000000;
      return '${_formatCompactNumber(millions)}M followers';
    }
    if (followersCount >= 1000) {
      final thousands = followersCount / 1000;
      return '${_formatCompactNumber(thousands)}K followers';
    }
    return '$followersCount followers';
  }

  String get accountTypeLabel {
    return switch (accountType) {
      'company' => 'Company',
      'influencer' => 'Influencer',
      'service_provider' => 'Service provider',
      _ => 'Promoo profile',
    };
  }
}

String _formatCompactNumber(double value) {
  if (value % 1 == 0) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
