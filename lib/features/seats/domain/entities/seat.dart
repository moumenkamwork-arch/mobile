enum SeatTier { gold, silver, bronze, unknown }

extension SeatTierValue on SeatTier {
  static SeatTier fromValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'gold' => SeatTier.gold,
      'silver' => SeatTier.silver,
      'bronze' => SeatTier.bronze,
      _ => SeatTier.unknown,
    };
  }

  String? get apiValue {
    return switch (this) {
      SeatTier.gold => 'gold',
      SeatTier.silver => 'silver',
      SeatTier.bronze => 'bronze',
      SeatTier.unknown => null,
    };
  }

  String get label {
    return switch (this) {
      SeatTier.gold => 'Gold',
      SeatTier.silver => 'Silver',
      SeatTier.bronze => 'Bronze',
      SeatTier.unknown => 'Seat',
    };
  }
}

enum SeatStatus { available, booked, pending, expired, unknown }

extension SeatStatusValue on SeatStatus {
  static SeatStatus fromValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'available' => SeatStatus.available,
      'booked' => SeatStatus.booked,
      'pending' => SeatStatus.pending,
      'expired' => SeatStatus.expired,
      _ => SeatStatus.unknown,
    };
  }

  String get label {
    return switch (this) {
      SeatStatus.available => 'Available',
      SeatStatus.booked => 'Booked',
      SeatStatus.pending => 'Pending',
      SeatStatus.expired => 'Expired',
      SeatStatus.unknown => 'Unavailable',
    };
  }
}

class Seat {
  const Seat({
    required this.id,
    required this.tier,
    required this.status,
    required this.position,
    this.price,
    this.holder,
    this.expiresAt,
  });

  final String id;
  final SeatTier tier;
  final SeatStatus status;
  final int position;
  final SeatPrice? price;
  final SeatHolder? holder;
  final DateTime? expiresAt;

  bool get isAvailable => status == SeatStatus.available;

  String get title => '${tier.label} Seat $position';
}

class SeatPrice {
  const SeatPrice({required this.amount, required this.currency});

  final num amount;
  final String currency;

  String get label {
    final amountLabel = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '$amountLabel $currency';
  }
}

class SeatHolder {
  const SeatHolder({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
    this.categoryId,
  });

  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;
  final String? categoryId;
}

class SeatBookingResult {
  const SeatBookingResult({
    this.seatId,
    this.checkoutUrl,
    this.sessionId,
    this.paymentId,
    this.status,
  });

  final String? seatId;
  final String? checkoutUrl;
  final String? sessionId;
  final String? paymentId;
  final SeatStatus? status;

  bool get hasCheckoutUrl {
    return checkoutUrl != null && checkoutUrl!.trim().isNotEmpty;
  }
}
