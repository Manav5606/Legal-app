import 'package:admin/core/enum/field_type.dart';
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
    AddServiceRequestViewModel(ref.read(AppState.auth.notifier),
        ref.read(DatabaseRepositoryImpl.provider)));

class AddServiceRequestViewModel extends BaseViewModel {
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddServiceRequestViewModel(this._authProvider, this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddServiceRequestViewModel>
      get provider => _provider;
  final TextEditingController fieldNameController = TextEditingController();
  final TextEditingController fieldDescriptionController =
      TextEditingController();
  ServiceFieldType _selectedFieldType = ServiceFieldType.text;

  ServiceFieldType get getSelectedFieldType => _selectedFieldType;

  void setSelectedFieldType(ServiceFieldType type) {
    _selectedFieldType = type;
    notifyListeners();
  }

  String? fieldNameError;
  String? fieldDescriptionError;

  void clearError() {
    fieldNameError = null;
    fieldDescriptionError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();

    if (fieldNameController.text.isEmpty) {
      fieldNameError = "Field Name can't be empty.";
    }
    if (fieldDescriptionController.text.isEmpty) {
      fieldNameError = "Field Description can't be empty.";
    }

    return fieldNameError == null && fieldDescriptionError == null;
  }

  @override
  void dispose() {
    fieldNameController.dispose();
    super.dispose();
  }

  void initServiceRequest(model.ServiceRequest? serviceRequestDetail) {
    if (serviceRequestDetail != null) {
      fieldNameController.text = serviceRequestDetail.fieldName;
      fieldDescriptionController.text = serviceRequestDetail.fieldDescription;
      setSelectedFieldType(serviceRequestDetail.fieldType);
      notifyListeners();
    }
  }

  Future createNewServiceRequest({required String serviceID}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, ServiceRequest> result;

      final serviceRequest = ServiceRequest(
        fieldDescription: fieldDescriptionController.text,
        serviceID: serviceID,
        fieldName: fieldNameController.text,
        fieldType: _selectedFieldType,
        createdBy: _authProvider.state.user!.id!,
      );
      result = await _databaseRepositoryImpl.createNewServiceRequest(
          serviceRequest: serviceRequest);

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        Messenger.showSnackbar("Service Request Created ✅");
        toggleLoadingOn(false);
        return r;
      });
    }
  }

  Future removeServiceRequest(model.ServiceRequest serviceRequest) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deleteServiceRequest(
        id: serviceRequest.id!);

    return result.fold(
      (l) {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      },
      (r) {
        Messenger.showSnackbar("Service Request Deleted ✅");
        toggleLoadingOn(false);
        return r;
      },
    );
  }
}
