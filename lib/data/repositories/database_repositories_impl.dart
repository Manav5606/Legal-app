import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/client.dart';
import 'package:admin/data/models/app_error.dart';
import 'package:admin/data/models/user.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/domain/repositories/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _databaseRepositoryProvider = Provider<DatabaseRepositoryImpl>(
    (ref) => DatabaseRepositoryImpl(FirebaseFirestore.instance));

class DatabaseRepositoryImpl extends DatabaseRepository
    with RepositoryExceptionMixin {
  static Provider<DatabaseRepositoryImpl> get provider =>
      _databaseRepositoryProvider;

  final FirebaseFirestore _firebaseFirestore;

  DatabaseRepositoryImpl(this._firebaseFirestore);

  @override
  Future<Either<AppError, bool>> createClient({required Client client}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .add(client.toJson());
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
  Future<Either<AppError, List<User>>> fetchAllClients() async {
    try {
      final response = await _firebaseFirestore
          .collection(FirebaseConfig.userCollection)
          .where("user_type", isEqualTo: UserType.client.name)
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
}
