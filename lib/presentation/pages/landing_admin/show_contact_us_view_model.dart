import 'dart:developer';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart' as model;
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => AdminShowContactUsViewModel());

class AdminShowContactUsViewModel extends BaseViewModel {


  AdminShowContactUsViewModel();

  static AutoDisposeChangeNotifierProvider<AdminShowContactUsViewModel> get provider =>
      _provider;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? imageUrl;

  String? firstNameError;
  String? lastNameError;
  String? mobileNumberError;
  String? companyNameError;
  String? notesError;

  bool imageLoading = false;

  final List<Category> _categories = [];
  List<Category> get getCategories => _categories;

  

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

 
}
