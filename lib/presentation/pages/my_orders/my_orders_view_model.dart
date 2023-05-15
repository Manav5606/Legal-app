import 'package:admin/core/enum/order_status.dart';
import 'package:admin/core/enum/transaction_status.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/state/auth_state.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider((ref) => MyOrdersPageViewModel(
    ref.read(Repository.database), ref.read(AppState.auth)));

class MyOrdersPageViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  final AuthState _authState;

  MyOrdersPageViewModel(this._databaseRepositoryImpl, this._authState);

  static ChangeNotifierProvider<MyOrdersPageViewModel> get provider =>
      _provider;

  final List<Order> _myOrders = [];
  final List<Category> _contacts = [];

  List<Order> get getMyOrders => _myOrders;
   List<Category> get getContacts => _contacts;

  Future<void> initMyOrders() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getAllOrdersOfClient(
        clientId: _authState.user!.id!);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      _myOrders.clear();
      _myOrders.addAll(r);
      notifyListeners();
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchContacts() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getContactDetails();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _contacts.clear();
      _contacts.addAll(r.where((e) => !e.isDeactivated).toList()
        ..sort((a, b) => a.name.compareTo(b.name)));
    });
    toggleLoadingOn(false);
  }

  Future<void> updateOrder({
    required String orderId,
    required String transactionId,
  }) async {
    // toggleLoadingOn(true);
    // final user = _ref.read(AppState.auth).user;
    // if (user == null) {
    //   Messenger.showSnackbar("User is not authenticated");
    //   return;
    // }
    // final Order order = Order(
    //   id: orderId,
    //   clientID: user.id!,
    //   status: OrderStatus.created,
    //   vendorID: null,
    //   serviceID: selectedService!.id!,
    //   orderServiceRequest: [],
    //   transactionID: transactionId,
    // );
    // final res = await _databaseRepositoryImpl.createOrder(order: order);
    // await res.fold((l) {
    //   Messenger.showSnackbar(l.message);
    //   toggleLoadingOn(false);
    // }, (r) async {
    //   Messenger.showSnackbar("Order Purchased and Created ✅");
    //   toggleLoadingOn(false);
    // });
  }
}
