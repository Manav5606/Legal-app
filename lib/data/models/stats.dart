import 'package:cloud_firestore/cloud_firestore.dart';

class Stats {
  String? id;
  final String title;
  final String description;

  Stats({
    this.id,
    required this.title,
    required this.description,
  });

  factory Stats.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return Stats(
      id: documentSnapshot.id,
      title: data['title'],
      description: data['description'],
    );
  }

  Stats copyWith({
    String? title,
    String? description,
  }) =>
      Stats(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
