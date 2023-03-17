import 'package:admin/core/provider.dart';
import 'package:admin/core/state/auth_state.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _authProvider =
    StateNotifierProvider<AuthProvider, AuthState>((ref) => AuthProvider(
          ref.read(Repository.auth),
        ));

class AuthProvider extends StateNotifier<AuthState> {
  static StateNotifierProvider<AuthProvider, AuthState> get provider =>
      _authProvider;
  final AuthRepositoryImpl _authRepositoryImpl;

  AuthProvider(this._authRepositoryImpl)
      : super(const AuthState.unauthenticated(isLoading: true)) {
    startStreamingUserData();
  }

  User? getUser() {
    return state.user;
  }

  void setUser(User? user) {
    if (user == null) return;
    state = state.copyWith(isLoading: false, user: user);
    debugPrint(
        "{AUTH_PROVIDER} USER SET: ${user.email}, ${user.userType.name}");
  }

  Future<void> startStreamingUserData() async {
    _authRepositoryImpl.getUser().listen((result) {
      if (mounted) {
        result.fold((l) {
          debugPrint("{AUTH_PROVIDER} FAILURE: ${l.message}, ${l.description}");
          state = const AuthState.unauthenticated();
        }, (r) {
          debugPrint("{AUTH_PROVIDER} SUCCESS");
          setUser(r);
        });
      }
    });
  }

  Future<Either<AppError, User>> register({
    required User user,
    required String password,
  }) async {
    final result = await _authRepositoryImpl.registerWithEmailPassword(
      password: password,
      user: user,
    );
    if (result.isRight()) {
      startStreamingUserData();
    }
    return result;
  }

  Future<Either<AppError, User>> login({
    required String email,
    required String password,
  }) async {
    final result = await _authRepositoryImpl.loginWithEmailPassword(
      email: email,
      password: password,
    );
    if (result.isRight()) {
      startStreamingUserData();
    }
    return result;
  }
}
