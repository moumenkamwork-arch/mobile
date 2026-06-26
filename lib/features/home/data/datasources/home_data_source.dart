import '../dto/home_content_dto.dart';
import '../../domain/entities/home_content.dart';

abstract interface class HomeDataSource {
  Future<HomeContentDto> fetchHomeContent();

  Future<HomeContentDetailDto> fetchHomeContentDetail(
    HomeContentDetailRequest request,
  );
}
