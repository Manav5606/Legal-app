import 'package:admin/core/provider.dart';
import 'package:admin/core/state/auth_state.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose((ref) =>
    OrderDetailViewModel(
        ref.read(Repository.database), ref.read(AuthService.provider)));

class OrderDetailViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  final AuthState _authState;

  static AutoDisposeChangeNotifierProvider<OrderDetailViewModel> get provider =>
      _provider;

  OrderDetailViewModel(this._databaseRepositoryImpl, this._authState);

  Order? order;
  Vendor? vendor;
  late User user;
  late Service service;

  Future<void> initOrderDetails({required String orderId}) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getOrderById(orderId: orderId);

    await res.fold((l) => null, (r) async {
      order = r;
      user = _authState.user!;
      if (order?.vendorID != null) {
        final res = await _databaseRepositoryImpl.getVendorById(
            vendorId: order!.vendorID!);
        await res.fold((l) => null, (r) async {
          vendor = r;
        });
      }
      if (order?.serviceID != null) {
        final res = await _databaseRepositoryImpl.getServiceByID(
            serviceId: order!.serviceID!);
        await res.fold((l) => null, (r) async {
          service = r;
        });
      }
    });
    toggleLoadingOn(false);
  }
}
