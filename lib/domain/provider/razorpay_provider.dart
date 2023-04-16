import 'dart:convert';
import 'dart:developer';

import 'package:admin/core/utils/messenger.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:http/http.dart' as http;

final _provider =
    ChangeNotifierProvider.autoDispose((ref) => RazorpayHandler(Razorpay()));

class RazorpayEndpoints {
  static const String _baseUrl = "https://api.razorpay.com/v1";
  static const String orders = "$_baseUrl/orders";
}

class RazorpayHandler extends ChangeNotifier {
  final Razorpay _razorpay;

  static const String _razorpayKey = "rzp_test_7kmGcQMmAYNHNz";
  static const String _razorpayPass = "e28QGirfeM2aWL7lM0NLqvMB";

  RazorpayHandler(this._razorpay) {
    _initRazorPay();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  static AutoDisposeChangeNotifierProvider<RazorpayHandler> get provider =>
      _provider;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // TODO store this values on Firebase
//     {
//   "razorpay_payment_id": "pay_29QQoUBi66xm2f",
//   "razorpay_order_id": "order_9A33XWu170gUtm",
//   "razorpay_signature": "9ef4dffbfd84f1318f6739a3ce19f9d85851857ae648f114332d8401e0949a3d"
// }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void _initRazorPay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  Future openCheckoutPage({
    required num amount,
    required String contact,
    required String email,
    String? description,
    String? name = "Legal App",
  }) async {
    final String? orderID = await createOrder(amount: amount);

    if (orderID == null) {
      Messenger.showSnackbar("Failed to create order. Try again later.");
    }
    Map<String, dynamic> options = {
      "key": _razorpayKey,
      "amount": amount * 100,
      "name": name,
      "order_id": orderID,
      "description": description ?? "",
      "timeout": 60,
      "prefill": {
        "contact": contact,
        "email": email,
      }
    };

    // _razorpay.open(options);
  }

  Future<String?> createOrder({required num amount}) async {
    http.Client client = http.Client();
    String? orderId;
    try {
      final basicAuth =
          "Basic ${base64.encode(utf8.encode("$_razorpayKey:$_razorpayPass"))}";
      final response =
          await client.post(Uri.parse(RazorpayEndpoints.orders), headers: {
        "authorization": basicAuth
      }, body: {
        "amount": amount * 100,
        "currency": "INR",
      });

      if (response.statusCode == 200) {
        orderId = jsonDecode(response.body)['id'];
      }
    } catch (e) {
      log(e.toString());
    }
    return orderId;
  }
}
