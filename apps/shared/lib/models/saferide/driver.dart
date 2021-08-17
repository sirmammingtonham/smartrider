import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  Driver(
      {required this.vehicleId,
      required this.name,
      required this.phone,
      required this.vehicleRef});

  final String vehicleId;
  final String name;
  final String phone;
  final DocumentReference vehicleRef;
}
