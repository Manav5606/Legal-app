import 'package:admin/core/enum/order_status.dart';
import 'package:admin/core/enum/transaction_status.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/domain/provider/razorpay_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider((ref) => ServiceInfoPageViewModel(
    ref.read(Repository.database), ref.read(RazorpayHandler.provider), ref));

class ServiceInfoPageViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  final RazorpayHandler _razorpayHandler;
  final Ref _ref;

  ServiceInfoPageViewModel(
      this._databaseRepositoryImpl, this._razorpayHandler, this._ref);

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

  Future<void> createPurchase() async {
    if (selectedService == null) {
      Messenger.showSnackbar("Please Select Service to Buy!");
      return;
    }
    toggleLoadingOn(true);
    final user = _ref.read(AppState.auth).user;
    if (user == null) {
      Messenger.showSnackbar("User is not authenticated");
      return;
    }
    final res = await _razorpayHandler.openCheckoutPage(
      amount: ((selectedService!.ourPrice ?? 0) * 100).toInt(),
      contact: "91${user.phoneNumber}",
      email: user.email,
      description: selectedService!.shortDescription,
    );

    if (!res) {
      toggleLoadingOn(false);
    }
  }

  Future<void> createTransaction({required Map<String, dynamic> rpData}) async {
    toggleLoadingOn(true);
    final user = _ref.read(AppState.auth).user;
    if (user == null) {
      Messenger.showSnackbar("User is not authenticated");
      return;
    }
    final Transaction transaction = Transaction(
      userID: user.id!,
      amount: (selectedService!.ourPrice!) * 100,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      successDetails: rpData,
      status: TransactionStatus.success,
      serviceId: selectedService!.id!,
    );
    final res = await _databaseRepositoryImpl.createTransaction(
        transaction: transaction);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      // TODO orderId is received from RazorPay
      await createOrderOnServer(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        transactionId: r.id!,
      );
    });
  }

  Future<void> createOrderOnServer({
    required String orderId,
    required String transactionId,
  }) async {
    toggleLoadingOn(true);
    final user = _ref.read(AppState.auth).user;
    if (user == null) {
      Messenger.showSnackbar("User is not authenticated");
      return;
    }
    final Order order = Order(
      id: orderId,
      clientID: user.id!,
      status: OrderStatus.created,
      vendorID: null,
      serviceID: selectedService!.id!,
      orderServiceRequest: [],
      transactionID: transactionId,
    );
    final res = await _databaseRepositoryImpl.createOrder(order: order);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      Messenger.showSnackbar("Order Purchased and Created ✅");
      toggleLoadingOn(false);
    });
  }
}
