import 'package:admin/legal_admin.dart';
import 'package:flutter/material.dart';

class Messenger {
  static showSnackbar(String text) {
    globalScaffold.currentState?.clearSnackBars();
    globalScaffold.currentState?.showSnackBar(SnackBar(
      content: Text(text),
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 2),
    ));
  }
}
