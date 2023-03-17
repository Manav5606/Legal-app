import 'package:cloud_firestore/cloud_firestore.dart';

class BannerDetail {
  String? id;
  final String title;
  final String description;
  final String imageUrl;
  final String btnText;

  BannerDetail({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.btnText,
  });

  factory BannerDetail.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return BannerDetail(
      id: documentSnapshot.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['image_url'],
      btnText: data['btn_text'],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "btn_text": btnText,
      };
}
