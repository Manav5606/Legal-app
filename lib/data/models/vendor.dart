import 'package:admin/core/enum/qualification.dart';
import 'package:admin/data/models/associate_detail.dart';
import 'package:admin/data/models/bank_info.dart';
import 'package:admin/data/models/working_hour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  String? id;
  final String? userID;
  final String? companyName;
  final String? permanentAddress;
  final WorkingHour? workingHour;
  final BankInfo? bankAccount;
  final List<String> qualificationDegree;
  final List<String> qualificationUniversity;
  final AssociateDetail? associateDetail;
  final int? qualifiedYear;
  final int? practiceExperience;
  final String? expertServices;
  final int? landline;
  final int? mobile;
  final VendorDocuments? documents;

  Vendor({
    this.id,
    this.userID,
    this.companyName,
    this.permanentAddress,
    this.workingHour,
    this.bankAccount,
    this.expertServices,
    this.practiceExperience,
    this.qualifiedYear,
    this.associateDetail,
    this.qualificationDegree = const [],
    this.qualificationUniversity = const [],
    this.landline,
    this.mobile,
    this.documents,
  });

  Vendor copyWith({
    String? companyName,
    String? permanentAddress,
    WorkingHour? workingHour,
    BankInfo? bankAccount,
    List<String>? qualificationDegree,
    List<String>? qualificationUniversity,
    AssociateDetail? associateDetail,
    int? qualifiedYear,
    int? practiceExperience,
    String? expertServices,
    int? landline,
    int? mobile,
    VendorDocuments? documents,
  }) =>
      Vendor(
        id: id,
        associateDetail: associateDetail ?? this.associateDetail,
        bankAccount: bankAccount ?? this.bankAccount,
        companyName: companyName ?? this.companyName,
        documents: documents ?? this.documents,
        expertServices: expertServices ?? this.expertServices,
        landline: landline ?? this.landline,
        mobile: mobile ?? this.mobile,
        permanentAddress: permanentAddress ?? this.permanentAddress,
        practiceExperience: practiceExperience ?? this.practiceExperience,
        qualificationDegree: qualificationDegree ?? this.qualificationDegree,
        qualificationUniversity:
            qualificationUniversity ?? this.qualificationUniversity,
        qualifiedYear: qualifiedYear ?? this.qualifiedYear,
        userID: userID,
        workingHour: workingHour ?? this.workingHour,
      );

  factory Vendor.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = (snapshot.data() as Map<String, dynamic>);
    return Vendor(
      id: snapshot.id,
      userID: data['user_id'],
      companyName: data['company_name'],
      permanentAddress: data['permanent_address'],
      workingHour: data['working_hour'] == null
          ? null
          : WorkingHour.fromMap(data['working_hour']),
      bankAccount: data['bank_info'] == null
          ? null
          : BankInfo.fromMap(data['bank_info']),
      expertServices: data['expert_services'],
      qualifiedYear: data['qualified_year'],
      practiceExperience: data['practice_experience'],
      qualificationDegree:
          List<String>.from(data['qualification_degree'] ?? []),
      qualificationUniversity:
          List<String>.from(data['qualification_university'] ?? []),
      associateDetail: data['associate_detail'] == null
          ? null
          : AssociateDetail.fromMap(data['associate_detail']),
      mobile: data['mobile'],
      landline: data['landline'],
      documents: data['documents'] == null
          ? null
          : VendorDocuments.fromMap(data['documents']),
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userID,
        "company_name": companyName,
        "permanent_address": permanentAddress,
        "working_hour": workingHour?.toJson(),
        "bank_info": bankAccount?.toJson(),
        "expert_services": expertServices,
        "qualified_year": qualifiedYear,
        "practice_experience": practiceExperience,
        "qualification_university": qualificationUniversity,
        "qualification_degree": qualificationDegree,
        "associate_detail": associateDetail?.toJson(),
        "landline": landline,
        "mobile": mobile,
        "documents": documents?.toJson(),
      };
}

class VendorDocuments {
  final String? pan;
  final String? aadhar;
  final String? practiceCerti;
  final String? validityDateOfPracticeCertificate;
  final String? passPhoto;
  final String? powerBill;
  final String? nameBoard;
  final String? googleMap;
  final String? agreement;

  VendorDocuments({
    this.pan,
    this.aadhar,
    this.practiceCerti,
    this.validityDateOfPracticeCertificate,
    this.passPhoto,
    this.powerBill,
    this.nameBoard,
    this.googleMap,
    this.agreement,
  });

  VendorDocuments copyWith({
    String? pan,
    String? aadhar,
    String? practiceCerti,
    String? validityDateOfPracticeCertificate,
    String? passPhoto,
    String? powerBill,
    String? nameBoard,
    String? googleMap,
    String? agreement,
  }) =>
      VendorDocuments(
        aadhar: aadhar ?? this.aadhar,
        agreement: agreement ?? this.agreement,
        googleMap: googleMap ?? this.googleMap,
        nameBoard: nameBoard ?? this.nameBoard,
        pan: pan ?? this.pan,
        passPhoto: passPhoto ?? this.passPhoto,
        powerBill: powerBill ?? this.powerBill,
        practiceCerti: practiceCerti ?? this.practiceCerti,
        validityDateOfPracticeCertificate: validityDateOfPracticeCertificate ??
            this.validityDateOfPracticeCertificate,
      );

  factory VendorDocuments.fromMap(Map<String, dynamic> map) => VendorDocuments(
        pan: map['pan'],
        aadhar: map['aadhar'],
        practiceCerti: map['practice_certi'],
        validityDateOfPracticeCertificate:
            map['validity_date_of_practice_certificate'],
        passPhoto: map['pass_photo'],
        powerBill: map['power_bill'],
        nameBoard: map['name_board'],
        googleMap: map['google_map'],
        agreement: map['agreement'],
      );

  Map<String, dynamic> toJson() => {
        "pan": pan,
        "aadhar": aadhar,
        "practice_certi": practiceCerti,
        "validity_date_of_practice_certificate":
            validityDateOfPracticeCertificate,
        "pass_photo": passPhoto,
        "power_bill": powerBill,
        "name_board": nameBoard,
        "google_map": googleMap,
        "agreement": agreement,
      };
}
