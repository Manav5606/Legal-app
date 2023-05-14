import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String? id;
  final String title;
  final String shortDescription;
  final String aboutDescription;
  final double? marketPrice;
  final double? ourPrice;
  final String? parentServiceID;
  final List<String> childServices;
  final String categoryID;
  final int? createdAt;
  final String createdBy;
  final bool isDeactivated;

  Service({
    this.id,
    required this.title,
    required this.shortDescription,
    required this.aboutDescription,
    this.marketPrice,
    this.ourPrice,
    this.parentServiceID,
    required this.childServices,
    required this.categoryID,
    this.createdAt,
    this.isDeactivated = false,
    required this.createdBy,
  });

  factory Service.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return Service(
      id: documentSnapshot.id,
      title: data['title'] ??
          data['short_description'], // Remove this null check later
      shortDescription: data['short_description'],
      aboutDescription: data['about_description'],
      marketPrice: double.tryParse(data['market_price'].toString()),
      ourPrice: double.tryParse(data['our_price'].toString()),
      parentServiceID: data['parent_service_id'],
      childServices: List<String>.from(data['child_services']),
      categoryID: data['category_id'],
      createdAt: data['created_at'],
      createdBy: data['created_by'],
      isDeactivated: data['is_deactivated'],
    );
  }

  Service copyWith({
    String? shortDescription,
    String? aboutDescription,
    String? title,
    double? marketPrice,
    double? ourPrice,
    List<String>? childServices,
    String? categoryID,
    bool? isDeactivated,
  }) =>
      Service(
        isDeactivated: isDeactivated ?? this.isDeactivated,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
        aboutDescription: aboutDescription ?? this.aboutDescription,
        childServices: childServices ?? this.childServices,
        categoryID: categoryID ?? this.categoryID,
        id: id,
        createdBy: createdBy,
        createdAt: createdAt,
        marketPrice: marketPrice ?? this.marketPrice,
        ourPrice: ourPrice ?? this.ourPrice,
        parentServiceID: parentServiceID,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "is_deactivated": isDeactivated,
        "short_description": shortDescription,
        "about_description": aboutDescription,
        "market_price": marketPrice,
        "our_price": ourPrice,
        "parent_service_id": parentServiceID,
        "child_services": childServices,
        "category_id": categoryID,
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
        "created_by": createdBy,
      };
}
