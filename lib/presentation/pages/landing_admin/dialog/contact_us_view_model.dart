import 'dart:developer';
import 'package:admin/core/extension/validator.dart';
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
    (ref) => ContactUsViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class ContactUsViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  ContactUsViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<ContactUsViewModel> get provider =>
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

  void clearError() {
    firstNameError = lastNameError =
        mobileNumberError = companyNameError = notesError = null;
    notifyListeners();
  }

  Future<XFile?> pickFile(FilePickerResult? result) async {
    if (result != null) {
      final choosenFile = result.files.first;
      return XFile.fromData(choosenFile.bytes!, name: choosenFile.name);
    }
    return null;
  }

  bool _validateValues() {
    clearError();

    if (firstNameController.text.isEmpty) {
      firstNameError = "First Name can't be empty.";
    }
    if (lastNameController.text.isEmpty) {
      lastNameError = "Last Name can't be empty.";
    }

    if (mobileNumberController.text.isEmpty ||
        !mobileNumberController.text.isValidPhoneNumber()) {
      mobileNumberError = "Please enter a valid 10 digit phone number";
    }
    if (companyNameController.text.isEmpty) {
      companyNameError = "Company Name can't be empty.";
    }
    if (notesController.text.isEmpty) {
      notesError = "Notes can't be empty.";
    }

    return firstNameError == null &&
        lastNameError == null &&
        mobileNumberError == null &&
        companyNameError == null &&
        notesError == null;
  }

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

  // void initBanner(model.BannerDetail? bannerDetail) {
  //   if (bannerDetail != null) {
  //     firstNameController.text = bannerDetail.title;
  //     lastNameController.text = bannerDetail.description;
  //     mobileNumberController.text = bannerDetail.btnText;
  //     companyNameController.text = bannerDetail.urlToLoad;

  //     notifyListeners();
  //   }
  // }

  // Future<void> fetchCategories() async {
  //   toggleLoadingOn(true);
  //   final res = await _databaseRepositoryImpl.fetchCategories();
  //   res.fold((l) {
  //     Messenger.showSnackbar(l.message);
  //     toggleLoadingOn(false);
  //   }, (r) {
  //     _categories.clear();
  //     _categories.addAll(r.where((e) => !e.isDeactivated).toList()
  //       ..sort((a, b) => a.name.compareTo(b.name)));
  //   });
  //   toggleLoadingOn(false);
  // }

  // Future<void> uploadImage({required XFile file}) async {
  //   try {
  //     imageLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, userID: "banner");
  //     imageUrl = downloadUrl;
  //   } catch (e) {
  //     log(e.toString());
  //   } finally {
  //     imageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future deleteBanner(model.BannerDetail banner) async {
  //   toggleLoadingOn(true);
  //   final result = await _databaseRepositoryImpl.deleteBanner(banner: banner);
  //   result.fold((l) async {
  //     Messenger.showSnackbar(l.message);
  //     toggleLoadingOn(false);
  //     return null;
  //   }, (r) {
  //     Messenger.showSnackbar("Banner Deleted");
  //     toggleLoadingOn(false);

  //     return r;
  //   });
  //   toggleLoadingOn(false);
  // }

  Future createContactUs() async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, model.ContactUsForm> result;

      final contact = model.ContactUsForm(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobileNumber: mobileNumberController.text,
        companyName: companyNameController.text,
        email: emailController.text,
        notes: notesController.text,
      );
      result = await _databaseRepositoryImpl.createContactUs(contact: contact);

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        Messenger.showSnackbar("Form Submitted Successfully ✅");

        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
