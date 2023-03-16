import 'package:admin/core/enum/field_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  final String id;
  final String serviceID;
  final String fieldName;
  final FieldType fieldType;

  ServiceRequest({
    required this.id,
    required this.serviceID,
    required this.fieldName,
    required this.fieldType,
  });

  factory ServiceRequest.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ServiceRequest(
      id: documentSnapshot.id,
      serviceID: data['service_id'],
      fieldName: data['field_name'],
      fieldType: data['field_type'],
    );
  }
}
