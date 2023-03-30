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
    AddServiceViewModel(ref.read(AppState.auth.notifier),
        ref.read(DatabaseRepositoryImpl.provider)));

class AddServiceViewModel extends BaseViewModel {
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddServiceViewModel(this._authProvider, this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddServiceViewModel> get provider =>
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
      nameError = "Service name can't be empty.";
    }
    if (descriptionController.text.isEmpty) {
      descriptionError = "Service Description can't be empty.";
    }

    return nameError == null && descriptionError == null;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void initService(model.Service? serviceDetail) {
    if (serviceDetail != null) {
      nameController.text = serviceDetail.name;
      descriptionController.text = serviceDetail.description;
      notifyListeners();
    }
  }

  Future deactivateService(model.Service service) async {
    toggleLoadingOn(true);
    final result =
        await _databaseRepositoryImpl.deactivateService(service: service);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Service Deactivated");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createService(model.Service? existingService) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, Service> result;
      if (existingService != null) {
        final service = existingService.copyWith(
          name: nameController.text,
          description: descriptionController.text,
        );
        result = await _databaseRepositoryImpl.updateService(service: service);
      } else {
        final service = Service(
          name: nameController.text,
          iconUrl: "",
          description: descriptionController.text,
          addedBy: _authProvider.state.user!.id!,
        );
        result = await _databaseRepositoryImpl.createService(service: service);
      }

      return result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) {
        if (existingService == null) {
          Messenger.showSnackbar("Service Created ✅");
        } else {
          Messenger.showSnackbar("Updated Service");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
