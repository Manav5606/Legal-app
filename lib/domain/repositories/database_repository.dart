import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/models/models.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';

abstract class DatabaseRepository {
  Future<Either<AppError, bool>> createVendor({required Vendor vendor});
  Future<String> uploadToFirestore(
      {required XFile file, required String userID});
  Future<Either<AppError, User>> updateUser({required User user});
  Future<Either<AppError, Vendor>> updateVendor({required Vendor vendor});
  Future<Either<AppError, bool>> deactivateUser({required User user});
  Future<Either<AppError, bool>> activateUser({required User user});
  Future<Either<AppError, List<User>>> fetchUsersByType(UserType type);
  Future<Either<AppError, Vendor>> fetchVendorByID(String uid);
  Future<Either<AppError, User>> fetchUserByID(String uid);
  Future<Either<AppError, Category>> createCategory(
      {required Category category});
  Future<Either<AppError, Category>> updateCategory(
      {required Category category});
  Future<Either<AppError, bool>> deactivateCategory(
      {required Category category});
  Future<Either<AppError, List<Category>>> fetchCategories();
}
