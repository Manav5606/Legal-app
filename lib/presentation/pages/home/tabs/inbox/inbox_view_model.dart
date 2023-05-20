import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => InboxViewModel(ref.read(Repository.database)));

class InboxViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  bool sortAscending = false;
  int sortIndex = 0;
  InboxViewModel(this._databaseRepositoryImpl) {
    fetchOrders();
  }

  static AutoDisposeChangeNotifierProvider<InboxViewModel> get provider =>
      _provider;

  String? error;
  User? _user;
  User? get getUser => _user;
  List<Order> _orders = [];

  List<Order> get getOrders => _orders;

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

  // Future<int> getReadByCount(String orderId, String vendorId, String user,
  //     String adminId, String clientId) async {
  //   final orderRef =
  //       firestore.FirebaseFirestore.instance.collection('order').doc(orderId);
  //   int unreadCount = 0;
  //   final chatQuerySnapshot = await orderRef.collection('chat').get();
  //   if (UserType.admin.name == user) {
  //     for (final doc in chatQuerySnapshot.docs) {
  //       final readByList = List<String>.from(doc.get('readBy') ?? []);
  //       if (!readByList.contains(adminId)) {
  //         unreadCount++;
  //       }
  //     }
  //   }
  //   if (UserType.client.name == user) {
  //     for (final doc in chatQuerySnapshot.docs) {
  //       final readByList = List<String>.from(doc.get('readBy') ?? []);
  //       if (!readByList.contains(clientId)) {
  //         unreadCount++;
  //       }
  //     }
  //   }
  //   if (UserType.vendor.name == user) {
  //     for (final doc in chatQuerySnapshot.docs) {
  //       final readByList = List<String>.from(doc.get('readBy') ?? []);
  //       if (!readByList.contains(vendorId)) {
  //         unreadCount++;
  //       }
  //     }
  //   }

  //   return unreadCount;
  // }

Stream<int> getReadByCount(String orderId, String vendorId, String user, String adminId, String clientId) {
    final orderRef = firestore.FirebaseFirestore.instance.collection('order').doc(orderId);

    return orderRef.collection('chat').snapshots().map((chatQuerySnapshot) {
      int unreadCount = 0;
      if (UserType.admin.name == user) {
        for (final doc in chatQuerySnapshot.docs) {
          final readByList = List<String>.from(doc.get('readBy') ?? []);
          if (!readByList.contains(adminId)) {
            unreadCount++;
          }
        }
      }
      if (UserType.client.name == user) {
        for (final doc in chatQuerySnapshot.docs) {
          final readByList = List<String>.from(doc.get('readBy') ?? []);
          if (!readByList.contains(clientId)) {
            unreadCount++;
          }
        }
      }
      if (UserType.vendor.name == user) {
        for (final doc in chatQuerySnapshot.docs) {
          final readByList = List<String>.from(doc.get('readBy') ?? []);
          if (!readByList.contains(vendorId)) {
            unreadCount++;
          }
        }
      }

      return unreadCount;
    });
}

  Future<Map<String, int>> getReadByCountt(List<String> orderIds,
      String adminId, String clientId, String user) async {
    final Map<String, int> result = {};

    for (final orderId in orderIds) {
      final orderRef =
          firestore.FirebaseFirestore.instance.collection('order').doc(orderId);

      if (UserType.admin.name == user) {
        final chatQuerySnapshot = await orderRef
            .collection('chat')
            .where('readBy', whereNotIn: [adminId]).get();
        result[orderId] = chatQuerySnapshot.docs.length;
      } else if (UserType.client.name == user) {
        final chatQuerySnapshot = await orderRef
            .collection('chat')
            .where('readBy', whereNotIn: [clientId]).get();
        result[orderId] = chatQuerySnapshot.docs.length;
      }
    }

    return result;
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
}
