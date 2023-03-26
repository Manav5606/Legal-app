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

final _provider = ChangeNotifierProvider.autoDispose((ref) =>
    AddCategoryViewModel(ref.read(AppState.auth.notifier),
        ref.read(DatabaseRepositoryImpl.provider)));

class AddCategoryViewModel extends BaseViewModel {
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddCategoryViewModel(this._authProvider, this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddCategoryViewModel> get provider =>
      _provider;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? descriptionError;
  String? nameError;

  void clearError() {
    nameError = descriptionError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();

    if (nameController.text.isEmpty) {
      nameError = "Category name can't be empty.";
    }
    if (descriptionController.text.isEmpty) {
      descriptionError = "Category Description can't be empty.";
    }

    return nameError == null && descriptionError == null;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void initCategory(model.Category? categoryDetail) {
    if (categoryDetail != null) {
      nameController.text = categoryDetail.name;
      descriptionController.text = categoryDetail.description;
      notifyListeners();
    }
  }

  Future deactivateCategory(model.Category category) async {
    toggleLoadingOn(true);
    final result =
        await _databaseRepositoryImpl.deactivateCategory(category: category);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Category Deactivated");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createCategory(model.Category? existingCategory) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, Category> result;
      if (existingCategory != null) {
        final category = existingCategory.copyWith(
          name: nameController.text,
          description: descriptionController.text,
        );
        result =
            await _databaseRepositoryImpl.updateCategory(category: category);
      } else {
        final category = Category(
          name: nameController.text,
          iconUrl: "",
          description: descriptionController.text,
          addedBy: _authProvider.state.user!.id!,
        );
        result =
            await _databaseRepositoryImpl.createCategory(category: category);
      }

      return result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) {
        if (existingCategory == null) {
          Messenger.showSnackbar("Category Created ✅");
        } else {
          Messenger.showSnackbar("Updated Category");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
