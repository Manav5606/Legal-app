import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/domain/provider/auth_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider(
    (ref) => AddClientViewModel(ref.read(AppState.auth.notifier)));

class AddClientViewModel extends BaseViewModel {
  final AuthProvider _authProvider;

  AddClientViewModel(this._authProvider);

  static ChangeNotifierProvider<AddClientViewModel> get provider => _provider;
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

    if (emailController.text.isEmpty) {
      emailError = "This field is required";
    }
    if (nameController.text.isEmpty) {
      emailError = "This field is required";
    }
    if (numberController.text.isEmpty) {
      emailError = "This field is required";
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

  Future createClient() async {
    if (_validateValues()) {
      final result = await _authProvider.register(
        user: User(
            name: nameController.text,
            userType: UserType.client,
            email: emailController.text,
            phoneNumber: int.parse(numberController.text)),
        password: "12345@test",
      );
      // TODO ask for other details and add them also
      result.fold((l) async {
        Messenger.showSnackbar(l.message);
        return null;
      }, (r) {
        Messenger.showSnackbar("Client Created ✅");
        return r;
      });
    }
  }
}
