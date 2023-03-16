import 'package:admin/core/state/auth_state.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider extends StateNotifier<AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl;

  AuthProvider(this._authRepositoryImpl)
      : super(const AuthState.unauthenticated(isLoading: true)) {
    startStreamingUserData();
  }

  User? getUser() {
    return state.user;
  }

  Future<void> startStreamingUserData() async {
    if (state.user != null) {
      _authRepositoryImpl.getCurrentUserDetailByID(uID: state.user!.id);
    }
  }
}
