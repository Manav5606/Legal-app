import 'package:admin/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'index.dart';

final _authRepositoryProvider =
    Provider<AuthRepositoryImpl>((ref) => AuthRepositoryImpl());

class AuthRepositoryImpl extends AuthRepository with RepositoryExceptionMixin {
  static Provider<AuthRepositoryImpl> get provider => _authRepositoryProvider;

  @override
  Future create(
      {required String email, required String password, required String name}) {
    // TODO: implement create
    throw UnimplementedError();
  }
}
