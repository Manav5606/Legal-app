import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/data/models/client.dart';
import 'package:admin/data/models/app_error.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/domain/repositories/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _clientRepositoryProvider = Provider<ClientRepositoryImpl>(
    (ref) => ClientRepositoryImpl(FirebaseFirestore.instance));

class ClientRepositoryImpl extends ClientRepository
    with RepositoryExceptionMixin {
  static Provider<ClientRepositoryImpl> get provider =>
      _clientRepositoryProvider;

  final FirebaseFirestore _firebaseFirestore;

  ClientRepositoryImpl(this._firebaseFirestore);

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
}
