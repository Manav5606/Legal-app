class AssociateDetail {
  final String? associateName;
  final String? addressOfAssociate;
  final String? permanentAddress;

  AssociateDetail({
    this.associateName,
    this.addressOfAssociate,
    this.permanentAddress,
  });

  factory AssociateDetail.fromMap(Map<String, dynamic> data) => AssociateDetail(
        addressOfAssociate: data['associate_address'],
        associateName: data['associate_name'],
        permanentAddress: data['permanent_address'],
      );

  Map<String, dynamic> toJson() => {
        "associate_address": addressOfAssociate,
        "associate_name": associateName,
        "permanent_address": permanentAddress,
      };

  AssociateDetail copyWith({
    String? associateName,
    String? addressOfAssociate,
    String? permanentAddress,
  }) =>
      AssociateDetail(
        addressOfAssociate: addressOfAssociate ?? this.addressOfAssociate,
        associateName: associateName ?? this.associateName,
        permanentAddress: permanentAddress ?? this.permanentAddress,
      );
}
