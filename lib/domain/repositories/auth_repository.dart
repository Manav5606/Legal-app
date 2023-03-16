import 'package:admin/data/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<AppError, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<void> logoutUser();
}
