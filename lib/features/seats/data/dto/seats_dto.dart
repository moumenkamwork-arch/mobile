import '../../domain/entities/seat.dart';

class SeatDto {
  const SeatDto({
    this.id,
    this.tier,
    this.price,
    this.currency,
    this.status,
    this.position,
    this.holder,
    this.expiresAt,
  });

  final String? id;
  final String? tier;
  final num? price;
  final String? currency;
  final String? status;
  final int? position;
  final SeatHolderDto? holder;
  final DateTime? expiresAt;

  factory SeatDto.fromJson(Map<String, Object?> json) {
    final profile = _mapFrom(json['profile']) ?? _mapFrom(json['holder']);

    return SeatDto(
      id: _readString(json, const ['id', 'seat_id', 'seatId']),
      tier: _readString(json, const ['tier', 'seat_tier', 'seatTier']),
      price: _readNum(json, const ['price', 'amount']),
      currency: _readString(json, const ['currency']),
      status: _readString(json, const ['status', 'seat_status', 'seatStatus']),
      position: _readInt(json, const ['position', 'rank', 'slot']),
      holder: profile == null ? null : SeatHolderDto.fromJson(profile),
      expiresAt: _readDateTime(json, const ['expires_at', 'expiresAt']),
    );
  }

  bool get hasIdentity => id != null || tier != null || position != null;

  Seat toDomain({
    required String fallbackId,
    required int fallbackPosition,
    required String fallbackCurrency,
  }) {
    return Seat(
      id: id ?? fallbackId,
      tier: SeatTierValue.fromValue(tier),
      status: SeatStatusValue.fromValue(status),
      position: position ?? fallbackPosition,
      price: price == null
          ? null
          : SeatPrice(
              amount: price!,
              currency: _cleanCurrency(currency) ?? fallbackCurrency,
            ),
      holder: holder?.toDomain(fallbackId: '$fallbackId-holder'),
      expiresAt: expiresAt,
    );
  }
}

class SeatHolderDto {
  const SeatHolderDto({
    this.id,
    this.name,
    this.username,
    this.avatarUrl,
    this.categoryId,
  });

  final String? id;
  final String? name;
  final String? username;
  final String? avatarUrl;
  final String? categoryId;

  factory SeatHolderDto.fromJson(Map<String, Object?> json) {
    return SeatHolderDto(
      id: _readString(json, const ['id', 'profile_id', 'profileId']),
      name: _readString(json, const [
        'full_name',
        'fullName',
        'display_name',
        'displayName',
        'name',
        'username',
      ]),
      username: _readString(json, const ['username']),
      avatarUrl: _readString(json, const ['avatar_url', 'avatarUrl']),
      categoryId: _readString(json, const ['category_id', 'categoryId']),
    );
  }

  SeatHolder toDomain({required String fallbackId}) {
    return SeatHolder(
      id: id ?? fallbackId,
      name: name ?? username ?? 'Promoo profile',
      username: username,
      avatarUrl: avatarUrl,
      categoryId: categoryId,
    );
  }
}

class SeatsDto {
  const SeatsDto(this.seats);

  final List<SeatDto> seats;

  factory SeatsDto.empty() {
    return const SeatsDto([]);
  }

  factory SeatsDto.fromJsonFlexible(Object? value) {
    return SeatsDto(
      _mapsFrom(value).map(SeatDto.fromJson).toList(growable: false),
    );
  }

  List<Seat> toDomain({required String fallbackCurrency}) {
    return [
      for (var i = 0; i < seats.length; i++)
        if (seats[i].hasIdentity)
          seats[i].toDomain(
            fallbackId: 'seat-$i',
            fallbackPosition: i + 1,
            fallbackCurrency: fallbackCurrency,
          ),
    ];
  }
}

class SeatBookingResultDto {
  const SeatBookingResultDto({
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
  final String? status;

  factory SeatBookingResultDto.fromJsonFlexible(Object? value) {
    final map = _firstMapFrom(value);
    if (map == null) {
      return const SeatBookingResultDto();
    }

    return SeatBookingResultDto(
      seatId: _readString(map, const ['seat_id', 'seatId', 'id']),
      checkoutUrl: _readString(map, const [
        'checkoutUrl',
        'checkout_url',
        'url',
      ]),
      sessionId: _readString(map, const [
        'sessionId',
        'session_id',
        'checkoutSessionId',
        'checkout_session_id',
      ]),
      paymentId: _readString(map, const [
        'paymentId',
        'payment_id',
        'paymentIntent',
        'payment_intent',
      ]),
      status: _readString(map, const ['status', 'payment_status']),
    );
  }

  SeatBookingResult toDomain() {
    return SeatBookingResult(
      seatId: seatId,
      checkoutUrl: checkoutUrl,
      sessionId: sessionId,
      paymentId: paymentId,
      status: SeatStatusValue.fromValue(status),
    );
  }
}

List<Map<String, Object?>> _mapsFrom(Object? value) {
  final list = _listFrom(value);
  if (list != null) {
    final maps = <Map<String, Object?>>[];
    for (final item in list) {
      final mapped = _mapFrom(item);
      if (mapped != null) {
        maps.add(mapped);
      }
    }
    return maps;
  }

  final single = _mapFrom(value);
  if (single == null) {
    return const [];
  }
  return [single];
}

List<Object?>? _listFrom(Object? value) {
  if (value is List) {
    return List<Object?>.from(value);
  }

  final map = _mapFrom(value);
  if (map == null) {
    return null;
  }

  for (final key in const ['data', 'items', 'results', 'seats', 'records']) {
    final nested = map[key];
    if (nested is List) {
      return List<Object?>.from(nested);
    }

    final nestedList = _listFrom(nested);
    if (nestedList != null) {
      return nestedList;
    }
  }

  return null;
}

Map<String, Object?>? _firstMapFrom(Object? value) {
  final direct = _mapFrom(value);
  if (direct == null) {
    return null;
  }

  for (final key in const ['data', 'booking', 'result', 'session']) {
    final nested = _mapFrom(direct[key]);
    if (nested != null) {
      return nested;
    }
  }

  return direct;
}

Map<String, Object?>? _mapFrom(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String? _readString(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value is num || value is bool) {
      return value.toString();
    }
  }
  return null;
}

num? _readNum(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
  }
  return null;
}

int? _readInt(Map<String, Object?> map, List<String> keys) {
  final value = _readNum(map, keys);
  return value?.toInt();
}

DateTime? _readDateTime(Map<String, Object?> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
  }
  return null;
}

String? _cleanCurrency(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value.trim().toUpperCase();
}
