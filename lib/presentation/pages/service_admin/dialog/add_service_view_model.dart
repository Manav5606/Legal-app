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
  final TextEditingController shortDescController = TextEditingController();
  final TextEditingController aboutDescController = TextEditingController();
  final TextEditingController marketPriceController = TextEditingController();
  final TextEditingController ourPriceController = TextEditingController();

  String? shortDescError;
  String? aboutDescError;
  String? marketPriceError;
  String? ourPriceError;

  void clearError() {
    shortDescError = aboutDescError = marketPriceError = ourPriceError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();

    if (shortDescController.text.isEmpty) {
      shortDescError = "Service description can't be empty.";
    }
    if (aboutDescController.text.isEmpty) {
      aboutDescError = "Service About can't be empty.";
    }
    if (marketPriceController.text.isNotEmpty &&
        double.tryParse(marketPriceController.text) == null) {
      marketPriceError = "Please enter a valid Price.";
    }
    if (ourPriceController.text.isNotEmpty &&
        double.tryParse(marketPriceController.text) == null) {
      ourPriceError = "Please enter a valid Price.";
    }

    return shortDescError == null &&
        aboutDescError == null &&
        marketPriceError == null &&
        ourPriceError == null;
  }

  @override
  void dispose() {
    shortDescController.dispose();
    aboutDescController.dispose();
    marketPriceController.dispose();
    ourPriceController.dispose();
    super.dispose();
  }

  void initService(model.Service? serviceDetail) {
    if (serviceDetail != null) {
      shortDescController.text = serviceDetail.shortDescription;
      aboutDescController.text = serviceDetail.aboutDescription;
      marketPriceController.text = (serviceDetail.marketPrice ?? 0).toString();
      ourPriceController.text = (serviceDetail.ourPrice ?? 0).toString();
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

  Future activateService(model.Service service) async {
    toggleLoadingOn(true);
    final result =
        await _databaseRepositoryImpl.activateService(service: service);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Service Activated");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createService(
      {model.Service? existingService,
      model.Service? parentService,
      required String categoryID}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, Service> result;
      if (existingService != null) {
        final service = existingService.copyWith(
          aboutDescription: aboutDescController.text,
          // categoryID: categoryID,
          // childServices: existingService.childServices,
          marketPrice: double.tryParse(marketPriceController.text),
          ourPrice: double.tryParse(ourPriceController.text),
          // isDeactivated: existingService.isDeactivated,
          shortDescription: shortDescController.text,
        );
        result = await _databaseRepositoryImpl.updateService(service: service);
      } else {
        final service = Service(
          aboutDescription: aboutDescController.text,
          categoryID: categoryID,
          childServices: [],
          createdBy: _authProvider.state.user!.id!,
          shortDescription: shortDescController.text,
          marketPrice: double.tryParse(marketPriceController.text),
          ourPrice: double.tryParse(ourPriceController.text),
          parentServiceID: parentService?.id,
        );
        result = await _databaseRepositoryImpl.createService(service: service);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingService == null) {
          Messenger.showSnackbar("Service Created ✅");
        } else {
          Messenger.showSnackbar("Updated Service");
        }
        if (parentService != null && existingService == null) {
          final _parentService = parentService.copyWith(
            childServices: [
              ...parentService.childServices,
              r.id!,
            ],
          );
          await _databaseRepositoryImpl.updateService(service: _parentService);
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
