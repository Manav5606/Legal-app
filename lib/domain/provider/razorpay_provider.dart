import 'dart:convert';
import 'dart:developer';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/presentation/pages/service_info/service_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:http/http.dart' as http;

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => RazorpayHandler(Razorpay(), ref));

class RazorpayEndpoints {
  static const String _baseUrl = "https://api.razorpay.com/v1";
  static const String orders = "$_baseUrl/orders";
}

class RazorpayHandler extends ChangeNotifier {
  final Razorpay _razorpay;
  final Ref ref;

  static const String _razorpayKey = "rzp_test_7kmGcQMmAYNHNz";
  static const String _razorpayPass = "e28QGirfeM2aWL7lM0NLqvMB";

  RazorpayHandler(this._razorpay, this.ref) {
    _initRazorPay();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  static AutoDisposeChangeNotifierProvider<RazorpayHandler> get provider =>
      _provider;

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await ref
        .read(ServiceInfoPageViewModel.provider)
        .createTransaction(rpData: {
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log(response.message ?? "");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log(response.walletName ?? "");
  }

  void _initRazorPay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  Future<bool> openCheckoutPage({
    required int amount,
    required String contact,
    required String email,
    String? description,
    String? name = "Legal App",
  }) async {
    final String? orderID = await _createOrder(amount: amount);

    if (orderID == null) {
      Messenger.showSnackbar("Failed to create order. Try again later.");
      return false;
    }

    Map<String, dynamic> options = {
      "key": _razorpayKey,
      "amount": amount,
      "name": name,
      "order_id": orderID,
      "description": description ?? "",
      "timeout": 60 * 5,
      "prefill": {
        "contact": contact,
        "email": email,
      }
    };

    _razorpay.open(options);
    return true;
  }

  Future<String?> _createOrder({required int amount}) async {
    http.Client client = http.Client();
    String? orderId;
    try {
      final basicAuth =
          "Basic ${base64.encode(utf8.encode("$_razorpayKey:$_razorpayPass"))}";
      final response =
          await client.post(Uri.parse(RazorpayEndpoints.orders), headers: {
        "authorization": basicAuth
      }, body: {
        "amount": (amount).toInt().toString(),
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
