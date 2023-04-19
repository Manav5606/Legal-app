import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerReview {
  String? id;
  final String title;
  final String review;
  final String name;
  final String designation;
  final String customerProfilePic;

  CustomerReview({
    this.id,
    required this.title,
    required this.review,
    required this.name,
    required this.designation,
    required this.customerProfilePic,
  });

  factory CustomerReview.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return CustomerReview(
      id: documentSnapshot.id,
      title: data['title'],
      review: data['review'],
      name: data['name'],
      designation: data['designation'],
      customerProfilePic: data['customer_profile_pic'],
    );
  }

  CustomerReview copyWith({
    String? title,
    String? review,
    String? name,
    String? designation,
    String? customerProfilePic,
  }) =>
      CustomerReview(
        id: id,
        title: title ?? this.title,
        review: review ?? this.review,
        name: name ?? this.name,
        designation: designation ?? this.designation,
        customerProfilePic: customerProfilePic ?? this.customerProfilePic,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "review": review,
        "name": name,
        "designation": designation,
        "customer_profile_pic": customerProfilePic,
      };
}
