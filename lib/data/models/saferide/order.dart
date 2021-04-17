import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'driver.dart';
import 'estimate.dart';

class Order {
  String id;
  String status;
  String tripId;
  GeoPoint pickup;
  GeoPoint dropoff;
  String
      rider; // currently just email, TODO: add more stuff from the user's account like phone number, name, etc
  Driver driver;
  DateTime createdAt;
  DateTime updatedAt;
  int queuePosition;
  Estimate estimate;

  Order(
      {this.id,
      @required this.status,
      this.tripId,
      @required this.pickup,
      @required this.dropoff,
      @required this.rider,
      this.driver,
      this.createdAt,
      this.updatedAt,
      this.queuePosition});

  Order.fromSnapshot(QueryDocumentSnapshot snap) {
    this.id = snap.id;

    final doc = snap.data();
    this.status = doc['status'];

    this.tripId = doc['trip_id'];
    this.pickup = doc['pickup'];
    this.dropoff = doc['dropoff'];

    this.rider = doc['rider'];
    this.driver = doc['driver'];

    this.createdAt = doc['created_at'];
    this.updatedAt = doc['updated_at'];

    this.queuePosition = doc['queue_position'];
    this.estimate = Estimate.fromDocument(doc['estimate']);
  }
}
