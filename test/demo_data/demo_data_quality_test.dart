import 'package:flutter_test/flutter_test.dart';
import 'package:promoo_app/features/auth/data/datasources/auth_fake_data_source.dart';
import 'package:promoo_app/features/auth/domain/entities/auth_session.dart';
import 'package:promoo_app/features/chat/data/datasources/chat_fake_data_source.dart';
import 'package:promoo_app/features/home/data/datasources/home_fake_data_source.dart';
import 'package:promoo_app/features/home/domain/entities/home_content.dart';
import 'package:promoo_app/features/leaderboard/data/datasources/leaderboard_fake_data_source.dart';
import 'package:promoo_app/features/notifications/data/datasources/notifications_fake_data_source.dart';
import 'package:promoo_app/features/profile/data/datasources/profile_fake_data_source.dart';
import 'package:promoo_app/features/profile/domain/entities/promoo_profile.dart';
import 'package:promoo_app/features/search/data/datasources/search_fake_data_source.dart';
import 'package:promoo_app/features/search/domain/entities/search_result.dart';
import 'package:promoo_app/features/seats/data/datasources/seats_fake_data_source.dart';
import 'package:promoo_app/features/seats/domain/entities/seat.dart';
import 'package:promoo_app/features/services/data/datasources/services_fake_data_source.dart';

void main() {
  test('mock-mode visible data avoids placeholder wording', () async {
    final strings = await _collectVisibleDemoStrings();
    final forbidden = RegExp(
      r'\b(lorem|test|mock|sample|demo)\b',
      caseSensitive: false,
    );

    expect(strings, isNotEmpty);
    for (final value in strings) {
      expect(value, isNot(matches(forbidden)), reason: value);
    }
  });

  test('mock-mode prices use AED only', () async {
    final services = (await const ServicesFakeDataSource().fetchServices())
        .toDomain(fallbackCurrency: 'AED');
    final profilePackages =
        (await ProfileFakeDataSource().fetchProfilePackages(
          ProfileFakeDataSource.demoProfileId,
        )).toDomain(
          fallbackCurrency: 'AED',
          profileId: ProfileFakeDataSource.demoProfileId,
        );
    final seats = (await const SeatsFakeDataSource().fetchSeats()).toDomain(
      fallbackCurrency: 'AED',
    );
    final searchResults = (await const SearchFakeDataSource().search(
      query: '',
      filter: SearchFilterType.all,
    )).toDomain(fallbackCurrency: 'AED').results;
    final homeDetails = await _homeDetails();

    final currencies = <String>[
      for (final service in services)
        if (service.price != null) service.price!.currency,
      for (final package in profilePackages)
        if (package.price != null) package.price!.currency,
      for (final seat in seats)
        if (seat.price != null) seat.price!.currency,
      for (final result in searchResults)
        if (result is SearchServiceResult && result.price != null)
          result.price!.currency,
      for (final result in searchResults)
        if (result is SearchOfferResult && result.price != null)
          result.price!.currency,
      for (final detail in homeDetails)
        if (detail.price != null) detail.price!.currency,
    ];

    expect(currencies, isNotEmpty);
    expect(currencies.toSet(), {'AED'});
  });

  test(
    'mock-mode identities are consistent across main demo surfaces',
    () async {
      final home = (await const HomeFakeDataSource().fetchHomeContent())
          .toDomain();
      final services = (await const ServicesFakeDataSource().fetchServices())
          .toDomain(fallbackCurrency: 'AED');
      final profile = (await ProfileFakeDataSource().fetchMyProfile())
          .toDomain(fallbackId: 'profile-current');
      final search = (await const SearchFakeDataSource().search(
        query: 'saffron',
        filter: SearchFilterType.all,
      )).toDomain(fallbackCurrency: 'AED');

      expect(profile.id, 'profile-saffron-social');
      expect(profile.displayName, 'Saffron Social Studio');
      expect(
        home.profiles.map((item) => item.name),
        contains(profile.displayName),
      );
      expect(
        services.map((item) => item.provider?.name),
        contains(profile.displayName),
      );
      expect(
        search.results.map((item) => item.title),
        contains(profile.displayName),
      );
      expect(
        services.map((item) => item.title),
        contains('Boutique influencer launch package'),
      );
    },
  );
}

Future<List<HomeContentDetail>> _homeDetails() async {
  const source = HomeFakeDataSource();
  const requests = [
    HomeContentDetailRequest(
      type: HomeContentDetailType.offer,
      id: 'offer-featured',
    ),
    HomeContentDetailRequest(type: HomeContentDetailType.offer, id: 'offer-1'),
    HomeContentDetailRequest(type: HomeContentDetailType.offer, id: 'offer-2'),
  ];

  return [
    for (final request in requests)
      (await source.fetchHomeContentDetail(
        request,
      )).toDomain(fallbackId: request.id, fallbackCurrency: 'AED'),
  ];
}

