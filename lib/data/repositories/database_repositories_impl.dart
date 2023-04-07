import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/category.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/models/app_error.dart';
import 'package:admin/data/models/service.dart';
import 'package:admin/data/models/user.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/domain/repositories/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _databaseRepositoryProvider = Provider<DatabaseRepositoryImpl>((ref) =>
    DatabaseRepositoryImpl(
        FirebaseFirestore.instance, FirebaseStorage.instance));

class DatabaseRepositoryImpl extends DatabaseRepository
    with RepositoryExceptionMixin {
  static Provider<DatabaseRepositoryImpl> get provider =>
      _databaseRepositoryProvider;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  DatabaseRepositoryImpl(this._firebaseFirestore, this._firebaseStorage);

  @override
  Future<String> uploadToFirestore(
      {required XFile file, required String userID}) async {
    final fileBytes = await file.readAsBytes();
    final ref = _firebaseStorage.ref(
        'documents/$userID/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
    return await (await ref.putData(fileBytes)).ref.getDownloadURL();
  }

  @override
  Future<Either<AppError, bool>> createVendor({required Vendor vendor}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.vendorCollection)
          .add(vendor.toJson());
      // TODO create client model from result
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, List<User>>> fetchUsersByType(UserType type) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .where("user_type", isEqualTo: type.name)
          .get();

      return Right(response.docs.map((doc) => User.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, User>> fetchUserByID(String uid) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(uid)
          .get();

      return Right(User.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, Vendor>> fetchVendorByID(String uid) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.vendorCollection)
          .doc(uid)
          .get();

      return Right(Vendor.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, User>> updateUser({required User user}) async {
    try {
      print("Updating user");

      print(user.toJson());
      await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(user.id)
          .update(user.toJson());
      print("Updated user");
      return Right(user);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, bool>> deactivateUser({required User user}) async {
    try {
      final dUser = user.copyWith(isDeactivated: true);
      await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(dUser.id)
          .update(dUser.toJson());
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, bool>> activateUser({required User user}) async {
    try {
      final dUser = user.copyWith(isDeactivated: false);
      await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(dUser.id)
          .update(dUser.toJson());
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, List<Category>>> fetchCategories() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .get();

      return Right(
          response.docs.map((doc) => Category.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, Category>> createCategory(
      {required Category category}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .add(category.toJson());
      return Right(Category.fromSnapshot((await result.get())));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, Category>> updateCategory(
      {required Category category}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .doc(category.id)
          .update(category.toJson());
      return Right(category);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, bool>> deactivateCategory(
      {required Category category}) async {
    try {
      final dCategory = category.copyWith(isDeactivated: true);
      await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .doc(dCategory.id)
          .update(dCategory.toJson());
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, bool>> activateCategory(
      {required Category category}) {
    // TODO: implement activateCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<AppError, List<Service>>> fetchServices() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .get();

      return Right(
          response.docs.map((doc) => Service.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, List<Service>>> getServicesbyCategory(
      {required String categoryID}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .where("category_id", isEqualTo: categoryID)
          .get();

      return Right(
          response.docs.map((doc) => Service.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, bool>> deactivateService(
      {required Service service}) async {
    try {
      final s = service.copyWith(isDeactivated: true);
      await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .doc(s.id)
          .update(s.toJson());
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, Service>> createService(
      {required Service service}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .add(service.toJson());
      return Right(Service.fromSnapshot((await result.get())));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, Service>> updateService(
      {required Service service}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .doc(service.id)
          .update(service.toJson());
      return Right(service);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<AppError, Vendor>> updateVendor({required Vendor vendor}) {
    // TODO: implement updateVendor
    throw UnimplementedError();
  }
}
