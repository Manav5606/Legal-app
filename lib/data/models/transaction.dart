import 'package:admin/core/enum/transaction_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String? id;
  final String userID;
  final double amount;
  final int createdAt;
  final Map<String, dynamic> successDetails;
  final TransactionStatus status;
  final String serviceId;

  Transaction({
    this.id,
    required this.userID,
    required this.amount,
    required this.createdAt,
    required this.successDetails,
    required this.status,
    required this.serviceId,
  });

  factory Transaction.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return Transaction(
      id: documentSnapshot.id,
      userID: data['user_id'],
      amount: data['amount'],
      createdAt: data['created_at'],
      serviceId: data['service_id'],
      successDetails: data['success_details'],
      status: TransactionStatus.values.firstWhere(
          (element) => element.name == data['status'],
          orElse: () => TransactionStatus.fail),
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userID,
        "amount": amount,
        "created_at": createdAt,
        "service_id": serviceId,
        "success_details": successDetails,
        "status": status.name,
      };
}
