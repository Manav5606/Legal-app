import 'package:admin/core/enum/order_status.dart';
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
    (ref) => AssignOrderToVendorViewModel(ref.read(Repository.database)));

class AssignOrderToVendorViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  AssignOrderToVendorViewModel(this._databaseRepositoryImpl) {
    // fetchVendors();
  }

  static AutoDisposeChangeNotifierProvider<AssignOrderToVendorViewModel>
      get provider => _provider;

  String? error;
  // Order? order;

  List<User> _vendors = [];
  List<User> _assignedVendors = [];

  List<User> get getVendors => _vendors;
  List<User> get getAssignedVendors => _assignedVendors;

  // List<Order> _order = [];

  // List<Order> get getOrders => _order;
  // Order? get getOrder => order;
  void clearErrors() {
    error = null;
    notifyListeners();
  }

  // Future<void> fetchVendors() async {
  //   toggleLoadingOn(true);
  //   final res = await _databaseRepositoryImpl.fetchUsersByType(UserType.vendor);
  //   res.fold((l) {
  //     error = l.message;
  //     Messenger.showSnackbar(l.message);
  //     toggleLoadingOn(false);
  //   }, (r) {
  //     clearErrors();
  //     // _vendors = r;
  //     toggleLoadingOn(false);
  //   });
  // }

  Future<void> fetch(List<String> myList) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchAvailabelServiceVendors(
        UserType.vendor, myList);
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

  Future<void> fetchAssinedVendors(List<String> myList) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchAvailabelServiceVendors(
        UserType.vendor, myList);
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _assignedVendors = r;
      toggleLoadingOn(false);
    });
  }

  Future<void> fetchData(String serviceID, String orderId) async {
    List<String> vendorIds = await getVendorIdsByService(serviceID);
    List<String> assignVendorIds = [];
    final orderRef = FirebaseFirestore.instance
        .collection(FirebaseConfig.orderCollection)
        .doc(orderId);

    final orderDoc = await orderRef.get();
    final vendorId = orderDoc.data()?['client_id'];

    if (vendorId != null) {
      vendorIds.remove(vendorId);
      assignVendorIds.add(vendorId);
      fetch(vendorIds);
      fetchAssinedVendors(assignVendorIds);
    } else {
      fetch(vendorIds);
    }
  }

  Future<List<String>> getVendorIdsByService(String serviceName) async {
    // Get a reference to the "vendor-service" collection
    CollectionReference vendorsRef =
        FirebaseFirestore.instance.collection('vendor-service');

    // Query for vendors with the specified service in their array of services
    QuerySnapshot querySnapshot =
        await vendorsRef.where('service_id', arrayContains: serviceName).get();

    // Extract the vendor IDs from the query results
    List<String> vendorIds = [];
    querySnapshot.docs.forEach((doc) {
      vendorIds.add(doc['vendor_id']);
    });

    // Return the list of vendor IDs
    print(vendorIds);

    return vendorIds;
  }

  Future<List> getVendorsByService(String serviceName) async {
    // Get vendor IDs with the specified service
    List<String> vendorIds = await getVendorIdsByService(serviceName);

    // Get references to the vendor documents
    List<DocumentReference> vendorRefs = vendorIds
        .map((vendorId) =>
            FirebaseFirestore.instance.collection('user').doc(vendorId))
        .toList();

    // Fetch the vendor documents
    List<DocumentSnapshot> vendorDocs = await Future.wait(
      vendorRefs.map((ref) => ref.get()),
    );

    // Convert the vendor documents to Vendor objects
    List<User> vendors =
        vendorDocs.map((doc) => User.fromSnapshot(doc)).toList();
    // _vendors = vendors;
    return vendors;
  }

  Future<String> getOrderStatus(String orderId) async {
    toggleLoadingOn(true);
    try {
      final orderRef = FirebaseFirestore.instance
          .collection(FirebaseConfig.orderCollection)
          .doc(orderId);
      final orderDoc = await orderRef.get();
      final status = orderDoc.data()!['clinet_id'];
      // toggleLoadingOn(false);
      print(status);
      return status;
    } catch (e) {
      // handle error
      toggleLoadingOn(false);

      return Messenger.showSnackbar('Unknown Error, Please try again later.');
    }
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

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    toggleLoadingOn(true);

    try {
      // Update the 'client' field in Firestore
      final orderRef = FirebaseFirestore.instance
          .collection(FirebaseConfig.orderCollection)
          .doc(orderId);
      await orderRef.update({'status': status.name});

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
