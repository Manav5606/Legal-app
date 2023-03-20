import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  int? createdAt;
  String? createdBy;
  final String name;
  final UserType userType;
  final String email;
  final int phoneNumber;
  bool isDeactivated;
  Client? client;

  User({
    this.id,
    this.isDeactivated = false,
    this.createdAt,
    required this.name,
    required this.userType,
    this.createdBy,
    required this.email,
    required this.phoneNumber,
    this.client,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = (snapshot.data() as Map<String, dynamic>);
    return User(
      id: snapshot.id,
      createdAt: data['created_at'],
      name: data['name'],
      createdBy: data['created_by'],
      userType: UserType.values.firstWhere(
          (element) => element.name == data['user_type'],
          orElse: () => UserType.user),
      email: data['email'],
      phoneNumber: data['phone_number'],
      isDeactivated: data['is_deactivated'] ?? false,
    );
  }

  User copyWith({
    Client? client,
    String? name,
    UserType? userType,
    String? email,
    int? phoneNumber,
    bool? isDeactivated,
  }) =>
      User(
          name: name ?? this.name,
          userType: userType ?? this.userType,
          email: email ?? this.email,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          client: client ?? this.client,
          isDeactivated: isDeactivated ?? this.isDeactivated,
          createdAt: createdAt,
          createdBy: createdBy,
          id: id);

  Map<String, dynamic> toJson() => {
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
        "name": name,
        "created_by": createdBy,
        "user_type": userType.name,
        "email": email,
        "phone_number": phoneNumber,
        "is_deactivated": isDeactivated,
      };
}
