import 'package:admin/core/state/auth_state.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Repository {
  static Provider<AuthRepositoryImpl> get auth => AuthRepositoryImpl.provider;
}

abstract class AppState {
  static StateNotifierProvider<AuthService, AuthState> get auth =>
      AuthService.provider;
}
