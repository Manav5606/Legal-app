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
    ManageServiceRequestViewModel(ref.read(AppState.auth.notifier),
        ref.read(DatabaseRepositoryImpl.provider)));

class ManageServiceRequestViewModel extends BaseViewModel {
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  ManageServiceRequestViewModel(
      this._authProvider, this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<ManageServiceRequestViewModel>
      get provider => _provider;
  final TextEditingController fieldNameController = TextEditingController();

  ServiceFieldType _selectedFieldType = ServiceFieldType.text;

  ServiceFieldType get getSelectedFieldType => _selectedFieldType;

  final List<ServiceRequest> _serviceRequests = [];

  List<ServiceRequest> get getServiceRequests => _serviceRequests;

  void setSelectedFieldType(ServiceFieldType type) {
    _selectedFieldType = type;
    notifyListeners();
  }

  String? fieldNameError;

  void clearError() {
    fieldNameError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();

    if (fieldNameController.text.isEmpty) {
      fieldNameError = "Field Name can't be empty.";
    }

    return fieldNameError == null;
  }

  @override
  void dispose() {
    fieldNameController.dispose();
    super.dispose();
  }

  void initServiceRequest(model.ServiceRequest? serviceRequestDetail) {
    if (serviceRequestDetail != null) {
      fieldNameController.text = serviceRequestDetail.fieldName;
      setSelectedFieldType(serviceRequestDetail.fieldType);
      notifyListeners();
    }
  }

  Future getAllServiceRequests({required String serviceID}) async {
    try {
      toggleLoadingOn(true);
      // TODO get all service requests for specified serviceID
    } catch (_) {
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future createNewServiceRequest({required String serviceID}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, ServiceRequest> result;

      final serviceRequest = ServiceRequest(
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
}
