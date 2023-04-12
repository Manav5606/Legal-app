import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose((ref) =>
    ManageServiceRequestViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class ManageServiceRequestViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  ManageServiceRequestViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<ManageServiceRequestViewModel>
      get provider => _provider;

  List<ServiceRequest> _serviceRequests = [];

  List<ServiceRequest> get getServiceRequests => _serviceRequests;

  Future getAllServiceRequests({required String serviceID}) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getServiceRequestByServiceId(
        serviceId: serviceID);
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _serviceRequests = r;
      toggleLoadingOn(false);
    });
  }
}