Future<List<String>> _collectVisibleDemoStrings() async {
  final home = (await const HomeFakeDataSource().fetchHomeContent()).toDomain();
  final homeDetails = await _homeDetails();
  final categories = (await const ServicesFakeDataSource().fetchCategories())
      .toDomain();
  final services = (await const ServicesFakeDataSource().fetchServices())
      .toDomain(fallbackCurrency: 'AED');
  final profile = (await ProfileFakeDataSource().fetchMyProfile())
      .toDomain(fallbackId: 'profile-current');
  final profilePackages =
      (await ProfileFakeDataSource().fetchProfilePackages(
        ProfileFakeDataSource.demoProfileId,
      )).toDomain(
        fallbackCurrency: 'AED',
        profileId: ProfileFakeDataSource.demoProfileId,
      );
  final seats = (await const SeatsFakeDataSource().fetchSeats()).toDomain(
    fallbackCurrency: 'AED',
  );
  final leaderboard =
      (await const LeaderboardFakeDataSource().fetchLeaderboard()).toDomain();
  final search = (await const SearchFakeDataSource().search(
    query: '',
    filter: SearchFilterType.all,
  )).toDomain(fallbackCurrency: 'AED').results;
  final chatRooms = (await ChatFakeDataSource().fetchRooms(
    accessToken: null,
  )).toDomain(currentUserId: 'current-user');
  final chatMessages = (await ChatFakeDataSource().fetchMessages(
    accessToken: null,
    roomId: 'chat-room-1',
  )).toDomain(currentUserId: 'current-user');
  final notifications = (await NotificationsFakeDataSource().fetchNotifications(
    accessToken: null,
  )).toDomain();
  final authSession = (await const AuthFakeDataSource().loginWithEmail(
    email: 'alya@promoo.app',
    password: 'password123',
  )).toDomain();

  return [
    if (home.highlight != null) ...[
      home.highlight!.title,
      ?home.highlight!.subtitle,
      ?home.highlight!.badge,
      ?home.highlight!.actionLabel,
    ],
    for (final story in home.stories) story.title,
    for (final category in home.categories) category.name,
    for (final service in home.services) ...[
      service.title,
      ?service.subtitle,
      ?service.categoryName,
      ?service.location,
    ],
    for (final offer in home.offers) ...[offer.title, ?offer.subtitle],
    for (final profile in home.profiles) ...[
      profile.name,
      ?profile.username,
      ?profile.accountType,
    ],
    for (final detail in homeDetails) ...[
      detail.title,
      ?detail.description,
      ?detail.badge,
      ?detail.categoryName,
      ?detail.location,
      ?detail.promoCode,
      ?detail.validUntil,
      ?detail.terms,
      for (final tag in detail.tags) tag,
      if (detail.provider != null) ...[
        detail.provider!.displayName,
        ?detail.provider!.username,
        ?detail.provider!.accountType,
      ],
      ?detail.price?.label,
    ],
    for (final category in categories) category.name,
    for (final service in services) ...[
      service.title,
      ?service.description,
      ?service.category?.name,
      ?service.provider?.name,
      ?service.provider?.username,
      ?service.provider?.accountType,
      ?service.location,
      ?service.price?.label,
      for (final tag in service.tags) tag,
    ],
    profile.displayName,
    profile.handle,
    ?profile.bio,
    ?profile.location,
    ?profile.categoryName,
    profile.accountType.label,
    for (final mediaUrl in profile.mediaUrls) mediaUrl,
    for (final package in profilePackages) ...[
      package.title,
      ?package.description,
      ?package.categoryName,
      ?package.price?.label,
      for (final tag in package.tags) tag,
    ],
    for (final seat in seats) ...[
      seat.tier.label,
      seat.status.label,
      ?seat.price?.label,
      ?seat.holder?.name,
      ?seat.holder?.username,
    ],
    for (final profile in leaderboard) ...[
      profile.displayName,
      ?profile.username,
      ?profile.accountType,
      ?profile.badgeLabel,
    ],
    for (final result in search) ...[
      result.title,
      ?result.subtitle,
      ?result.description,
      ?result.provider?.name,
      ?result.provider?.username,
      ?result.provider?.accountType,
      if (result is SearchServiceResult) ?result.price?.label,
      if (result is SearchOfferResult) ?result.price?.label,
    ],
    for (final room in chatRooms) ...[
      room.participant.displayName,
      ?room.participant.username,
      ?room.lastMessage?.content,
    ],
    for (final message in chatMessages) ...[
      message.content,
      ?message.sender?.displayName,
      ?message.sender?.username,
    ],
    for (final notification in notifications) ...[
      notification.title,
      notification.body,
    ],
    authSession.user.displayName,
    ?authSession.user.email,
    authSession.user.accountType.apiValue,
  ];
}
