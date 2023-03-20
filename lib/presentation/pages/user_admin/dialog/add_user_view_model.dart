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

final _provider = ChangeNotifierProvider.autoDispose((ref) => AddUserViewModel(
    ref.read(AppState.auth.notifier),
    ref.read(DatabaseRepositoryImpl.provider)));

class AddUserViewModel extends BaseViewModel {
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddUserViewModel(this._authProvider, this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddUserViewModel> get provider =>
      _provider;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? emailError;
  String? numberError;
  String? nameError;

  void clearError() {
    emailError = numberError = nameError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();

    if (emailController.text.isEmpty && emailController.text.isValidEmail()) {
      emailError = "Please enter a valid Email Address";
    }
    if (nameController.text.isEmpty) {
      nameError = "This field is required";
    }
    if (numberController.text.isEmpty &&
        numberController.text.isValidPhoneNumber()) {
      numberError = "Please enter a Valid 10 Digit Phone Number";
    }

    return emailError == null && nameError == null && numberError == null;
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void initUserUser(model.User? userUser) {
    if (userUser != null) {
      emailController.text = userUser.email;
      numberController.text = userUser.phoneNumber.toString();
      nameController.text = userUser.name;
      notifyListeners();
    }
  }

  Future deactivateUser(model.User user) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deactivateUser(user: user);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("User Deactivated");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createUser(model.User? existingUser) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, bool> result;
      if (existingUser != null) {
        final _user = existingUser.copyWith(
          name: nameController.text,
          email: emailController.text,
          phoneNumber: int.parse(numberController.text),
        );
        result = await _databaseRepositoryImpl.updateUser(user: _user);
      } else {
        result = await _authProvider.register(
          user: model.User(
            name: nameController.text,
            userType: UserType.user,
            email: emailController.text,
            phoneNumber: int.parse(numberController.text),
            createdBy: _authProvider.state.user!.id,
          ),
          password: "12345678",
        );
      }
      // Sent a email to registerd email ID with default Password.

      // TODO ask for other details and add them also
      result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) {
        if (existingUser == null) {
          Messenger.showSnackbar("User Created ✅ with Default Password");
        } else {
          Messenger.showSnackbar("Updated User");
        }
        toggleLoadingOn(false);

        return r;
      });
      toggleLoadingOn(false);
    }
  }
}
