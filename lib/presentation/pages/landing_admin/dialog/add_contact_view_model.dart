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
    (ref) => AddContactViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class AddContactViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddContactViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddContactViewModel> get provider =>
      _provider;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? imageUrl;

  String? titleError;
  String? descriptionError;

  bool imageLoading = false;

  void clearError() {
    titleError = descriptionError = null;
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

    if (titleController.text.isEmpty) {
      titleError = "Title can't be empty.";
    }
    if (descriptionController.text.isEmpty) {
      descriptionError = "Description can't be empty.";
    }

    return titleError == null && descriptionError == null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void initContact(model.Category? contactDetail) {
    if (contactDetail != null) {
      titleController.text = contactDetail.name;
      descriptionController.text = contactDetail.description;
      imageUrl = contactDetail.iconUrl;
      notifyListeners();
    }
  }

  Future<void> uploadImage({required XFile file}) async {
    try {
      imageLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: "contact");
      imageUrl = downloadUrl;
    } catch (e) {
      log(e.toString());
    } finally {
      imageLoading = false;
      notifyListeners();
    }
  }

  Future deleteContact(model.Category contact) async {
    toggleLoadingOn(true);
    final result =
        await _databaseRepositoryImpl.deleteContact(contact: contact);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Contact Deleted");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createContact({model.Category? existingContact}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, model.Category> result;
      if (existingContact != null) {
        final contact = existingContact.copyWith(
          description: descriptionController.text,
          iconUrl: imageUrl ?? "",
          name: titleController.text,
        );
        result = await _databaseRepositoryImpl.updateContact(contact: contact);
      } else {
        final contact = model.Category(
          description: descriptionController.text,
          iconUrl: imageUrl ?? "",
          name: titleController.text,
          addedBy: "",
        );
        result = await _databaseRepositoryImpl.createContact(contact: contact);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingContact == null) {
          Messenger.showSnackbar("Contact Created ✅");
        } else {
          Messenger.showSnackbar("Updated Contact");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
