import 'package:admin/core/enum/role.dart';
import 'package:admin/core/extension/validator.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/domain/provider/auth_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _registerViewModel = ChangeNotifierProvider.autoDispose(
    (ref) => RegisterViewModel(ref.read(AppState.auth.notifier)));

class RegisterViewModel extends BaseViewModel {
  static AutoDisposeChangeNotifierProvider<RegisterViewModel> get provider =>
      _registerViewModel;
  RegisterViewModel(this._authProvider);
  final AuthProvider _authProvider;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();

  bool _passwordVisible = false;

  String? usernameError;
  String? numberError;
  String? emailError;
  String? password1Error;
  String? passwordError;

  bool get showPassword => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void clearError() {
    usernameError =
        passwordError = password1Error = emailError = numberError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();
    if (usernameController.text.isEmpty) {
      usernameError = "This field is required.";
    }
    if (emailController.text.isEmpty || !emailController.text.isValidEmail()) {
      emailError = "Please enter a valid email";
    }
    if (numberController.text.isEmpty ||
        !numberController.text.isValidPhoneNumber()) {
      numberError = "Please enter a valid 10 digit phone number";
    }
    if (passwordController.text.isEmpty ||
        !passwordController.text.isValidPassword()) {
      passwordError =
          "Please enter a valid password.\n(WIP) Length >= 8, Digit >= 4, Char >= 4 no Special Char.";
    } else {
      if (password1Controller.text != passwordController.text) {
        password1Error = "Password doesn't match.";
      }
    }

    return usernameError == null &&
        passwordError == null &&
        password1Error == null &&
        emailError == null &&
        numberError == null;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    password1Controller.dispose();
    numberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<User?> register() async {
    try {
      toggleLoadingOn(true);
      if (_validateValues()) {
        final result = await _authProvider.register(
          user: User(
            name: usernameController.text,
            userType: UserType.user,
            email: emailController.text,
            phoneNumber: int.parse(numberController.text),
          ),
          password: passwordController.text,
          streamUser: true,
        );
        return result.fold((l) async {
          Messenger.showSnackbar(l.message);
          return null;
        }, (r) {
          Messenger.showSnackbar("Registered ✅");
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
