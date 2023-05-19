import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/domain/provider/auth_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _forgotPasswordViewModel = ChangeNotifierProvider.autoDispose(
    (ref) => ForgotPasswordViewModel(ref.read(AppState.auth.notifier)));

class ForgotPasswordViewModel extends BaseViewModel {
  static AutoDisposeChangeNotifierProvider<ForgotPasswordViewModel> get provider =>
      _forgotPasswordViewModel;
  ForgotPasswordViewModel(this._authProvider);
  final AuthProvider _authProvider;

  static late User me;
  // static late FirebaseFirestore _firebaseFirestore;

  final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;

  String? emailError;
  String? passwordError;

  bool get showPassword => _passwordVisible;

  

  void clearError() {
    emailError = passwordError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();
    if (emailController.text.isEmpty) {
      emailError = "This field is required.";
    }
   
    return emailError == null;
  }

  @override
  void dispose() {
    emailController.dispose();
   
    super.dispose();
  }

  Future<bool?> forgotPassword() async {
    try {
      toggleLoadingOn(true);
      if (_validateValues()) {
        final result = await _authProvider.forgotPasswordd(
          email: emailController.text,
       
        );
        // TODO add check for isDeactivated
        return result.fold((l) async {
          Messenger.showSnackbar(l.message);
          return null;
        }, (r) async {
       
          Messenger.showSnackbar("Email Sent Succesfully to ${emailController.text} In ✅");
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
