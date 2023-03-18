import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider((ref) => AddClientViewModel());

class AddClientViewModel extends BaseViewModel {
  static ChangeNotifierProvider<AddClientViewModel> get provider => _provider;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
}
