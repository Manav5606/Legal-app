import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/vendor.dart';
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
  String? profilePic;
  Vendor? vendor;

  User({
    this.id,
    this.isDeactivated = false,
    this.createdAt,
    required this.name,
    required this.userType,
    this.createdBy,
    required this.email,
    required this.phoneNumber,
    this.vendor,
    this.profilePic,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = (snapshot.data() as Map<String, dynamic>);
    return User(
      id: snapshot.id,
      createdAt: data['created_at'],
      profilePic: data['profile_pic'],
      name: data['name'],
      createdBy: data['created_by'],
      userType: UserType.values.firstWhere(
          (element) => element.name == data['user_type'],
          orElse: () => UserType.client),
      email: data['email'],
      phoneNumber: data['phone_number'],
      isDeactivated: data['is_deactivated'] ?? false,
    );
  }

  User copyWith({
    Vendor? vendor,
    String? name,
    UserType? userType,
    String? email,
    String? profilePic,
    int? phoneNumber,
    bool? isDeactivated,
  }) =>
      User(
          name: name ?? this.name,
          userType: userType ?? this.userType,
          email: email ?? this.email,
          profilePic: profilePic ?? this.profilePic,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          vendor: vendor ?? this.vendor,
          isDeactivated: isDeactivated ?? this.isDeactivated,
          createdAt: createdAt,
          createdBy: createdBy,
          id: id);

  Map<String, dynamic> toJson() => {
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
        "name": name,
        "created_by": createdBy,
        "profile_pic": profilePic,
        "user_type": userType.name,
        "email": email,
        "phone_number": phoneNumber,
        "is_deactivated": isDeactivated,
      };
}
