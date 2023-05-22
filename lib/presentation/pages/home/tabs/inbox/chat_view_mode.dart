import 'dart:convert';

import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/firebase_config.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => ChatViewModel(ref.read(Repository.database)));

class ChatViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  bool sortAscending = false;
  int sortIndex = 0;
  ChatViewModel(this._databaseRepositoryImpl) {
    fetchOrders();
  }

  static AutoDisposeChangeNotifierProvider<ChatViewModel> get provider =>
      _provider;

  String? error;

  List<Order> _orders = [];

  List<Order> get getOrders => _orders;
  User? _user;

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchOrders();
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _orders = r;
      toggleLoadingOn(false);
    });
  }

  Future<String?> getNameFromOtherCollection(String id) async {
    final collection = firestore.FirebaseFirestore.instance.collection('user');
    final docSnapshot = await collection.doc(id).get();
    final data = docSnapshot.data();

    if (data != null) {
      return data['name'];
    } else {
      return null;
    }
  }

  // Future<void> addChatWithUserName(String orderId, String controller,
  //     String user, String clinetId, String vendorId, String adminId) async {
  //   final orderSnapshot = await firestore.FirebaseFirestore.instance
  //       .collection('order')
  //       .doc(orderId)
  //       .get();
  //   final orderData = orderSnapshot.data();

  //   if (orderData != null) {
  //     if (UserType.admin.name == user) {
  //       final chatRef = firestore.FirebaseFirestore.instance
  //           .collection('order')
  //           .doc(orderId)
  //           .collection('chat')
  //           .doc();
  //       await firestore.FirebaseFirestore.instance
  //           .runTransaction((transaction) async {
  //         transaction.set(orderSnapshot.reference, {'chat': true},
  //             firestore.SetOptions(merge: true));
  //         await chatRef.set({
  //           'id': chatRef.id,
  //           'msg': controller,
  //           'user_id': adminId,
  //           'createdAt': DateTime.now(),
  //           'readBy': [adminId]
  //         });
  //       });
  //     }

  //     if (UserType.client.name == user) {
  //       final chatRef = firestore.FirebaseFirestore.instance
  //           .collection('order')
  //           .doc(orderId)
  //           .collection('chat')
  //           .doc();
  //       await firestore.FirebaseFirestore.instance
  //           .runTransaction((transaction) async {
  //         transaction.set(orderSnapshot.reference, {'chat': true},
  //             firestore.SetOptions(merge: true));
  //         await chatRef.set({
  //           'id': chatRef.id,
  //           'msg': controller,
  //           'user_id': clinetId,
  //           'createdAt': DateTime.now(),
  //           'readBy': [clinetId]
  //         });
  //       });
  //     }
  //     if (UserType.vendor.name == user) {
  //       final chatRef = firestore.FirebaseFirestore.instance
  //           .collection('order')
  //           .doc(orderId)
  //           .collection('chat')
  //           .doc();
  //       await firestore.FirebaseFirestore.instance
  //           .runTransaction((transaction) async {
  //         transaction.set(orderSnapshot.reference, {'chat': true},
  //             firestore.SetOptions(merge: true));
  //         await chatRef.set({
  //           'id': chatRef.id,
  //           'msg': controller,
  //           'user_id': vendorId,
  //           'createdAt': DateTime.now(),
  //           'readBy': [vendorId]
  //         });
  //       });
  //     }
  //   }
  // }

  Future<void> addChatWithUserName(String orderId, String controller,
      String user, String clinetId, String vendorId, String adminId) async {
    final orderRef =
        firestore.FirebaseFirestore.instance.collection('order').doc(orderId);
    final orderSnapshot = await orderRef.get();
    final orderData = orderSnapshot.data();
    // final id = [clinetId,vendorId];
    if (orderData != null) {
      final batch = firestore.FirebaseFirestore.instance.batch();
      final chatRef = orderRef.collection('chat').doc();


      if (UserType.admin.name == user) {
        batch.set(chatRef, {
          'id': chatRef.id,
          'msg': controller,
          'user_id': adminId,
          'createdAt': DateTime.now(),
          'readBy': [adminId]
        });
        sendPushNotification(controller, clinetId);
        sendPushNotification(controller, vendorId);
       
        if (UserType.admin.name == user) {
          final chatQuerySnapshot = await orderRef
              .collection('chat')
              .where('readBy', arrayContains: adminId)
              .get();
          final chatDocs = chatQuerySnapshot.docs;
          for (final doc in chatDocs) {
            batch.update(doc.reference, {
              'readBy': firestore.FieldValue.arrayUnion([adminId])
            });
          }
        }
        await batch.commit();
      }

      if (UserType.client.name == user) {
        batch.set(chatRef, {
          'id': chatRef.id,
          'msg': controller,
          'user_id': clinetId,
          'createdAt': DateTime.now(),
          'readBy': [clinetId]
        });
        sendPushNotification(controller, adminId);
        sendPushNotification(controller, vendorId);
        if (UserType.client.name == user) {
          final chatQuerySnapshot = await orderRef
              .collection('chat')
              .where('readBy', arrayContains: clinetId)
              .get();
          final chatDocs = chatQuerySnapshot.docs;
          for (final doc in chatDocs) {
            batch.update(doc.reference, {
              'readBy': firestore.FieldValue.arrayUnion([clinetId])
            });
          }
        }
        await batch.commit();
      }
      if (UserType.vendor.name == user) {
        batch.set(chatRef, {
          'id': chatRef.id,
          'msg': controller,
          'user_id': vendorId,
          'createdAt': DateTime.now(),
          'readBy': [vendorId]
        });
        sendPushNotification(controller, clinetId);
        sendPushNotification(controller, adminId);
        if (UserType.vendor.name == user) {
          final chatQuerySnapshot = await orderRef
              .collection('chat')
              .where('readBy', arrayContains: vendorId)
              .get();
          final chatDocs = chatQuerySnapshot.docs;
          for (final doc in chatDocs) {
            batch.update(doc.reference, {
              'readBy': firestore.FieldValue.arrayUnion([vendorId])
            });
          }
        }
        await batch.commit();
      }
    }
  }

  

  Future<void> updateReadBy(String orderId, String user, String userId) async {
    final orderRef =
        firestore.FirebaseFirestore.instance.collection('order').doc(orderId);
    final batch = firestore.FirebaseFirestore.instance.batch();

    // if (UserType.admin.name == user) {
    final chatQuerySnapshot = await orderRef
        .collection('chat')
        .where('readBy', whereNotIn: [userId]).get();
    final chatDocs = chatQuerySnapshot.docs;
    for (final doc in chatDocs) {
      if (!doc.data()['readBy'].contains(userId)) {
        batch.update(doc.reference, {
          'readBy': firestore.FieldValue.arrayUnion([userId])
        });
      }
    }
    await batch.commit();
  }

  Future<int> getReadByCount(String orderId, String vendorId, String user,
      String adminId, String clientId) async {
    final orderRef =
        firestore.FirebaseFirestore.instance.collection('order').doc(orderId);
    firestore.QuerySnapshot? chatQuerySnapshot;
    if (UserType.admin.name == user) {
      chatQuerySnapshot = await orderRef
          .collection('chat')
          .where('readBy', whereNotIn: [adminId]).get();
      return chatQuerySnapshot.docs.length;
    }
    if (UserType.client.name == user) {
      chatQuerySnapshot = await orderRef
          .collection('chat')
          .where('readBy', whereNotIn: [clientId]).get();
      // return chatQuerySnapshot.docs.length;
    }
    if (UserType.vendor.name == user) {
      chatQuerySnapshot = await orderRef
          .collection('chat')
          .where('readBy', whereNotIn: [vendorId]).get();
      // return chatQuerySnapshot.docs.length;
    }
    return chatQuerySnapshot!.docs.length;
  }

  Stream<firestore.QuerySnapshot> getChatStream(String orderId) {
    return firestore.FirebaseFirestore.instance
        .collection(FirebaseConfig.orderCollection)
        .doc(orderId)
        .collection('chat')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  void getMessageFromChat(String orderId, String userId) async {
    final chatRef = firestore.FirebaseFirestore.instance
        .collection(FirebaseConfig.orderCollection)
        .doc(orderId)
        .collection('chat');

    firestore.QuerySnapshot<Map<String, dynamic>> snapshot =
        await chatRef.where('user_id', isEqualTo: userId).get();

    if (snapshot.docs.isNotEmpty) {
      for (firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        String message = doc.get('msg');
        print(message);
      }
    }
  }

  static Future<void> sendPushNotification(String msg, String id) async {
    if (id != null) {
      final userRef =
          firestore.FirebaseFirestore.instance.collection('user').doc(id);
      final userSnapshot = await userRef.get();
      final userData = userSnapshot.data();
      if (userData != null) {
        final pushToken = userData['pushToken'];

        final body = {
          // "to": users.map((user) => user.pushToken).toList(),
          "to": pushToken,
          "notification": {
            "title": "Title of the notification",
            "body": msg,
          },
          "data": {
            "route": "/chat_view", // include the route name
            "orderId": "9UdECrXq3aosqie1BdQ2",
          }
        };
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAsdVuN_0:APA91bH23hJVe9f3x_WUUiitRwWOuA9XVDSx1DTowKoZ3fZWFhQDIZ864oPwX90VHOoj_3z_6jlJp8XPiiBkOIwLBKz2pknnvWvYzvbOvFOz1HH_9S_wpePVBcVIyXGKG6CUdqcGDa3X',
          },
          body: json.encode(body),
        );
      }
    }
  }
}
