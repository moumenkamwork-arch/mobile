import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/home_content.dart';
import '../dto/home_content_dto.dart';
import 'home_data_source.dart';

final homeFakeDataSourceProvider = Provider<HomeFakeDataSource>((ref) {
  return const HomeFakeDataSource();
});

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

    throw const ApiException(
      type: ApiExceptionType.notFound,
      message: 'Home item not found.',
    );
  }
}

const _fakeDetails = [
  HomeContentDetailDto(
    id: 'offer-featured',
    type: HomeContentDetailType.offer,
    title: 'Promoo of the day',
    description:
        'Premium visibility for a limited-time marketplace offer with a curated provider ready for direct contact.',
    badge: 'Featured',
    provider: HomeContentProviderDto(
      id: 'profile-demo',
      name: 'Noura Studio',
      username: 'noura.studio',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Marketing',
    tags: ['Featured', 'Launch', 'Content'],
    price: 1200,
    currency: 'AED',
    location: 'Dubai',
    validUntil: '2026-08-30',
    terms: 'Availability depends on provider schedule.',
  ),
  HomeContentDetailDto(
    id: 'offer-1',
    type: HomeContentDetailType.offer,
    title: 'Launch week promotion',
    description:
        'A highlighted offer for early Promoo partners preparing a first campaign launch.',
    badge: 'Limited offer',
    provider: HomeContentProviderDto(
      id: 'profile-demo',
      name: 'Noura Studio',
      username: 'noura.studio',
      accountType: 'company',
      isVerified: true,
    ),
    categoryName: 'Marketing',
    tags: ['Campaign', 'Social', 'Launch'],
    price: 1200,
    currency: 'AED',
    location: 'Dubai',
    promoCode: 'PROMOO-LAUNCH',
    validUntil: '2026-08-30',
    terms:
        'Promo code is shown for demo only until production offers confirm codes.',
  ),
  HomeContentDetailDto(
    id: 'offer-2',
    type: HomeContentDetailType.offer,
    title: 'Creator bundle',
    description:
        'A limited package for marketplace discovery with short-form content and profile placement.',
    badge: 'For you',
    provider: HomeContentProviderDto(
      id: 'provider-lens',
      name: 'Maya Lens',
      username: 'maya.lens',
      accountType: 'influencer',
      isVerified: true,
    ),
    categoryName: 'Creator services',
    tags: ['Creator', 'Video', 'Discovery'],
    price: 950,
    currency: 'AED',
    location: 'Abu Dhabi',
    validUntil: '2026-09-15',
  ),
  HomeContentDetailDto(
    id: 'ad-1',
    type: HomeContentDetailType.ad,
    title: 'Featured marketplace spotlight',
    description: 'Promoted placement for active campaigns in the Promoo feed.',
    badge: 'Promoted',
    provider: HomeContentProviderDto(
      id: 'profile-demo',
      name: 'Noura Studio',
      username: 'noura.studio',
      accountType: 'company',
      isVerified: true,
    ),
    tags: ['Sponsored', 'Marketplace'],
    price: 500,
    currency: 'AED',
    location: 'Dubai',
    terms:
        'Sponsored placement details are finalized in the production ads flow.',
  ),
];
