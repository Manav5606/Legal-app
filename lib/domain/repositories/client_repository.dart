import 'package:admin/data/models/client.dart';
import 'package:admin/data/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class ClientRepository {
  Future<Either<AppError, bool>> createClient({required Client client});
}
