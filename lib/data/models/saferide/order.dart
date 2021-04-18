import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'driver.dart';
import 'estimate.dart';

enum TripStatus {
  NEW,
  ACCEPTED,
  REACHED_PICKUP,
  STARTED_RIDE,
  REACHED_DROPOFF,
  CANCELLED,
  UNDEFINED
}

class Order {
  String id;
  TripStatus status;
  String tripId;
  GeoPoint pickup;
  GeoPoint dropoff;
  String
      rider; // currently just email, TODO: add more stuff from the user's account like phone number, name, etc
  Driver driver;
  DateTime createdAt;
  DateTime updatedAt;
  int queuePosition;
  int waitEstimate;
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
      this.queuePosition,
      this.waitEstimate,
      this.estimate});

  Order.fromSnapshot(QueryDocumentSnapshot snap) {
    this.id = snap.id;

    final doc = snap.data();
    this.status = TripStatus.values.firstWhere(
        (value) => value.toString() == 'TripStatus.' + doc['status']);

    this.tripId = doc['trip_id'];
    this.pickup = doc['pickup'];
    this.dropoff = doc['dropoff'];

    this.rider = doc['rider'];
    this.driver = Driver.fromDocument(doc['driver']);

    this.createdAt = doc['created_at'];
    this.updatedAt = doc['updated_at'];

    this.queuePosition = doc['queue_position'];
    this.estimate = Estimate.fromDocument(doc['estimate']);

    this.waitEstimate = doc['wait_estimate'];
  }

  Map<String, dynamic> toJSON() {
    return {
      'status': this.status.toString(),
      'trip_id': this.tripId,
      'pickup': this.pickup,
      'dropoff': this.dropoff,
      'rider': this.rider,
      'driver': null, // TODO: add toJSON to driver object
      'created_at': this.createdAt,
      'updated_at': this.updatedAt,
      'queue_position': this.queuePosition,
      'estimate': null, // TODO: add toJSON to estimate object
      'wait_estimate': this.waitEstimate
    };
  }
}
