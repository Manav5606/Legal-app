import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String? id;
  String? userId;
  bool isRead;
  String? message;
  final String type;
  String? orderId;
  String? serviceId;
  Timestamp? createdAt;

  Notification({
    this.id,
    this.isRead = false,
    this.createdAt,
    required this.type,
    this.userId,
    required this.orderId,
    required this.serviceId,
    this.message,
  });

  factory Notification.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = (snapshot.data() as Map<String, dynamic>);
    return Notification(
      id: snapshot.id,
      userId: data['userId'],
      isRead: data['isRead'] ?? false,
      message: data['message'],
      type: data['type'],
      orderId: data['orderId'],
      serviceId: data['serviceId'],
      createdAt: data['createdAt'],
    );
  }

  Notification copyWith({
    String? userId,
    bool? isRead,
    String? orderId,
    String? serviceId,
    String? type,
    String? message,
  }) =>
      Notification(
          userId: userId,
          isRead: isRead ?? this.isRead,
          message: message ?? this.message,
          type: type ?? this.type,
          createdAt: createdAt,
          orderId: orderId ?? this.orderId,
          serviceId: serviceId ?? this.serviceId,
          id: id);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "isRead": isRead,
        "message": message,
        "type": type,
        "orderId": orderId,
        "serviceId": serviceId,
        "createdAt": createdAt ?? DateTime.now().millisecondsSinceEpoch,
      };

 
}
