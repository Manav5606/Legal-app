import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart' as model;
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constant/firebase_config.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => NotificationviewModel(ref.read(Repository.database)));

class NotificationviewModel extends BaseViewModel {
  
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  
  bool sortAscending = false;
  int sortIndex = 0;
    NotificationviewModel(this._databaseRepositoryImpl){
    fetchNotifications();
  }
  static AutoDisposeChangeNotifierProvider<NotificationviewModel> get provider =>
      _provider;

  String? error;


  List<model.Notification> _notifications = [];

  List<model.Notification> get getNotifications => _notifications;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchNotifications() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchNotifications();
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _notifications = r;
      toggleLoadingOn(false);
    });
  }

   Future<void> markAsRead(String notificationId) async {
    toggleLoadingOn(true);

    try {
      // Update the 'client' field in Firestore
      final orderRef = FirebaseFirestore.instance
          .collection(FirebaseConfig.notifications)
          .doc(notificationId);
      await orderRef.update({'isRead': true});

      // Update the 'client' field in the local order object as well

      clearErrors();
      toggleLoadingOn(false);
      // Messenger.showSnackbar('status name updated successfully.');
    } catch (e) {
      toggleLoadingOn(false);
      Messenger.showSnackbar('Unknown Error, Please try again later.');
    }
  }
}
