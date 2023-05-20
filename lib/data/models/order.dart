import 'package:admin/core/enum/order_status.dart';
import 'package:admin/data/models/service_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? id;
  final String? clientID;
  final int? createdAt;
  final OrderStatus? status;
  String? vendorID;
  final String? serviceID;
  final List<ServiceRequest>? orderServiceRequest;
  final String? transactionID;
  final String? serviceName;

  Order({
    this.id,
    this.createdAt,
    this.clientID,
    this.status,
    this.vendorID,
    this.serviceID,
    this.orderServiceRequest,
    this.transactionID,
    this.serviceName,
  });

  factory Order.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    return Order(
      id: documentSnapshot.id,
      createdAt: data['created_at'],
      clientID: data['client_id'],
      status: OrderStatus.values.firstWhere(
          (element) => element.name == data['status'],
          orElse: () => OrderStatus.created),
      vendorID: data['vendor_id'],
      serviceID: data['service_id'],
      orderServiceRequest: data['order_service_request'] == null
          ? []
          : (data['order_service_request'] as List)
              .map((e) => ServiceRequest.fromData(e as Map<String, dynamic>))
              .toList(),
      transactionID: data['transaction_id'],
      serviceName: data['serviceName'],
    );
  }

  Map<String, dynamic> toJson() => {
        "client_id": clientID,
        "status": status?.name,
        "vendor_id": vendorID,
        "service_id": serviceID,
        "order_service_request":
            orderServiceRequest?.map((e) => e.toOrderJson()).toList(),
        "transaction_id": transactionID,
        "serviceName": serviceName,
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
      };
}
