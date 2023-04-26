import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constant/firebase_config.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => AssignOrderToVendorModel(ref.read(Repository.database)));

class AssignOrderToVendorModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  AssignOrderToVendorModel(this._databaseRepositoryImpl) {
    fetchVendors();
  }

  static AutoDisposeChangeNotifierProvider<AssignOrderToVendorModel>
      get provider => _provider;

  String? error;
  // Order? order;

  List<User> _vendors = [];

  List<User> get getVendors => _vendors;

  // List<Order> _order = [];

  // List<Order> get getOrders => _order;
  // Order? get getOrder => order;
  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchVendors() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchUsersByType(UserType.vendor);
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _vendors = r;
      toggleLoadingOn(false);
    });
  }

Future<void> updateOrder(String orderId, String newClientName) async {
  toggleLoadingOn(true);

  try {
    // Update the 'client' field in Firestore
    final orderRef = FirebaseFirestore.instance
        .collection(FirebaseConfig.orderCollection)
        .doc(orderId);
    await orderRef.update({'client_id': newClientName});

    // Update the 'client' field in the local order object as well
  
    clearErrors();
    toggleLoadingOn(false);
    Messenger.showSnackbar('cleint_id updated successfully.');
  
  } catch (e) {
    
    toggleLoadingOn(false);
    Messenger.showSnackbar('Unknown Error, Please try again later.');
  }
}

Future<void> updateOrderStatus(String orderId, String status) async {
  toggleLoadingOn(true);

  try {
    // Update the 'client' field in Firestore
    final orderRef = FirebaseFirestore.instance
        .collection(FirebaseConfig.orderCollection)
        .doc(orderId);
    await orderRef.update({'status': status});

    // Update the 'client' field in the local order object as well
  
    clearErrors();
    toggleLoadingOn(false);
    Messenger.showSnackbar('status name updated successfully.');
  
  } catch (e) {
    
    toggleLoadingOn(false);
    Messenger.showSnackbar('Unknown Error, Please try again later.');
  }
}



  void sortVendors(int index, bool ascending) {
    switch (index) {
      case 0:
        _vendors.sort((a, b) =>
            ascending ? a.id!.compareTo(b.id!) : b.id!.compareTo(a.id!));
        break;
      case 1:
        _vendors.sort((a, b) => ascending
            ? DateTime.fromMillisecondsSinceEpoch(a.createdAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(b.createdAt!))
            : DateTime.fromMillisecondsSinceEpoch(b.createdAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createdAt!)));
        break;
      case 2:
        _vendors.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 3:
        _vendors.sort((a, b) => ascending
            ? a.phoneNumber.compareTo(b.phoneNumber)
            : b.phoneNumber.compareTo(a.phoneNumber));
        break;
      case 4:
        _vendors.sort((a, b) => ascending
            ? a.email.compareTo(b.email)
            : b.email.compareTo(a.email));
        break;
    }
    sortAscending = !ascending;
    sortIndex = index;
    notifyListeners();
  }
}
