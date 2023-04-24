import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/data/models/banner.dart';
import 'package:admin/data/models/app_error.dart';
import 'package:admin/data/repositories/respository_exception.dart';
import 'package:admin/domain/repositories/landing_page_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _landingPageRepositoryProvider = Provider<LandingPageRepositoryImpl>(
    (ref) => LandingPageRepositoryImpl(
        FirebaseFirestore.instance, FirebaseStorage.instance));

class LandingPageRepositoryImpl extends LandingPageRepository
    with RepositoryExceptionMixin {
  static Provider<LandingPageRepositoryImpl> get provider =>
      _landingPageRepositoryProvider;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  LandingPageRepositoryImpl(this._firebaseFirestore, this._firebaseStorage);

  @override
  Future<Either<AppError, List<BannerDetail>>> getBanners() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.landingBannerCollection)
          .get();

      return Right(response.docs.map((doc) => BannerDetail.fromSnapshot(doc)).toList());
    } on FirebaseException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }
}
