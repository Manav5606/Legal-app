import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Service {
  final String id;
  final String shortDescription;
  final String aboutDescription;
  final double marketPrice;
  final double ourPrice;
  final String? parentServiceID;
  final List<String> childServices;
  final String categoryID;
  final int createdAt;
  final String createdBy;

  Service({
    required this.id,
    required this.shortDescription,
    required this.aboutDescription,
    required this.marketPrice,
    required this.ourPrice,
    required this.parentServiceID,
    required this.childServices,
    required this.categoryID,
    required this.createdAt,
    required this.createdBy,
  });

  factory Service.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return Service(
      id: documentSnapshot.id,
      shortDescription: data['short_description'],
      aboutDescription: data['about_description'],
      marketPrice: data['market_price'],
      ourPrice: data['our_rice'],
      parentServiceID: data['parent_service_id'],
      childServices: data['child_services'],
      categoryID: data['category_id'],
      createdAt: data['created_at'],
      createdBy: data['created_by'],
    );
  }
}
