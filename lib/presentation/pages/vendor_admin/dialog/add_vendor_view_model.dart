import 'package:admin/core/enum/role.dart';
import 'package:admin/core/extension/validator.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart' as model;
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/domain/provider/auth_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose((ref) =>
    AddVendorViewModel(ref.read(AppState.auth.notifier),
        ref.read(DatabaseRepositoryImpl.provider)));

class AddVendorViewModel extends BaseViewModel {
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddVendorViewModel(this._authProvider, this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddVendorViewModel> get provider =>
      _provider;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _passwordVisible = false;

  String? emailError;
  String? numberError;
  String? passwordError;
  String? nameError;
  bool get showPassword => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void clearError() {
    emailError = numberError = nameError = passwordError = null;
    notifyListeners();
  }

  bool _validateValues(bool create) {
    clearError();

    if (emailController.text.isEmpty || !emailController.text.isValidEmail()) {
      emailError = "Please enter a valid Email Address";
    }
    if (nameController.text.isEmpty) {
      nameError = "This field is required";
    }
    if (create) {
      if (passwordController.text.isEmpty ||
          !passwordController.text.isValidPassword()) {
        passwordError = "This field is required";
      }
    }
    if (numberController.text.isEmpty ||
        !numberController.text.isValidPhoneNumber()) {
      numberError = "Please enter a Valid 10 Digit Phone Number";
    }

    return emailError == null &&
        nameError == null &&
        numberError == null &&
        passwordError == null;
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    numberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void initVendorUser(model.User? clientUser) {
    if (clientUser != null) {
      emailController.text = clientUser.email;
      numberController.text = clientUser.phoneNumber.toString();
      nameController.text = clientUser.name;
      notifyListeners();
    }
  }

  Future deactivateVendor(model.User user) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deactivateUser(user: user);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Vendor Deactivated");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createVendor(model.User? existingVendor) async {
    if (_validateValues(existingVendor == null ? true : false)) {
      toggleLoadingOn(true);
      late final Either<AppError, User> result;
      if (existingVendor != null) {
        final _user = existingVendor.copyWith(
          name: nameController.text,
          email: emailController.text,
          phoneNumber: int.parse(numberController.text),
        );
        result = await _databaseRepositoryImpl.updateUser(user: _user);
      } else {
        result = await _authProvider.register(
          user: model.User(
            name: nameController.text,
            userType: UserType.client,
            email: emailController.text,
            phoneNumber: int.parse(numberController.text),
            createdBy: _authProvider.state.user!.id,
          ),
          password: passwordController.text,
        );
      }

      print("Result:: ${result.fold((l) => l.toString(), (r) => r.toJson())}");

      // TODO ask for other details and add them also
      return result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) {
        if (existingVendor == null) {
          Messenger.showSnackbar("Vendor Created ✅ with Default Password");
        } else {
          Messenger.showSnackbar("Updated Vendor");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
