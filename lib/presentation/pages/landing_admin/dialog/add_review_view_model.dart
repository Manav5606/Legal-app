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
    (ref) => AddReviewViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class AddReviewViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddReviewViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddReviewViewModel> get provider =>
      _provider;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  String? imageUrl;

  String? titleError;
  String? reviewError;
  String? nameError;
  String? designationError;

  bool imageLoading = false;

  void clearError() {
    titleError = reviewError = nameError = designationError = null;
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
    if (reviewController.text.isEmpty) {
      reviewError = "Review can't be empty.";
    }
    if (nameController.text.isEmpty) {
      nameError = "Name can't be empty.";
    }
    if (designationController.text.isEmpty) {
      designationError = "Designation can't be empty.";
    }

    return titleError == null &&
        reviewError == null &&
        nameError == null &&
        designationError == null;
  }

  @override
  void dispose() {
    titleController.dispose();
    reviewController.dispose();
    nameController.dispose();
    designationController.dispose();
    super.dispose();
  }

  void initReview(model.CustomerReview? review) {
    if (review != null) {
      titleController.text = review.title;
      reviewController.text = review.review;
      nameController.text = review.name;
      designationController.text = review.designation;
      imageUrl = review.customerProfilePic;
      notifyListeners();
    }
  }

  Future<void> uploadImage({required XFile file}) async {
    try {
      imageLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: "review");
      imageUrl = downloadUrl;
    } catch (e) {
      log(e.toString());
    } finally {
      imageLoading = false;
      notifyListeners();
    }
  }

  Future deleteReview(model.CustomerReview review) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deleteReview(review: review);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Review Deleted");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createReview({model.CustomerReview? existingReview}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, model.CustomerReview> result;
      if (existingReview != null) {
        final review = existingReview.copyWith(
          title: titleController.text,
          customerProfilePic: imageUrl,
          designation: designationController.text,
          name: nameController.text,
          review: reviewController.text,
        );
        result = await _databaseRepositoryImpl.updateReview(review: review);
      } else {
        final banner = model.CustomerReview(
          title: titleController.text,
          customerProfilePic: imageUrl ?? "",
          designation: designationController.text,
          name: nameController.text,
          review: reviewController.text,
        );
        result = await _databaseRepositoryImpl.createReview(review: banner);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingReview == null) {
          Messenger.showSnackbar("Review Created ✅");
        } else {
          Messenger.showSnackbar("Updated Review");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
