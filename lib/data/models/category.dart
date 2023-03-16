import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String iconUrl;
  final String description;
  final int addedAt;
  final String addedBy;

  Category({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
    required this.addedAt,
    required this.addedBy,
  });

  factory Category.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return Category(
        id: documentSnapshot.id,
        name: data['name'],
        iconUrl: data['icon_url'],
        description: data['description'],
        addedAt: data['added_at'],
        addedBy: data['added_by']);
  }
}
