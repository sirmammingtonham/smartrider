import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vehicle {
  Vehicle({
    required this.ref,
    required this.active,
    required this.currentDriver,
    required this.currentOrder,
    required this.licensePlate,
    required this.positionData,
  });

  factory Vehicle.fromDocSnapshot(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Vehicle(
      ref: doc.reference,
      active: data['available'] as bool,
      licensePlate: data['license_plate'] as String,
      currentDriver:
          Driver.fromJson(data['current_driver'] as Map<String, dynamic>),
      currentOrder: data['current_order'] as DocumentReference,
      positionData:
          PositionData.fromJson(data['position_data'] as Map<String, dynamic>),
    );
  }

  final DocumentReference ref;
  final bool active;
  final Driver currentDriver;
  final DocumentReference currentOrder;
  final String licensePlate;
  final PositionData positionData;

  LatLng get latLng => positionData.latLng;
  String get id => ref.id;
  double get mph => positionData.speed / 0.44704;
}

class Driver {
  Driver({
    required this.name,
    required this.phone,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'] as String,
      phone: json['phone_number'] as String,
    );
  }

  final String name;
  final String phone;
}

class PositionData {
  PositionData({
    required this.heading,
    required this.location,
    required this.speed,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) {
    return PositionData(
      heading: json['heading'] as double,
      location: json['location'] as GeoPoint,
      speed: json['speed'] as double,
    );
  }

  final double heading;
  final GeoPoint location;
  final double speed;

  LatLng get latLng => LatLng(location.latitude, location.longitude);
}
