import 'package:flutter/foundation.dart';
import 'package:smartrider/data/models/saferide/location_data.dart';
import 'package:smartrider/data/models/backend/user.dart';

class Order {
  String id;
  String status;
  String tripId;
  LocationData pickup;
  LocationData dropoff;
  User rider;
  User driver;
  DateTime createdAt;
  DateTime updatedAt;

  Order(
      {this.id,
      @required this.status,
      this.tripId,
      @required this.pickup,
      @required this.dropoff,
      @required this.rider,
      this.driver,
      this.createdAt,
      this.updatedAt});

  Order.fromDocument(doc) {
    this.id = doc['id'];
    this.status = doc['status'];
    this.tripId = doc['trip_id'];
    this.pickup = LocationData.fromDocument(doc['pickup']);
    this.dropoff = doc['dropoff'];
  }
}
