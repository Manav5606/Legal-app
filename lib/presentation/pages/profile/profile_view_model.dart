import 'dart:developer';
import 'package:admin/core/enum/role.dart';
import 'package:admin/core/extension/validator.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/associate_detail.dart';
import 'package:admin/data/models/bank_info.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/models/working_hour.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
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

  User? _user;
  Vendor? _vendor;

  User? get getUser => _user;
  Vendor? get getVendor => _vendor;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  VendorDocuments _documents = VendorDocuments();

  final List<String> _qualificationDegree = [];
  final List<String> _qualificationUniversity = [];

  List<String> get getQualificationDegree => _qualificationDegree;
  List<String> get getQualificationUniversity => _qualificationUniversity;

  void addQualificationDegree(String value) {
    _qualificationDegree.add(value);
    notifyListeners();
  }

  void addQualificationUniversity(String value) {
    _qualificationUniversity.add(value);
    notifyListeners();
  }

  VendorDocuments get documents => _documents;

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
  final TextEditingController associateNameController = TextEditingController();
  final TextEditingController associateAddressController =
      TextEditingController();
  final TextEditingController associatePermanentAddressController =
      TextEditingController();
  final TextEditingController qualifiedYearController = TextEditingController();
  final TextEditingController practicingExperienceController =
      TextEditingController();
  final TextEditingController expertServicesController =
      TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  void setStartingHour(TimeOfDay time) {
    startingWorkHourController.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  void setEndingHour(TimeOfDay time) {
    endingWorkHourController.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

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
    if (qualifiedYearController.text.isNotEmpty &&
        int.tryParse(qualifiedYearController.text) == null &&
        int.parse(qualifiedYearController.text) < 1900) {
      qualifiedYearError = "Please enter a valid Year";
    }
    if (practicingExperienceController.text.isNotEmpty &&
        int.tryParse(practicingExperienceController.text) == null &&
        int.parse(practicingExperienceController.text) > 0) {
      practicingExperienceError = "Please enter a valid Experience in Months";
    }
    if (landlineController.text.isNotEmpty &&
        !landlineController.text.isValidPhoneNumber()) {
      landlineError = "Please enter a valid Landline number";
    }
    if (mobileController.text.isNotEmpty &&
        !mobileController.text.isValidPhoneNumber()) {
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

  Future<void> uploadPan({required XFile file}) async {
    try {
      panLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(pan: downloadUrl);
    } catch (_) {
    } finally {
      panLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfilePic({required XFile file}) async {
    try {
      profileLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _user = _user!.copyWith(profilePic: downloadUrl);
    } catch (_) {
    } finally {
      profileLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAadhar({required XFile file}) async {
    try {
      aadharLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(aadhar: downloadUrl);
    } catch (_) {
    } finally {
      aadharLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAgreement({required XFile file}) async {
    try {
      agreementLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(agreement: downloadUrl);
    } catch (_) {
    } finally {
      agreementLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadGoogleMap({required XFile file}) async {
    try {
      googleMapLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(googleMap: downloadUrl);
    } catch (_) {
    } finally {
      googleMapLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadNameBoard({required XFile file}) async {
    try {
      nameBoardLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(nameBoard: downloadUrl);
    } catch (_) {
    } finally {
      nameBoardLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadPassPhoto({required XFile file}) async {
    try {
      passPhotoLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(passPhoto: downloadUrl);
    } catch (_) {
    } finally {
      passPhotoLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadPowerBill({required XFile file}) async {
    try {
      powerBillLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(powerBill: downloadUrl);
    } catch (_) {
    } finally {
      powerBillLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadPracticeCerti({required XFile file}) async {
    try {
      practiceCertiLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents = _documents.copyWith(practiceCerti: downloadUrl);
    } catch (_) {
    } finally {
      practiceCertiLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadValidityDateOfPracticeCertificate(
      {required XFile file}) async {
    try {
      validityDateOfPracticeCertificateLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: _user!.id!);
      _documents =
          _documents.copyWith(validityDateOfPracticeCertificate: downloadUrl);
    } catch (_) {
    } finally {
      validityDateOfPracticeCertificateLoading = false;
      notifyListeners();
    }
  }

  Future<XFile?> pickFile(FilePickerResult? result) async {
    if (result != null) {
      final choosenFile = result.files.first;
      return XFile.fromData(choosenFile.bytes!, name: choosenFile.name);
    }
    return null;
  }

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  void preFillData() {
    try {
      toggleLoadingOn(true);
      if (_user != null) {
        nameController.text = _user!.name;
        emailController.text = _user!.email;
        phoneController.text = _user!.phoneNumber.toString();
      }
      if (_vendor != null) {
        companyNameController.text = _vendor?.companyName ?? "";
        permanentAddressController.text = _vendor?.permanentAddress ?? "";
        startingWorkHourController.text =
            _vendor?.workingHour?.startingHour.toString() ?? "";
        endingWorkHourController.text =
            _vendor?.workingHour?.endingHour.toString() ?? "";
        accountNumberController.text =
            _vendor?.bankAccount?.accountNumber ?? "";
        ifscController.text = _vendor?.bankAccount?.ifsc ?? "";
        associateNameController.text =
            _vendor?.associateDetail?.associateName ?? "";
        associateAddressController.text =
            _vendor?.associateDetail?.addressOfAssociate ?? "";
        associatePermanentAddressController.text =
            _vendor?.associateDetail?.permanentAddress ?? "";
        qualifiedYearController.text =
            (_vendor?.qualifiedYear ?? "").toString();
        practicingExperienceController.text =
            (_vendor?.practiceExperience ?? "").toString();
        expertServicesController.text = (_vendor?.expertServices ?? "");
        landlineController.text = (_vendor?.landline ?? "").toString();
        mobileController.text = (_vendor?.mobile ?? " ").toString();
        _documents = _vendor?.documents ?? VendorDocuments();
        _qualificationDegree.clear();
        _qualificationDegree.addAll(_vendor?.qualificationDegree ?? []);
        _qualificationUniversity.clear();
        _qualificationUniversity.addAll(_vendor?.qualificationUniversity ?? []);
      }
    } catch (_) {
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future<void> fetchUser(String uid) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchUserByID(uid);
    await res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      clearErrors();
      _user = r;
      if (_user?.userType == UserType.vendor) {
        final vendorRes = await _databaseRepositoryImpl.fetchVendorByID(uid);
        vendorRes.fold((l) {
          error = l.message;
          Messenger.showSnackbar(l.message);
          toggleLoadingOn(false);
        }, (r) {
          _vendor = r;
        });
      }
    });
    toggleLoadingOn(false);
    preFillData();
  }

  Future<void> saveProfileData() async {
    try {
      toggleLoadingOn(true);
      final updatedUser = _user!.copyWith(
        name: nameController.text,
        phoneNumber: int.tryParse(phoneController.text),
      );
      await _databaseRepositoryImpl.updateUser(user: updatedUser);
      if (_user!.userType == UserType.vendor) {
        final updatedVendor = _vendor!.copyWith(
          companyName: companyNameController.text,
          permanentAddress: permanentAddressController.text,
          bankAccount: BankInfo(
              accountNumber: accountNumberController.text,
              ifsc: ifscController.text),
          associateDetail: AssociateDetail(
              addressOfAssociate: associateAddressController.text,
              associateName: associateNameController.text,
              permanentAddress: permanentAddressController.text),
          qualifiedYear: int.tryParse(qualifiedYearController.text),
          practiceExperience: int.tryParse(practicingExperienceController.text),
          expertServices: expertServicesController.text,
          landline: int.tryParse(landlineController.text),
          mobile: int.tryParse(mobileController.text),
          workingHour: WorkingHour(
            startingHour: startingWorkHourController.text,
            endingHour: endingWorkHourController.text,
          ),
          qualificationDegree: _qualificationDegree,
          qualificationUniversity: _qualificationUniversity,
          documents: _documents,
        );
        await _databaseRepositoryImpl.updateVendor(vendor: updatedVendor);
      }
      Messenger.showSnackbar("Profile Updated ✅");
    } catch (e) {
      log("Failed to save profile:: ${e.toString()}");
    } finally {
      toggleLoadingOn(false);
    }
  }
}
