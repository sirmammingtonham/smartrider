import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  final String vehicleId;
  final String name;
  final String phone;
  final DocumentReference vehicleRef;

  Driver(
      {required this.vehicleId,
      required this.name,
      required this.phone,
      required this.vehicleRef});
}
