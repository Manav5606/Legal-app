import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String? id;
  final String name;
  final String iconUrl;
  final String description;
  final int? addedAt;
  final String addedBy;
  final String? detail;
  final bool isDeactivated;

  Category({
    this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
    this.detail,
    this.addedAt,
    required this.addedBy,
    this.isDeactivated = false,
  });

  factory Category.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return Category(
      id: documentSnapshot.id,
      name: data['name'],
      iconUrl: data['icon_url'],
      description: data['description'],
      detail: data['detail'],
      addedAt: data['added_at'],
      addedBy: data['added_by'],
      isDeactivated: data['is_deactivated'],
    );
  }

  Category copyWith({
    String? name,
    String? iconUrl,
    String? description,
    String? detail,
    bool? isDeactivated,
  }) =>
      Category(
        id: id,
        name: name ?? this.name,
        iconUrl: iconUrl ?? this.iconUrl,
        description: description ?? this.description,
        detail: detail ?? this.detail,
        addedAt: addedAt,
        addedBy: addedBy,
        isDeactivated: isDeactivated ?? this.isDeactivated,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon_url": iconUrl,
        "detail": detail,
        "description": description,
        "added_at": addedAt ?? DateTime.now().millisecondsSinceEpoch,
        "added_by": addedBy,
        "is_deactivated": isDeactivated,
      };
}
