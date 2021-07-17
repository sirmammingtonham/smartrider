import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PositionData {
  PositionData(
      {required this.active,
      required this.heading,
      required this.location,
      required this.speed,
      required this.vehicleRef});

  factory PositionData.fromDocSnapshot(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Map<String, dynamic> position = data['position_data'];
    return PositionData(
        active: data['available'],
        heading: position['heading'],
        location: position['location'],
        speed: position['speed'],
        vehicleRef: doc.reference);
  }

  final bool active;
  final double heading;
  final GeoPoint location;
  final double speed;
  final DocumentReference vehicleRef;

  LatLng get latLng => LatLng(location.latitude, location.longitude);
  String get id => vehicleRef.id;
  double get mph => speed / 0.44704;
}
