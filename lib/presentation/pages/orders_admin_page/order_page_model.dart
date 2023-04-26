import 'dart:developer';
import 'package:admin/core/enum/order_status.dart';
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

import '../../../core/constant/firebase_config.dart' as config;

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => OrderPageModel(ref.read(Repository.database)));

class OrderPageModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  bool sortAscending = false;
  int sortIndex = 0;
  static AutoDisposeChangeNotifierProvider<OrderPageModel> get provider =>
      _provider;

  OrderPageModel(this._databaseRepositoryImpl);

  Order? _Order;
  User? _user;

  List<Service> _service = [];
  List<Service> get getService => _service;
  List<Service> getSelectedServices() {
    return _service.toList();
  }

  Order? get getOrder => _Order;
  User? get getUser => _user;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  VendorDocuments _documents = VendorDocuments();

  final List<String> _qualificationDegree = [];
  final List<String> _qualificationUniversity = [];

  List<String> get getQualificationDegree => _qualificationDegree;
  List<String> get getQualificationUniversity => _qualificationUniversity;

  bool isSelected(Service service) {
    return _service.contains(service);
  }

  void selectService(Service service) {
    _service.add(service);
  }

  void deselectService(Service service) {
    _service.remove(service);
  }

  void clearSelectedServices() {
    _service.clear();
  }

  void addQualificationDegree(String value) {
    _qualificationDegree.add(value);
    notifyListeners();
  }

  void addQualificationUniversity(String value) {
    _qualificationUniversity.add(value);
    notifyListeners();
  }

  VendorDocuments get documents => _documents;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? emailError;
  String? phoneError;
  String? accountNumberError;
  String? ifscError;
  String? otherDegreeError;
  String? otherUniversityError;
  String? qualifiedYearError;
  String? practicingExperienceError;
  String? landlineError;
  String? mobileError;

  void clearError() {
    emailError = phoneError = accountNumberError = ifscError =
        otherDegreeError = otherUniversityError = qualifiedYearError =
            practicingExperienceError = landlineError = mobileError = null;
    notifyListeners();
  }

  bool validate() {
    clearError();
    if (emailController.text.isNotEmpty &&
        !emailController.text.isValidEmail()) {
      emailError = "Please enter a valid Email";
    }
    if (mobileNumberController.text.isNotEmpty &&
        !mobileNumberController.text.isValidPhoneNumber()) {
      phoneError = "Please enter a valid Phone number";
    }
    if (userNameController.text.isNotEmpty &&
        int.tryParse(userNameController.text) == null) {
      accountNumberError = "Please enter a Name";
    }
    // other degree
    // if (userNameController.text.isNotEmpty &&
    //     int.tryParse(userNameController.text) == null) {
    //   accountNumberError = "Please enter a valid Bank Account Number";
    // }
    // other university
    // if (userNameController.text.isNotEmpty &&
    //     int.tryParse(userNameController.text) == null) {
    //   accountNumberError = "Please enter a valid Bank Account Number";
    // }
    // if (qualifiedYearController.text.isNotEmpty &&
    //     int.tryParse(qualifiedYearController.text) == null &&
    //     int.parse(qualifiedYearController.text) < 1900) {
    //   qualifiedYearError = "Please enter a valid Year";
    // }
    // if (practicingExperienceController.text.isNotEmpty &&
    //     int.tryParse(practicingExperienceController.text) == null &&
    //     int.parse(practicingExperienceController.text) > 0) {
    //   practicingExperienceError = "Please enter a valid Experience in Months";
    // }
    // if (landlineController.text.isNotEmpty &&
    //     !landlineController.text.isValidPhoneNumber()) {
    //   landlineError = "Please enter a valid Landline number";
    // }
    // if (mobileController.text.isNotEmpty &&
    //     !mobileController.text.isValidPhoneNumber()) {
    //   mobileError = "Please enter a valid mobile number";
    // }
    notifyListeners();
    return emailError == null &&
        phoneError == null &&
        accountNumberError == null &&
        ifscError == null &&
        otherDegreeError == null &&
        otherUniversityError == null &&
        qualifiedYearError == null &&
        practicingExperienceError == null &&
        landlineError == null &&
        mobileError == null;
  }

  String? error;

  bool profileLoading = false;
  bool panLoading = false;
  bool aadharLoading = false;
  bool agreementLoading = false;
  bool googleMapLoading = false;
  bool nameBoardLoading = false;
  bool passPhotoLoading = false;
  bool powerBillLoading = false;
  bool practiceCertiLoading = false;
  bool validityDateOfPracticeCertificateLoading = false;

  // Future<void> uploadPan({required XFile file}) async {
  //   try {
  //     panLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(pan: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     panLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadProfilePic({required XFile file}) async {
  //   try {
  //     profileLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _Order = _Order!.copyWith(profilePic: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     profileLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadAadhar({required XFile file}) async {
  //   try {
  //     aadharLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(aadhar: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     aadharLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadAgreement({required XFile file}) async {
  //   try {
  //     agreementLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(agreement: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     agreementLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadGoogleMap({required XFile file}) async {
  //   try {
  //     googleMapLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(googleMap: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     googleMapLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadNameBoard({required XFile file}) async {
  //   try {
  //     nameBoardLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(nameBoard: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     nameBoardLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadPassPhoto({required XFile file}) async {
  //   try {
  //     passPhotoLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(passPhoto: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     passPhotoLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadPowerBill({required XFile file}) async {
  //   try {
  //     powerBillLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(powerBill: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     powerBillLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadPracticeCerti({required XFile file}) async {
  //   try {
  //     practiceCertiLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents = _documents.copyWith(practiceCerti: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     practiceCertiLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> uploadValidityDateOfPracticeCertificate(
  //     {required XFile file}) async {
  //   try {
  //     validityDateOfPracticeCertificateLoading = true;
  //     notifyListeners();
  //     final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
  //         file: file, OrderID: _Order!.id!);
  //     _documents =
  //         _documents.copyWith(validityDateOfPracticeCertificate: downloadUrl);
  //   } catch (_) {
  //   } finally {
  //     validityDateOfPracticeCertificateLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<XFile?> pickFile(FilePickerResult? result) async {
  //   if (result != null) {
  //     final choosenFile = result.files.first;
  //     return XFile.fromData(choosenFile.bytes!, name: choosenFile.name);
  //   }
  //   return null;
  // }`

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  void preFillData() {
    try {
      toggleLoadingOn(true);
      // if (_Order != null) {
      //   nameController.text = _Order!.name;
      //   emailController.text = _Order!.email;
      //   mobileNumberController.text = _Order!.phoneNumber.toString();
      // }
      if (_Order != null) {
        userNameController.text = _user?.name ?? "";
        emailController.text = _user?.email ?? "";
        mobileNumberController.text = _user?.phoneNumber.toString() ?? "";
        // endingWorkHourController.text = _user?. ?? "";
        // userNameController.text = _Order?.userID ?? "";
      }
    } catch (_) {
    } finally {
      toggleLoadingOn(false);
    }
  }

  // Future<void> fetchOrder(String uid) async {
  //   toggleLoadingOn(true);
  //   final res = await _databaseRepositoryImpl.fetchOrderByID(uid);
  //   await res.fold((l) {
  //     error = l.message;
  //     Messenger.showSnackbar(l.message);
  //     toggleLoadingOn(false);
  //   }, (r) async {
  //     clearErrors();
  //     _Order = r;
  //     if (-User?. == OrderType.vendor) {
  //       final vendorRes = await _databaseRepositoryImpl.fetchVendorByID(uid);
  //       vendorRes.fold((l) {
  //         error = l.message;
  //         Messenger.showSnackbar(l.message);
  //         toggleLoadingOn(false);
  //       }, (r) {
  //         _Order = r;
  //       });
  //     }
  //   });
  //   toggleLoadingOn(false);
  //   preFillData();
  //   fetchService();
  // }

  Future<void> fetchUser(String uid) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchOrderByID(uid);
    await res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      clearErrors();
      _Order = r;

      // if (_user?.userType == UserType.vendor) {
      final vendorRes = await _databaseRepositoryImpl.fetchUserByID(r.userID!);
      vendorRes.fold((l) {
        error = l.message;
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
      }, (r) {
        _user = r;
      });
      // }
    });
    toggleLoadingOn(false);
    preFillData();
    fetchService();
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

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    toggleLoadingOn(true);

    try {
      // Update the 'client' field in Firestore
      final orderRef = firestore.FirebaseFirestore.instance
          .collection(config.FirebaseConfig.orderCollection)
          .doc(orderId);
      await orderRef.update({'status': status.name});

      // Update the 'client' field in the local order object as well

      clearErrors();
      toggleLoadingOn(false);
      Messenger.showSnackbar('status updated successfully.');
    } catch (e) {
      toggleLoadingOn(false);
      Messenger.showSnackbar('Unknown Error, Please try again later.');
    }
  }

  Future<String> getOrderStatus(String orderId) async {
    toggleLoadingOn(true);
    try {
      final orderRef = firestore.FirebaseFirestore.instance
          .collection(config.FirebaseConfig.orderCollection)
          .doc(orderId);
      final orderDoc = await orderRef.get();
      final status = orderDoc.data()!['status'];
      // toggleLoadingOn(false);
      print(status);
      return status;
    } catch (e) {
      // handle error
      toggleLoadingOn(false);

      return Messenger.showSnackbar('Unknown Error, Please try again later.');
    }
  }



  //   Future<void> updateOrder() async {
  //   try {
  //     toggleLoadingOn(true);
  //     final updatedUser = _Order!.copyWith(
  //      status: OrderStatus.approved,

  //     );
  //     await _databaseRepositoryImpl.updateOrder(order: updatedUser);

  //     Messenger.showSnackbar("Profile Updated ✅");
  //   } catch (e) {
  //     log("Failed to save profile:: ${e.toString()}");
  //   } finally {
  //     toggleLoadingOn(false);
  //   }
  // }

  // Future<void> saveProfileData() async {
  //   try {
  //     toggleLoadingOn(true);
  //     final updatedOrder = _Order!.copyWith(
  //       name: nameController.text,
  //       phoneNumber: int.tryParse(mobileNumberController.text),
  //     );
  //     await _databaseRepositoryImpl.updateOrder(Order: updatedOrder);
  //     if (_Order!.OrderType == OrderType.vendor) {
  //       final updatedVendor = _Order!.copyWith(
  //         companyName: userNameController.text,
  //         permanentAddress: mobileNumberController.text,
  //         bankAccount: BankInfo(
  //             accountNumber: userNameController.text,
  //             ifsc: ifscController.text),
  //         associateDetail: AssociateDetail(
  //             addressOfAssociate: associateAddressController.text,
  //             associateName: associateNameController.text,
  //             permanentAddress: mobileNumberController.text),
  //         qualifiedYear: int.tryParse(qualifiedYearController.text),
  //         practiceExperience: int.tryParse(practicingExperienceController.text),
  //         expertServices: expertServicesController.text,
  //         landline: int.tryParse(landlineController.text),
  //         mobile: int.tryParse(mobileController.text),
  //         workingHour: WorkingHour(
  //           startingHour: startingWorkHourController.text,
  //           endingHour: endingWorkHourController.text,
  //         ),
  //         qualificationDegree: _qualificationDegree,
  //         qualificationUniversity: _qualificationUniversity,
  //         documents: _documents,
  //       );
  //       await _databaseRepositoryImpl.updateVendor(vendor: updatedVendor);
  //     }
  //     Messenger.showSnackbar("Profile Updated ✅");
  //   } catch (e) {
  //     log("Failed to save profile:: ${e.toString()}");
  //   } finally {
  //     toggleLoadingOn(false);
  //   }
  // }
}
