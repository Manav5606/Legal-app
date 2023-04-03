import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class DatabaseRepository {
  Future<Either<AppError, bool>> createVendor({required Vendor vendor});
  Future<Either<AppError, User>> updateUser({required User user});
  Future<Either<AppError, bool>> deactivateUser({required User user});
  Future<Either<AppError, bool>> activateUser({required User user});
  Future<Either<AppError, List<User>>> fetchUsersByType(UserType type);
  Future<Either<AppError, Category>> createCategory(
      {required Category category});
  Future<Either<AppError, Category>> updateCategory(
      {required Category category});
  Future<Either<AppError, bool>> deactivateCategory(
      {required Category category});
  Future<Either<AppError, bool>> activateCategory({required Category category});
  Future<Either<AppError, List<Category>>> fetchCategories();
  Future<Either<AppError, List<Service>>> fetchServices();
  Future<Either<AppError, bool>> deactivateService({required Service service});
  Future<Either<AppError, List<Service>>> getServicesbyCategory(
      {required String categoryID});
  Future<Either<AppError, Service>> createService({required Service service});
  Future<Either<AppError, Service>> updateService({required Service service});
}
