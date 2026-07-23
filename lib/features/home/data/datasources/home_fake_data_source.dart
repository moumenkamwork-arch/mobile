import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/home_content.dart';
import '../dto/home_content_dto.dart';
import 'home_data_source.dart';

final homeFakeDataSourceProvider = Provider<HomeFakeDataSource>((ref) {
  return const HomeFakeDataSource();
});

const _demoBusinessImage =
    'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=900&q=80';
const _demoCafeImage =
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=80';
const _demoBeautyImage =
    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80';
const _demoDigitalImage =
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80';
const _demoWellnessImage =
    'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=900&q=80';
const _demoCreatorImage =
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=900&q=80';
const _demoTeamImage =
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=900&q=80';

class HomeFakeDataSource implements HomeDataSource {
  const HomeFakeDataSource();

  @override
  Future<HomeContentDto> fetchHomeContent() async {
    return HomeContentDto.fixture();
  }

  @override
  Future<HomeContentDetailDto> fetchHomeContentDetail(
    HomeContentDetailRequest request,
  ) async {
    for (final detail in _fakeDetails) {
      if (detail.id == request.id && detail.type == request.type) {
        return detail;
      }
    }

    throw const AppFailure.notFound(message: 'Home item not found.');
  }

  @override
  Future<void> createStory(String mediaUrl) async {}

  @override
  Future<void> deleteStory(String storyId) async {}
}

const _fakeDetails = [
  HomeContentDetailDto(
    id: 'offer-featured',
    type: HomeContentDetailType.offer,
    title: 'Boutique launch visibility pack',
    description:
        'A premium placement package for brands preparing a curated launch across Promoo stories, offers, and provider discovery.',
    imageUrl: _demoBusinessImage,
    badge: 'Promoo of the day',
    provider: HomeContentProviderDto(
      id: 'profile-saffron-social',
      name: 'Saffron Social Studio',
      username: 'saffron.social',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Influencer Campaigns',
    tags: ['Featured', 'Launch', 'Creator coverage'],
    price: 2200,
    currency: 'AED',
    location: 'Dubai',
    validUntil: '2026-08-30',
    terms:
        'Includes a curated placement plan, provider coordination, and one campaign review call.',
  ),
  HomeContentDetailDto(
    id: 'offer-1',
    type: HomeContentDetailType.offer,
    title: 'Cafe opening spotlight',
    description:
        'A discovery-focused offer for a new cafe opening, including launch visuals and city-audience placement.',
    imageUrl: _demoCafeImage,
    badge: 'Top offer',
    provider: HomeContentProviderDto(
      id: 'profile-pearl-cafe',
      name: 'Pearl District Cafe',
      username: 'pearl.district',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Restaurants & Cafes',
    tags: ['Cafe', 'Opening', 'City discovery'],
    price: 1500,
    currency: 'AED',
    location: 'Sharjah',
    promoCode: 'PEARLSPOTLIGHT',
    validUntil: '2026-08-30',
    terms:
        'Available for scheduled opening windows and provider-confirmed campaign dates.',
  ),
  HomeContentDetailDto(
    id: 'offer-2',
    type: HomeContentDetailType.offer,
    title: 'Wellness week visibility',
    description:
        'A polished awareness package for wellness providers preparing a seasonal visibility push.',
    imageUrl: _demoWellnessImage,
    badge: 'For you',
    provider: HomeContentProviderDto(
      id: 'profile-calmfit',
      name: 'CalmFit Wellness',
      username: 'calmfit.wellness',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Health & Fitness',
    tags: ['Wellness', 'Awareness', 'Lifestyle'],
    price: 1350,
    currency: 'AED',
    location: 'Abu Dhabi',
    validUntil: '2026-09-15',
  ),
  HomeContentDetailDto(
    id: 'offer-3',
    type: HomeContentDetailType.offer,
    title: 'Beauty launch feature',
    description:
        'An image-first visibility package for salon, beauty, and grooming launches that need a refined first impression.',
    imageUrl: _demoBeautyImage,
    badge: 'Top offer',
    provider: HomeContentProviderDto(
      id: 'profile-velvet-beauty',
      name: 'Velvet Beauty Lounge',
      username: 'velvet.beauty',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Beauty & Wellness',
    tags: ['Beauty', 'Opening', 'Editorial'],
    price: 1800,
    currency: 'AED',
    location: 'Dubai',
    validUntil: '2026-09-05',
  ),
  HomeContentDetailDto(
    id: 'offer-4',
    type: HomeContentDetailType.offer,
    title: 'Creator campaign pick',
    description:
        'A curated creator-led campaign placement for brands preparing a polished awareness push.',
    imageUrl: _demoCreatorImage,
    badge: 'For you',
    provider: HomeContentProviderDto(
      id: 'profile-lina-atelier',
      name: 'Lina Atelier',
      username: 'lina.atelier',
      accountType: 'influencer',
      isVerified: true,
    ),
    categoryName: 'Influencer Campaigns',
    tags: ['Creators', 'Campaign', 'Premium'],
    price: 2100,
    currency: 'AED',
    location: 'Dubai',
    validUntil: '2026-09-12',
  ),
  HomeContentDetailDto(
    id: 'offer-5',
    type: HomeContentDetailType.offer,
    title: 'Flash offer 24H',
    description:
        'A short-window discovery placement for campaigns that need immediate attention from high-intent audiences.',
    imageUrl: _demoDigitalImage,
    badge: 'Limited time',
    provider: HomeContentProviderDto(
      id: 'profile-saffron-social',
      name: 'Saffron Social Studio',
      username: 'saffron.social',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Digital Marketing',
    tags: ['Flash offer', '24H', 'Visibility'],
    price: 1250,
    currency: 'AED',
    location: 'Dubai',
    validUntil: '2026-08-20',
  ),
  HomeContentDetailDto(
    id: 'offer-6',
    type: HomeContentDetailType.offer,
    title: 'Restaurant reel boost',
    description:
        'A short-form food content placement for restaurants preparing a polished lunch, dinner, or seasonal menu push.',
    imageUrl: _demoCafeImage,
    badge: 'For you',
    provider: HomeContentProviderDto(
      id: 'profile-pearl-cafe',
      name: 'Pearl District Cafe',
      username: 'pearl.district',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Restaurants & Cafes',
    tags: ['Food', 'Reels', 'Discovery'],
    price: 1250,
    currency: 'AED',
    location: 'Sharjah',
    validUntil: '2026-09-08',
  ),
  HomeContentDetailDto(
    id: 'offer-7',
    type: HomeContentDetailType.offer,
    title: 'Event coverage window',
    description:
        'A focused event-visibility package for weekend openings, private launches, and branded experiences.',
    imageUrl: _demoTeamImage,
    badge: 'For you',
    provider: HomeContentProviderDto(
      id: 'profile-framehouse',
      name: 'Framehouse Events',
      username: 'framehouse.events',
      accountType: 'service_provider',
      isVerified: true,
    ),
    categoryName: 'Events & Photography',
    tags: ['Events', 'Coverage', 'Stories'],
    price: 1750,
    currency: 'AED',
    location: 'Dubai',
    validUntil: '2026-09-18',
  ),
];
