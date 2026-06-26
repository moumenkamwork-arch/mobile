import '../../../../core/utils/result.dart';
import '../entities/home_content.dart';

abstract interface class HomeRepository {
  Future<Result<HomeContent>> getHomeContent();

  Future<Result<HomeContentDetail>> getHomeContentDetail(
    HomeContentDetailRequest request,
  );
}
