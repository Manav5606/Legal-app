import 'package:admin/core/enum/order_status.dart';
import 'package:admin/data/models/service_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? id;
  final String? userID;
  final int? createdAt;
  final OrderStatus? status;
  String? clientID;
  final String? serviceID;
  final List<ServiceRequest>? orderServiceRequest;
  final String? transactionID;

  Order({
    this.id,
    this.createdAt,
    this.userID,
    this.status,
    this.clientID,
    this.serviceID,
    this.orderServiceRequest,
    this.transactionID,
  });

  factory Order.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    return Order(
      id: documentSnapshot.id,
      createdAt: data['created_at'],
      userID: data['user_id'],
      status: OrderStatus.values.firstWhere(
          (element) => element.name == data['status'],
          orElse: () => OrderStatus.created),
      clientID: data['client_id'],
      serviceID: data['service_id'],
      orderServiceRequest: data['order_service_request'] == null
          ? []
          : (data['order_service_request'] as List)
              .map((e) => ServiceRequest.fromData(e as Map<String, dynamic>))
              .toList(),
      transactionID: data['transaction_id'],
    );
  }

  // Order copyWith({
  //   OrderStatus? status,
  //   String? client_id
  // }) =>
  //     Order(
  //       clientID: clientID,
  //       status: status ?? this.status, id: id
  //     );

  Map<String, dynamic> toJson() => {
        "user_id": userID,
        "status": status?.name,
        "client_id": clientID,
        "service_id": serviceID,
        "order_service_request":
            orderServiceRequest?.map((e) => e.toJson()).toList(),
        "transaction_id": transactionID,
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
      };
}
