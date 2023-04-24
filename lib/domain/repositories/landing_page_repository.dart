import 'package:admin/data/models/app_error.dart';
import 'package:admin/data/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class LandingPageRepository {
  Future<Either<AppError, List<BannerDetail>>> getBanners();

  
}
