import 'dart:developer';

import 'package:admin/core/enum/role.dart';
import 'package:admin/core/extension/validator.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/domain/provider/auth_provider.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/associate_detail.dart';
import '../../../../data/models/bank_info.dart';
import '../../../../data/models/working_hour.dart';
import '../../../../data/repositories/database_repositories_impl.dart';

final _vendorViewModel = ChangeNotifierProvider.autoDispose((ref) =>
    VendorRegisterViewModel(ref.read(AppState.auth.notifier),
        ref.read(DatabaseRepositoryImpl.provider)));

class VendorRegisterViewModel extends BaseViewModel {
  static AutoDisposeChangeNotifierProvider<VendorRegisterViewModel>
      get provider => _vendorViewModel;
  VendorRegisterViewModel(this._authProvider, this._databaseRepositoryImpl);
  final AuthProvider _authProvider;
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  VendorDocuments _documents = VendorDocuments();
  Vendor? vendor;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController associateNameController = TextEditingController();
  final TextEditingController associateAddressController =
      TextEditingController();
  final TextEditingController associatePermanentAddressController =
      TextEditingController();
  final TextEditingController startingWorkHourController =
      TextEditingController();
  final TextEditingController endingWorkHourController =
      TextEditingController();
  final TextEditingController qualifiedYearController = TextEditingController();
  final TextEditingController practicingExperienceController =
      TextEditingController();
  final TextEditingController expertServicesController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool _passwordVisible = false;
  bool _password1Visible = false;

  String? usernameError;
  String? numberError;
  String? emailError;
  String? password1Error;
  String? passwordError;
  String? otpError;
  String? accountNumberError;
  String? ifscError;
  String? otherDegreeError;
  String? otherUniversityError;
  String? qualifiedYearError;
  String? practicingExperienceError;
  String? expertServiceError;
  String? startWorkingHours;
  String? endWorkingHours;
  String? landlineError;
  String? mobileError;

  bool get showPassword => _passwordVisible;
  bool get showPassword1 => _password1Visible;

  final List<String> _qualificationDegree = [];
  final List<String> _qualificationUniversity = [];

  List<String> get getQualificationDegree => _qualificationDegree;
  List<String> get getQualificationUniversity => _qualificationUniversity;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void togglePassword1Visibility() {
    _password1Visible = !_password1Visible;
    notifyListeners();
  }

  void clearError() {
    usernameError = passwordError = password1Error = emailError = numberError =
        otpError = accountNumberError = ifscError = otherDegreeError =
            otherUniversityError = qualifiedYearError =
                practicingExperienceError = landlineError = mobileError =
                    expertServiceError =
                        startWorkingHours = endWorkingHours = null;
    notifyListeners();
  }

  void addQualificationDegree(String value) {
    _qualificationDegree.add(value);
    notifyListeners();
  }

  void addQualificationUniversity(String value) {
    _qualificationUniversity.add(value);
    notifyListeners();
  }

