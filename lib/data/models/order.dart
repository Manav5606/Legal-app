import 'package:admin/core/enum/order_status.dart';
import 'package:admin/data/models/service_request.dart';

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
}
