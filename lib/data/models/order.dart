import 'package:admin/core/enum/order_status.dart';
import 'package:admin/data/models/service_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userID;
  final OrderStatus status;
  final String? clientID;
  final String serviceID;
  final List<ServiceRequest> orderServiceRequest;
  final String transactionID;

  Order({
    required this.id,
    required this.userID,
    required this.status,
    required this.clientID,
    required this.serviceID,
    required this.orderServiceRequest,
    required this.transactionID,
  });

  factory Order.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    return Order(
      id: documentSnapshot.id,
      userID: data['user_id'],
      status: OrderStatus.values.firstWhere(
          (element) => element.name == data['status'],
          orElse: () => OrderStatus.created),
      clientID: data['client_id'],
      serviceID: data['service_id'],
      orderServiceRequest: data['order_service_request'] == null
          ? []
          : (data['order_service_request'] as List<Map<String, dynamic>>)
              .map((e) => ServiceRequest.fromData(e))
              .toList(),
      transactionID: data['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userID,
        "status": status.name,
        "client_id": clientID,
        "service_id": serviceID,
        "order_service_request":
            orderServiceRequest.map((e) => e.toJson()).toList(),
        "transaction_id": transactionID,
      };
}
