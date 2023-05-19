import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUsForm {
  String? id;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String companyName;
  final String? email;
  final String notes;

  ContactUsForm({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.companyName,
    this.email,
    required this.notes,
  });

  factory ContactUsForm.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ContactUsForm(
      id: documentSnapshot.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      mobileNumber: data['mobileNumber'],
      companyName: data['companyName'],
      email: data['email'],
      notes: data['notes'],
    );
  }

  ContactUsForm copyWith({
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? companyName,
    String? email,
    String? notes,
  }) =>
      ContactUsForm(
        id: id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        companyName: companyName ?? this.companyName,
        email: email ?? this.email,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "companyName": companyName,
        "email": email,
        "notes": notes,
      };
}
