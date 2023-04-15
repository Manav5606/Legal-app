import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider(
    (ref) => ServiceInfoPageViewModel(ref.read(Repository.database)));

class ServiceInfoPageViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  ServiceInfoPageViewModel(this._databaseRepositoryImpl);

  static ChangeNotifierProvider<ServiceInfoPageViewModel> get provider =>
      _provider;

  Service? selectedService;

  final List<ServiceRequest> _requiredDataFields = [];

  List<ServiceRequest> get getRequiredDataFields => _requiredDataFields;

  Future<void> initServiceInfo(String serviceId) async {
    toggleLoadingOn(true);
    final res =
        await _databaseRepositoryImpl.getServiceByID(serviceId: serviceId);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      selectedService = r;
      notifyListeners();
      await _getServiceReqByServiceID(serviceId);
    });
    toggleLoadingOn(false);
  }

  Future<void> _getServiceReqByServiceID(String serviceId) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getServiceRequestByServiceId(
        serviceId: serviceId);
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _requiredDataFields.clear();
      _requiredDataFields.addAll(r);
    });
    toggleLoadingOn(false);
  }
}
