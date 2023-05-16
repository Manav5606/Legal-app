import 'package:cloud_firestore/cloud_firestore.dart';

class NewsImage {
  String? id;
 
  final String imageUrl;


  NewsImage({
    this.id,
   
    required this.imageUrl,

  });

  factory NewsImage.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return NewsImage(
      id: documentSnapshot.id,
     
      imageUrl: data['image_url'],

    );
  }

  NewsImage copyWith({
  
    String? imageUrl,

  }) =>
      NewsImage(
        id: id,
      
        imageUrl: imageUrl ?? this.imageUrl,
     
      );

  Map<String, dynamic> toJson() => {
      
        "image_url": imageUrl,
     
      };
}
