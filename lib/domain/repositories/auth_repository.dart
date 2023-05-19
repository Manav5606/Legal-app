import 'package:admin/data/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<AppError, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<AppError, bool>> forgotPassword({
    required String email
  });
  Future<Either<AppError, User>> registerWithEmailPassword({
    required String password,
    required User user,
    required bool createdByAdmin,
  });
  Future<void> logoutUser();
  Stream<Either<AppError, User>> getUser();
}
