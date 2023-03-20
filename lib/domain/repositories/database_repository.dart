import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/client.dart';
import 'package:admin/data/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class DatabaseRepository {
  Future<Either<AppError, bool>> createClient({required Client client});
  Future<Either<AppError, bool>> updateUser({required User user});
  Future<Either<AppError, bool>> deactivateUser({required User user});

  Future<Either<AppError, List<User>>> fetchUsersByType(UserType type);
}
