import 'dart:developer';
import 'package:admin/core/enum/role.dart';
import 'package:admin/core/extension/validator.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/associate_detail.dart';
import 'package:admin/data/models/bank_info.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/models/working_hour.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => AddRemoveServiceViewModel(ref.read(Repository.database)));

class AddRemoveServiceViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  bool sortAscending = false;
  int sortIndex = 0;
  static AutoDisposeChangeNotifierProvider<AddRemoveServiceViewModel>
      get provider => _provider;

  AddRemoveServiceViewModel(this._databaseRepositoryImpl);

  User? _user;
  Vendor? _vendor;

  List<Service> _service = [];
  List<Service> get getService => _service;
  List<Service> getSelectedServices() {
    return _service.toList();
  }

  User? get getUser => _user;
  Vendor? get getVendor => _vendor;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? error;

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchService() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchServices();
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _service = r;
      toggleLoadingOn(false);
    });
  }

  Future<void> addService(List myList, String vendorId) async {
    toggleLoadingOn(true);

    try {
      // Add the order ID to the vendor's list of assigned orders
      final firestore.CollectionReference vendorServiceRef =
          firestore.FirebaseFirestore.instance.collection('vendor-service');
      final firestore.QuerySnapshot vendorSnapshot =
          await vendorServiceRef.where('vendor_id', isEqualTo: vendorId).get();
      if (vendorSnapshot.docs.isNotEmpty) {
        final String docRefId = vendorSnapshot.docs.first.id;
        await vendorServiceRef.doc(docRefId).update({
          'service_id': firestore.FieldValue.arrayUnion(myList),
        });
      } else {
        await vendorServiceRef.add({
          'vendor_id': vendorId,
          'service_id': myList,
        });
      }

      toggleLoadingOn(false);
      Messenger.showSnackbar('Service Added successfully.');
    } catch (e) {
      toggleLoadingOn(false);
      Messenger.showSnackbar('Unknown Error, Please try again later.');
    }
  }

  Future<void> removeServicesFromVendor(
      List serviceIds, String vendorId) async {
    toggleLoadingOn(true);
    try {
      final firestore.CollectionReference vendorServiceRef =
          firestore.FirebaseFirestore.instance.collection('vendor-service');
      final firestore.QuerySnapshot vendorSnapshot =
          await vendorServiceRef.where('vendor_id', isEqualTo: vendorId).get();

      if (vendorSnapshot.docs.isNotEmpty) {
        final String docRefId = vendorSnapshot.docs.first.id;
        await vendorServiceRef.doc(docRefId).update({
          'service_id': firestore.FieldValue.arrayRemove(serviceIds),
        });
      }

      toggleLoadingOn(false);
      Messenger.showSnackbar('Services removed successfully.');
    } catch (e) {
      toggleLoadingOn(false);
      Messenger.showSnackbar('Unknown Error, Please try again later.');
    }
  }
}
