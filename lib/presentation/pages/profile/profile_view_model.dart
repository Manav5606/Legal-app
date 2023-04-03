import 'package:admin/core/extension/validator.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => ProfileViewModel(ref.read(Repository.database)));

class ProfileViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  bool sortAscending = false;
  int sortIndex = 0;
  static AutoDisposeChangeNotifierProvider<ProfileViewModel> get provider =>
      _provider;

  ProfileViewModel(this._databaseRepositoryImpl);

  late final User _user;
  late final Vendor? _vendor;

  User get getUser => _user;
  Vendor? get getVendor => _vendor;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController permanentAddressController =
      TextEditingController();
  final TextEditingController startingWorkHourController =
      TextEditingController();
  final TextEditingController endingWorkHourController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  // degree
  final TextEditingController otherDegreeController = TextEditingController();
  // university
  final TextEditingController otherUniversityContoller =
      TextEditingController();
  final TextEditingController associateNameContoller = TextEditingController();
  final TextEditingController associateAddressContoller =
      TextEditingController();
  final TextEditingController associatePermanentAddressController =
      TextEditingController();
  final TextEditingController qualifiedYearContoller = TextEditingController();
  final TextEditingController practicingExperienceContoller =
      TextEditingController();
  final TextEditingController expertServicesContoller = TextEditingController();
  final TextEditingController landlineContoller = TextEditingController();
  final TextEditingController mobileContoller = TextEditingController();

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
    if (phoneController.text.isNotEmpty &&
        !phoneController.text.isValidPhoneNumber()) {
      phoneError = "Please enter a valid Phone number";
    }
    if (accountNumberController.text.isNotEmpty &&
        int.tryParse(accountNumberController.text) == null) {
      accountNumberError = "Please enter a valid Bank Account Number";
    }
    // other degree
    // if (accountNumberController.text.isNotEmpty &&
    //     int.tryParse(accountNumberController.text) == null) {
    //   accountNumberError = "Please enter a valid Bank Account Number";
    // }
    // other university
    // if (accountNumberController.text.isNotEmpty &&
    //     int.tryParse(accountNumberController.text) == null) {
    //   accountNumberError = "Please enter a valid Bank Account Number";
    // }
    if (qualifiedYearContoller.text.isNotEmpty &&
        int.tryParse(qualifiedYearContoller.text) == null &&
        int.parse(qualifiedYearContoller.text) < 1900) {
      qualifiedYearError = "Please enter a valid Year";
    }
    if (practicingExperienceContoller.text.isNotEmpty &&
        int.tryParse(practicingExperienceContoller.text) == null &&
        int.parse(practicingExperienceContoller.text) > 0) {
      practicingExperienceError = "Please enter a valid Experience in Months";
    }
    if (landlineContoller.text.isNotEmpty &&
        !landlineContoller.text.isValidPhoneNumber()) {
      landlineError = "Please enter a valid Landline number";
    }
    if (mobileContoller.text.isNotEmpty &&
        !mobileContoller.text.isValidPhoneNumber()) {
      mobileError = "Please enter a valid mobile number";
    }
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

  Future<void> fetchUser(String uid) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchUsersByID(uid);
  }
}
