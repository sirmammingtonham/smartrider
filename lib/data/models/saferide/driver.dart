import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  String vehicleId;
  String name;
  String phone;
  DocumentReference ref;

  Driver(
      {required this.vehicleId,
      required this.name,
      required this.phone,
      required this.ref});
}
