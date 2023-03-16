import 'package:admin/data/models/qualification.dart';

class Client {
  String? id;
  final String userID;
  final String companyName;
  final String permanentAddress;
  final String workingStartHours;
  final String workingEndHours;
  final int backAccountNumber;
  final String bankAccountIFSC;
  final String bankAccountName;
  final List<Qualification> qualification;

  Client({
    this.id,
    required this.userID,
    required this.companyName,
    required this.permanentAddress,
    required this.workingStartHours,
    required this.workingEndHours,
    required this.backAccountNumber,
    required this.bankAccountIFSC,
    required this.bankAccountName,
    required this.qualification,
  });
}
