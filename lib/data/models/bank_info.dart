class BankInfo {
  final String? accountNumber;
  final String? ifsc;

  BankInfo({
    this.accountNumber,
    this.ifsc,
  });

  factory BankInfo.fromMap(Map<String, dynamic> map) => BankInfo(
        accountNumber: map['account_number'],
        ifsc: map['ifscode'],
      );

  Map<String, dynamic> toJson() => {
        "account_number": accountNumber,
        "ifscode": ifsc,
      };
}