  bool _validateValues() {
    clearError();
    if (usernameController.text.isEmpty) {
      usernameError = "This field is required.";
    }
    if (emailController.text.isEmpty || !emailController.text.isValidEmail()) {
      emailError = "Please enter a valid email";
    }
    if (numberController.text.isEmpty ||
        !numberController.text.isValidPhoneNumber()) {
      numberError = "Please enter a valid 10 digit phone number";
    }
    if (passwordController.text.isEmpty) {
      passwordError = "Password can't be empty.";
    } else if (!passwordController.text.isValidPassword()) {
      passwordError = "Please enter a valid password.";
    } else {
      if (password1Controller.text != passwordController.text) {
        password1Error = "Password doesn't match.";
      }
    }
    if (accountNumberController.text.isNotEmpty &&
        int.tryParse(accountNumberController.text) == null) {
      accountNumberError = "Please enter a valid Bank Account Number";
    }

    if (ifscController.text.isNotEmpty) {
      accountNumberError = "Please enter a valid IFSC Code";
    }
    if (qualifiedYearController.text.isNotEmpty) {
      qualifiedYearError = "Please enter a valid Year";
    }
    if (practicingExperienceController.text.isNotEmpty) {
      practicingExperienceError = "Please enter a valid Experience in Months";
    }
    if (expertServicesController.text.isNotEmpty) {
      practicingExperienceError = "Please enter a valid Experience in Months";
    }
    if (startingWorkHourController.text.isNotEmpty) {
      practicingExperienceError = "Please select starting work hours";
    }
    if (endingWorkHourController.text.isNotEmpty) {
      practicingExperienceError = "Please select ending work hours";
    }
    if (landlineController.text.isNotEmpty) {
      landlineError = "Please enter a valid Landline number";
    }
    if (mobileController.text.isNotEmpty &&
        !mobileController.text.isValidPhoneNumber()) {
      mobileError = "Please enter a valid mobile number";
    }

    return usernameError == null &&
        passwordError == null &&
        password1Error == null &&
        emailError == null &&
        numberError == null;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    password1Controller.dispose();
    numberController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

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

  void setStartingHour(TimeOfDay time) {
    startingWorkHourController.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  void setEndingHour(TimeOfDay time) {
    endingWorkHourController.text = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  Future<XFile?> pickFile(FilePickerResult? result) async {
    if (result != null) {
      final choosenFile = result.files.first;
      return XFile.fromData(choosenFile.bytes!, name: choosenFile.name);
    }
    return null;
  }

  Future<void> uploadPan({required XFile file}) async {
    try {
      panLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: '');
      _documents = _documents.copyWith(pan: downloadUrl);
    } catch (_) {
    } finally {
      panLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAadhar({required XFile file}) async {
    try {
      aadharLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: '');
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
          file: file, userID: '');
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
          file: file, userID: '');
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
          file: file, userID: '');
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
          file: file, userID: '');
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
          file: file, userID: '');
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
          file: file, userID: '');
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
          file: file, userID: '');
      _documents =
          _documents.copyWith(validityDateOfPracticeCertificate: downloadUrl);
    } catch (_) {
    } finally {
      validityDateOfPracticeCertificateLoading = false;
      notifyListeners();
    }
  }

  Future<String?> register() async {
    try {
      toggleLoadingOn(true);
      if (_validateValues()) {
        final result = await _authProvider.register(
          user: User(
            name: usernameController.text,
            userType: UserType.vendor,
            email: emailController.text,
            phoneNumber: int.parse(numberController.text),
          ),
          password: passwordController.text,
          streamUser: true,
        );
        return result.fold((l) async {
          Messenger.showSnackbar(l.message);
          return null;
        }, (r) async {
          Messenger.showSnackbar("Registered ✅");
          await saveProfileData(r.id!);
          return r.id;
        });
      }
      return null;
    } catch (e) {
      Messenger.showSnackbar(e.toString());
      return null;
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future<void> registerr(String userId) async {
    try {
      toggleLoadingOn(true);
      // if (_validateValues()) {
      final result = await _databaseRepositoryImpl.createVendorr(
        vendor: Vendor(
            id: userId,
            companyName: companyNameController.text,
            associateDetail: AssociateDetail(
                addressOfAssociate: associateAddressController.text,
                associateName: associateNameController.text,
                permanentAddress: associatePermanentAddressController.text),
            userID: userId,
            qualificationDegree: _qualificationDegree,
            qualificationUniversity: _qualificationUniversity,
            qualifiedYear: int.tryParse(qualifiedYearController.text),
            practiceExperience:
                int.tryParse(practicingExperienceController.text),
            expertServices: expertServicesController.text,
            workingHour: WorkingHour(
              startingHour: startingWorkHourController.text,
              endingHour: endingWorkHourController.text,
            ),
            bankAccount: BankInfo(
                accountNumber: accountNumberController.text,
                ifsc: ifscController.text),
            landline: int.tryParse(landlineController.text),
            mobile: int.tryParse(mobileController.text),
            documents: _documents),
      );
      return result.fold((l) async {
        Messenger.showSnackbar(l.message);
        // return null;
      }, (r) {
        Messenger.showSnackbar("Registered ✅");
        // return r;
      });
      // }
      // return null;
    } catch (e) {
      log("Failed profile:: ${e.toString()}");
      Messenger.showSnackbar(e.toString());
      // return null;
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future<void> saveVendorDeatils(String userId) async {
    try {
      // if (_validateValues()) {
      final result = await _databaseRepositoryImpl.createVendorr(
        vendor: Vendor(
            companyName: companyNameController.text,
            associateDetail: AssociateDetail(
                addressOfAssociate: associateAddressController.text,
                associateName: associateNameController.text,
                permanentAddress: associatePermanentAddressController.text),
            userID: userId,
            qualificationDegree: _qualificationDegree,
            qualificationUniversity: _qualificationUniversity,
            qualifiedYear: int.tryParse(qualifiedYearController.text),
            practiceExperience:
                int.tryParse(practicingExperienceController.text),
            expertServices: expertServicesController.text,
            workingHour: WorkingHour(
              startingHour: "startingWorkHourController.text",
              endingHour: endingWorkHourController.text,
            ),
            bankAccount: BankInfo(
                accountNumber: accountNumberController.text,
                ifsc: ifscController.text),
            landline: int.tryParse(landlineController.text),
            mobile: int.tryParse(mobileController.text),
            documents: _documents),
      );

      // await _databaseRepositoryImpl.createVendor(vendor: createVendor);

      Messenger.showSnackbar("Vendor Created ✅");
    } catch (e) {
      log("Failed to save profile:: ${e.toString()}");
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future<void> saveProfileData(String? id) async {
    try {
      toggleLoadingOn(true);

      // if (_user!.userType.name == UserType.vendor.name) {
      final updatedVendor = vendor!.copyWith(
        companyName: companyNameController.text,
        // permanentAddress: permanentAddressController.text,
        bankAccount: BankInfo(
            accountNumber: accountNumberController.text,
            ifsc: ifscController.text),
        associateDetail: AssociateDetail(
            addressOfAssociate: associateAddressController.text,
            associateName: associateNameController.text,
            permanentAddress: associatePermanentAddressController.text),
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
      await _databaseRepositoryImpl.updateVendorrr(
          vendor: updatedVendor, id: id!);

      Messenger.showSnackbar("Profile Updated ✅");
    } catch (e) {
      log("Failed to save profile:: ${e.toString()}");
    } finally {
      toggleLoadingOn(false);
    }
  }
}
