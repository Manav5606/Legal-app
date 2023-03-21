import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/domain/provider/auth_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _loginViewModel = ChangeNotifierProvider.autoDispose(
    (ref) => LoginViewModel(ref.read(AppState.auth.notifier)));

class LoginViewModel extends BaseViewModel {
  static AutoDisposeChangeNotifierProvider<LoginViewModel> get provider =>
      _loginViewModel;
  LoginViewModel(this._authProvider);
  final AuthProvider _authProvider;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;

  String? nameError;
  String? passwordError;

  bool get showPassword => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void clearError() {
    nameError = passwordError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();
    if (nameController.text.isEmpty) {
      nameError = "This field is required.";
    }
    if (passwordController.text.isEmpty) {
      passwordError = "This field is required.";
    }

    return nameError == null && passwordError == null;
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<User?> login() async {
    try {
      toggleLoadingOn(true);
      if (_validateValues()) {
        final result = await _authProvider.login(
          email: nameController.text,
          password: passwordController.text,
        );
        // TODO add check for isDeactivated
        return result.fold((l) async {
          Messenger.showSnackbar(l.message);
          return null;
        }, (r) {
          Messenger.showSnackbar("Logged In ✅");
          return r;
        });
      }
      return null;
    } catch (e) {
      Messenger.showSnackbar(e.toString());
      return null;
    } finally {
      toggleLoadingOn(false);
    }
  }
}
