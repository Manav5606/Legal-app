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
    (ref) => AddBannerViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class AddBannerViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddBannerViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddBannerViewModel> get provider =>
      _provider;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController btnController = TextEditingController();
   TextEditingController urlController = TextEditingController();

  String? imageUrl;

  String? titleError;
  String? descriptionError;
  String? btnError;
  String? urlError;

  bool imageLoading = false;

  final List<Category> _categories = [];
  List<Category> get getCategories => _categories;

  void clearError() {
    titleError = descriptionError = btnError = urlError = null;
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
      titleError = "Banner title description can't be empty.";
    }
    if (descriptionController.text.isEmpty) {
      descriptionError = "Banner description can't be empty.";
    }
    if (btnController.text.isEmpty) {
      btnError = "Banner button text can't be empty.";
    }
    if (urlController.text.isEmpty) {
      urlError = "On Banner tap URL can't be empty.";
    }

    return titleError == null &&
        descriptionError == null &&
        btnError == null &&
        urlError == null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    btnController.dispose();
    urlController.dispose();
    super.dispose();
  }

  void initBanner(model.BannerDetail? bannerDetail) {
    if (bannerDetail != null) {
      titleController.text = bannerDetail.title;
      descriptionController.text = bannerDetail.description;
      btnController.text = bannerDetail.btnText;
      urlController.text = bannerDetail.urlToLoad;
      imageUrl = bannerDetail.imageUrl;
      notifyListeners();
    }
  }

   Future<void> fetchCategories() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchCategories();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _categories.clear();
      _categories.addAll(r.where((e) => !e.isDeactivated).toList()
        ..sort((a, b) => a.name.compareTo(b.name)));
    });
    toggleLoadingOn(false);
  }

  Future<void> uploadImage({required XFile file}) async {
    try {
      imageLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: "banner");
      imageUrl = downloadUrl;
    } catch (e) {
      log(e.toString());
    } finally {
      imageLoading = false;
      notifyListeners();
    }
  }

  Future deleteBanner(model.BannerDetail banner) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deleteBanner(banner: banner);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Banner Deleted");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createBanner({model.BannerDetail? existingBanner}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, model.BannerDetail> result;
      if (existingBanner != null) {
        final banner = existingBanner.copyWith(
          btnText: btnController.text,
          description: descriptionController.text,
          imageUrl: imageUrl,
          title: titleController.text,
          urlToLoad: urlController.text,
        );
        result = await _databaseRepositoryImpl.updateBanner(banner: banner);
      } else {
        final banner = model.BannerDetail(
          title: titleController.text,
          btnText: btnController.text,
          description: descriptionController.text,
          imageUrl: imageUrl ?? "",
          urlToLoad: urlController.text,
        );
        result = await _databaseRepositoryImpl.createBanner(banner: banner);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingBanner == null) {
          Messenger.showSnackbar("Banner Created ✅");
        } else {
          Messenger.showSnackbar("Updated Banner");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
