import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  String? id;
  final String title;
  final String description;
  final int? createdAt;

  News({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory News.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    final timestamp = data['created_at'] as Timestamp;
    return News(
      id: documentSnapshot.id,
      title: data['title'],
      description: data['description'],
      createdAt: timestamp.seconds,
    );
  }

  News copyWith({
    String? title,
    String? description,
  }) =>
      News(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "created_at": createdAt ?? DateTime.now(),
      };
}
