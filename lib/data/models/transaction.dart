import 'package:admin/core/enum/transaction_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transaction {
  String? id;
  final String userID;
  final int amount;
  final int createdAt;
  final int updatedAt;
  final Map<String, dynamic> successDetails;
  final TransactionStatus status;

  Transaction({
    this.id,
    required this.userID,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.successDetails,
    required this.status,
  });

  factory Transaction.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return Transaction(
      id: documentSnapshot.id,
      userID: data['user_id'],
      amount: data['amount'],
      createdAt: data['created_at'],
      updatedAt: data['updated_t'],
      successDetails: data['success_details'],
      status: data['status'],
    );
  }
}
