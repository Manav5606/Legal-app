import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/data/models/app_error.dart';
import 'package:admin/data/models/models.dart' as model;
import 'package:admin/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'index.dart';

final _authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) =>
    AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance));

class AuthRepositoryImpl extends AuthRepository with RepositoryExceptionMixin {
  AuthRepositoryImpl(this._firebaseAuth, this._firebaseFirestore);

  static Provider<AuthRepositoryImpl> get provider => _authRepositoryProvider;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<Either<model.AppError, model.User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return getCurrentUserDetailByID(uID: result.user!.uid);
    } on FirebaseAuthException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  Future<Either<model.AppError, model.User>> getCurrentUserDetailByID(
      {required String uID}) async {
    try {
      return Right(model.User.fromSnapshot((await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(uID)
          .get())));
    } on FirebaseException catch (fe) {
      logger.severe(fe);
      return Left(AppError(message: fe.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }

  @override
  Future<void> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }

  @override
  Stream<Either<AppError, model.User>> getUser() async* {
    try {
      final fbUiD = _firebaseAuth.currentUser?.uid;
      if (fbUiD == null) {
        yield Left(AppError(message: "Unauthenticated"));
      } else {
        await for (final doc in _firebaseFirestore
            .collection(FirebaseConfig.userCollection)
            .doc(fbUiD)
            .snapshots()) {
          yield Right(model.User.fromSnapshot((doc)));
        }
      }
    } on FirebaseException catch (e) {
      yield Left(AppError(
        message: "Firebase Error",
        description: "Failed to retrive User Info.",
        exception: e,
        stackTrace: e.stackTrace,
      ));
    }
  }

  /// TODO Add OTP logic Later
  @override
  Future<Either<model.AppError, model.User>> registerWithEmailPassword({
    required String password,
    required model.User user,
  }) async {
    try {
      // TODO don't delete
      // final result = await _firebaseAuth.createUserWithEmailAndPassword(
      //     email: user.email, password: password);
      // final User? firebaseUser = result.user;
      // if (firebaseUser == null) {
      //   return Left(
      //       AppError(message: "Something went wrong. Can't create account."));
      // }
      final doc = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .add(user.toJson());
      return Right(model.User.fromSnapshot((await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .doc(doc.id)
          .get())));
    } on FirebaseAuthException catch (fae) {
      logger.severe(fae);
      return Left(
          AppError(message: fae.message ?? "Server Failed to Respond."));
    } catch (e) {
      logger.severe(e);
      return Left(AppError(message: "Unkown Error, Plese try again later."));
    }
  }
}
