import 'package:admin/core/provider.dart';
import 'package:admin/core/state/auth_state.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _loginViewModel = ChangeNotifierProvider((ref) => LoginViewModel(
    ref.read(Repository.auth), ref.read(AppState.auth.notifier)));

class LoginViewModel extends BaseViewModel {
  static ChangeNotifierProvider<LoginViewModel> get provider => _loginViewModel;
  LoginViewModel(this._authRepositoryImpl, this._authService);
  final AuthService _authService;
  final AuthRepositoryImpl _authRepositoryImpl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      toggleLoadingOn(true);
      
    } catch (e) {
      Messenger.showSnackbar(e.toString());
    } finally {
      toggleLoadingOn(false);
    }
  }
}
