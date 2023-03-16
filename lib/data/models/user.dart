import 'package:admin/core/enum/role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final int createdAt;
  final String createdBy;
  final String name;
  final UserType userType;
  final String email;
  final int phoneNumber;

  User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.userType,
    required this.createdBy,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = (snapshot.data() as Map<String, dynamic>);
    return User(
      id: snapshot.id,
      createdAt: data['created_at'],
      name: data['name'],
      createdBy: data['created_by'],
      userType: data['user_type'],
      email: data['email'],
      phoneNumber: data['phone_number'],
    );
  }
}
