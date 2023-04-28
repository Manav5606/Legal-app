import 'package:admin/core/enum/field_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  String? id;
  final String serviceID;
  final String fieldName;
  final ServiceFieldType fieldType;
  final int? createdAt;
  final String createdBy;
  final String? value;

  ServiceRequest({
    this.id,
    required this.serviceID,
    required this.fieldName,
    required this.fieldType,
    this.createdAt,
    required this.createdBy,
    this.value,
  });

  factory ServiceRequest.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ServiceRequest(
      id: documentSnapshot.id,
      serviceID: data['service_id'],
      fieldName: data['field_name'],
      fieldType: ServiceFieldType.values.firstWhere(
          (element) => element.name == data['field_type'],
          orElse: () => ServiceFieldType.text),
      createdBy: data['created_by'],
      createdAt: data['created_at'],
      value: data['value'],
    );
  }
  factory ServiceRequest.fromData(Map<String, dynamic> data) {
    return ServiceRequest(
      serviceID: data['service_id'],
      fieldName: data['field_name'],
      fieldType: ServiceFieldType.values.firstWhere(
          (element) => element.name == data['field_type'],
          orElse: () => ServiceFieldType.text),
      createdBy: data['created_by'],
      createdAt: data['created_at'],
      value: data['value'],
    );
  }

  ServiceRequest copyWith({
    String? serviceID,
    String? fieldName,
    ServiceFieldType? fieldType,
    String? value,
  }) =>
      ServiceRequest(
        serviceID: serviceID ?? this.serviceID,
        fieldName: fieldName ?? this.fieldName,
        fieldType: fieldType ?? this.fieldType,
        value: value ?? this.value,
        createdBy: createdBy,
        createdAt: createdAt,
        id: id,
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceID,
        "field_name": fieldName,
        "field_type": fieldType.name,
        "created_by": createdBy,
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
      };
  Map<String, dynamic> toOrderJson() => {
        "service_id": serviceID,
        "field_name": fieldName,
        "field_type": fieldType.name,
        "created_by": createdBy,
        "created_at": createdAt ?? DateTime.now().millisecondsSinceEpoch,
        "value": value,
      };
}
