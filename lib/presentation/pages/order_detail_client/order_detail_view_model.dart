import 'package:admin/core/provider.dart';
import 'package:admin/core/state/auth_state.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cross_file/cross_file.dart';
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
  User? user;
  Service? service;
  bool fileloading = false;

  Future<void> initOrderDetails({required String orderId}) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getOrderById(orderId: orderId);

    await res.fold((l) => null, (r) async {
      order = r;
      user = _authState.user;
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

  Future<String?> uploadFile({required XFile file}) async {
    try {
      fileloading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: user!.id!);
      return downloadUrl;
    } catch (_) {
    } finally {
      fileloading = false;
      notifyListeners();
    }
  }

  Future<void> saveServiceRequestData(
      {required ServiceRequest service,
      required ServiceRequest oldService}) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.saveOrderServiceRequestData(
      orderId: order!.id!,
      newService: service,
      oldService: oldService,
    );

    res.fold((l) => null, (r) {
      initOrderDetails(orderId: order!.id!);
    });
    toggleLoadingOn(false);
    notifyListeners();
  }
}
