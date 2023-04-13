import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/models/models.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';

abstract class DatabaseRepository {
  Future<Either<AppError, Category>> getCategoryByID(
      {required String categoryId});
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
  Future<Either<AppError, bool>> activateCategory({required Category category});
  Future<Either<AppError, List<Category>>> fetchCategories();
  Future<Either<AppError, List<Service>>> fetchServices();
  Future<Either<AppError, bool>> deactivateService({required Service service});
  Future<Either<AppError, bool>> activateService({required Service service});
  Future<Either<AppError, List<Service>>> getServicesbyCategory(
      {required String categoryID});
  Future<Either<AppError, Service>> createService({required Service service});
  Future<Either<AppError, ServiceRequest>> createNewServiceRequest(
      {required ServiceRequest serviceRequest});
  Future<Either<AppError, Service>> updateService({required Service service});
  Future<Either<AppError, bool>> deleteServiceRequest({required String id});
  Future<Either<AppError, List<ServiceRequest>>> getServiceRequestByServiceId(
      {required String serviceId});
}
