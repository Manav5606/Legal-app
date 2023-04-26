import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/models.dart' as model;
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
  Future<Either<model.AppError, bool>> createVendor(
      {required model.Vendor vendor}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.vendorCollection)
          .add(vendor.toJson());
      // TODO create client model from result
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.User>>> fetchUsersByType(
      UserType type) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .where("user_type", isEqualTo: type.name)
          .get();

      return Right(
          response.docs.map((doc) => model.User.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.User>> fetchUserByID(String uid) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(uid)
          .get();

      return Right(model.User.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Vendor>> fetchVendorByID(
      String uid) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.vendorCollection)
          .doc(uid)
          .get();

      return Right(model.Vendor.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.User>> updateUser(
      {required model.User user}) async {
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
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deactivateUser(
      {required model.User user}) async {
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
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> activateUser(
      {required model.User user}) async {
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
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.Category>>> fetchCategories() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .get();

      return Right(response.docs
          .map((doc) => model.Category.fromSnapshot(doc))
          .toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Category>> createCategory(
      {required model.Category category}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .add(category.toJson());
      return Right(model.Category.fromSnapshot((await result.get())));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Category>> updateCategory(
      {required model.Category category}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .doc(category.id)
          .update(category.toJson());
      return Right(category);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deactivateCategory(
      {required model.Category category}) async {
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
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> activateCategory(
      {required model.Category category}) async {
    try {
      final dCategory = category.copyWith(isDeactivated: false);
      await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .doc(dCategory.id)
          .update(dCategory.toJson());
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.Service>>> fetchServices() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .get();

      return Right(
          response.docs.map((doc) => model.Service.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.Service>>> getServicesbyCategory(
      {required String categoryID}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .where("category_id", isEqualTo: categoryID)
          .get();

      return Right(
          response.docs.map((doc) => model.Service.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deactivateService(
      {required model.Service service}) async {
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
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> activateService(
      {required model.Service service}) async {
    try {
      final s = service.copyWith(isDeactivated: false);
      await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .doc(s.id)
          .update(s.toJson());
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Service>> createService(
      {required model.Service service}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .add(service.toJson());
      return Right(model.Service.fromSnapshot((await result.get())));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Service>> updateService(
      {required model.Service service}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .doc(service.id)
          .update(service.toJson());
      return Right(service);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Vendor>> updateVendor(
      {required model.Vendor vendor}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.vendorCollection)
          .doc(vendor.id)
          .update(vendor.toJson());
      return Right(vendor);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.ServiceRequest>> createNewServiceRequest(
      {required model.ServiceRequest serviceRequest}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.serviceRequestCollection)
          .add(serviceRequest.toJson());
      return Right(model.ServiceRequest.fromSnapshot((await result.get())));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deleteServiceRequest(
      {required String id}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.serviceRequestCollection)
          .doc(id)
          .delete();

      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.ServiceRequest>>>
      getServiceRequestByServiceId({required String serviceId}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.serviceRequestCollection)
          .where("service_id", isEqualTo: serviceId)
          .get();

      return Right(response.docs
          .map((doc) => model.ServiceRequest.fromSnapshot(doc))
          .toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Category>> getCategoryByID(
      {required String categoryId}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.categoryCollection)
          .doc(categoryId)
          .get();

      return Right(model.Category.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Service>> getServiceByID(
      {required String serviceId}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .doc(serviceId)
          .get();

      return Right(model.Service.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Transaction>> createTransaction(
      {required model.Transaction transaction}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.transactionCollection)
          .add(transaction.toJson());

      return Right(model.Transaction.fromSnapshot(await response.get()));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Order>> createOrder(
      {required model.Order order}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.orderCollection)
          .add(order.toJson());

      return Right(model.Order.fromSnapshot(await response.get()));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

   @override
  Future<Either<model.AppError, model.Order>> updateOrder(
      {required model.Order order}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.orderCollection)
          .doc(order.id)
          .update(order.toJson());
      return Right(order);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.BannerDetail>> createBanner(
      {required model.BannerDetail banner}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.landingBannerCollection)
          .add(banner.toJson());

      return Right(model.BannerDetail.fromSnapshot(await response.get()));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deleteBanner(
      {required model.BannerDetail banner}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.landingBannerCollection)
          .doc(banner.id!)
          .delete();
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.BannerDetail>>> getBanners() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.landingBannerCollection)
          .get();

      return Right(response.docs
          .map((doc) => model.BannerDetail.fromSnapshot(doc))
          .toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.BannerDetail>> updateBanner(
      {required model.BannerDetail banner}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.serviceCollection)
          .doc(banner.id)
          .update(banner.toJson());
      return Right(banner);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.CustomerReview>> createReview(
      {required model.CustomerReview review}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.reviewCollection)
          .add(review.toJson());

      return Right(model.CustomerReview.fromSnapshot(await response.get()));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deleteReview(
      {required model.CustomerReview review}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.reviewCollection)
          .doc(review.id!)
          .delete();
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.CustomerReview>>>
      getReviews() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.reviewCollection)
          .get();

      return Right(response.docs
          .map((doc) => model.CustomerReview.fromSnapshot(doc))
          .toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.CustomerReview>> updateReview(
      {required model.CustomerReview review}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.reviewCollection)
          .doc(review.id)
          .update(review.toJson());
      return Right(review);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Category>> createContact(
      {required model.Category contact}) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.contactCollection)
          .add(contact.toJson());

      return Right(model.Category.fromSnapshot(await response.get()));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, bool>> deleteContact(
      {required model.Category contact}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.contactCollection)
          .doc(contact.id!)
          .delete();
      return const Right(true);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Category>> updateContact(
      {required model.Category contact}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConfig.contactCollection)
          .doc(contact.id)
          .update(contact.toJson());
      return Right(contact);
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.Category>>>
      getContactDetails() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.contactCollection)
          .get();

      return Right(response.docs
          .map((doc) => model.Category.fromSnapshot(doc))
          .toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, List<model.Order>>> fetchOrders() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.orderCollection)
          .get();

      return Right(
          response.docs.map((doc) => model.Order.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<Either<model.AppError, model.Order>> fetchOrderByID(String uid) async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.orderCollection)
          .doc(uid)
          .get();

      return Right(model.Order.fromSnapshot(response));
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          model.AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(
          model.AppError(message: "Unkown Error, Plese try again later."));
    }
  }
}
