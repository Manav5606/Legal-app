import 'package:cloud_firestore/cloud_firestore.dart';

class BannerDetail {
  String? id;
  final String title;
  final String description;
  final String imageUrl;
  final String btnText;
  final String urlToLoad;

  BannerDetail({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.btnText,
    required this.urlToLoad,
  });

  factory BannerDetail.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return BannerDetail(
      id: documentSnapshot.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['image_url'],
      btnText: data['btn_text'],
      urlToLoad: data['url_to_load'],
    );
  }

  BannerDetail copyWith({
    String? title,
    String? description,
    String? imageUrl,
    String? btnText,
    String? urlToLoad,
  }) =>
      BannerDetail(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        btnText: btnText ?? this.btnText,
        urlToLoad: urlToLoad ?? this.urlToLoad,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "btn_text": btnText,
        "url_to_load": urlToLoad,
      };
}
