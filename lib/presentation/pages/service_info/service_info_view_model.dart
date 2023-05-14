import 'dart:convert';

import 'package:admin/core/enum/order_status.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/core/enum/transaction_status.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/domain/provider/razorpay_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/enum/notification.dart';

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

  Future<void> createNotification(
      String userId, String meesage, String type, String orderId,String serviceId) async {
    toggleLoadingOn(true);
    final user = _ref.read(AppState.auth).user;
    if (user == null) {
      Messenger.showSnackbar("User is not authenticated");
      return;
    }
    final Notification notification = Notification(
      userId: userId,
      isRead: false,
      message: meesage,
      type: type,
      orderId: orderId,
      serviceId: serviceId,
      createdAt: firestore.Timestamp.fromDate(DateTime.now()),
    );
    final res = await _databaseRepositoryImpl.createNotifications(
        notifications: notification);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      sendPushNotification(meesage);
      Messenger.showSnackbar("Notification Sent Succesfully ✅");
      toggleLoadingOn(false);
    });
  }

  static Future<void> sendPushNotification(String msg) async {
    final userRef = await firestore.FirebaseFirestore.instance
        .collection('user')
        .where('user_type', isEqualTo: UserType.admin.name)
        .get();

    final userData = userRef.docs.first.data();

    if (userData != null) {
      final pushToken = userData['pushToken'];

      final body = {
        // "to": users.map((user) => user.pushToken).toList(),
        "to": pushToken,
        "notification": {
          "title": "You have new notfication from $msg",
          "body": "Notification brief is written here...",
        },
        "data": {
          "route": "/chat_view", // include the route name
          "orderId": "9UdECrXq3aosqie1BdQ2",
        }
      };
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAsdVuN_0:APA91bH23hJVe9f3x_WUUiitRwWOuA9XVDSx1DTowKoZ3fZWFhQDIZ864oPwX90VHOoj_3z_6jlJp8XPiiBkOIwLBKz2pknnvWvYzvbOvFOz1HH_9S_wpePVBcVIyXGKG6CUdqcGDa3X',
        },
        body: json.encode(body),
      );
    }
  }

  Future<String?> createTransaction(
      {required Map<String, dynamic> rpData}) async {
    toggleLoadingOn(true);
    final user = _ref.read(AppState.auth).user;
    if (user == null) {
      Messenger.showSnackbar("User is not authenticated");
      return null;
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
    return await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) async {
      // TODO orderId is received from RazorPay
      final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      await createOrderOnServer(
        orderId: orderId,
        transactionId: r.id!,
      );
      return orderId;
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
      orderServiceRequest: getRequiredDataFields,
      transactionID: transactionId,
    );
    final res = await _databaseRepositoryImpl.createOrder(order: order);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      await createNotification(
          user.id!, user.name, NotificationType.private.name, r.id!,r.serviceID!);
      Messenger.showSnackbar("Order Purchased and Created ✅");
      toggleLoadingOn(false);
    });
  }
}
