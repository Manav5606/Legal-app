import 'package:admin/core/enum/role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final int createdAt;
  final String name;
  final Role role;
  final String email;
  final int phoneNumber;
  final String? categoryId;
  final String? groupId;
  final String? typeId;
  final String? headingId;

  User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.role,
    required this.email,
    required this.phoneNumber,
    this.categoryId,
    this.groupId,
    this.typeId,
    this.headingId,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = (snapshot.data() as Map<String, dynamic>);
    return User(
      id: snapshot.id,
      createdAt: data['createdAt'],
      name: data['name'],
      role: data['role'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
    );
  }
}
