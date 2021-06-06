import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'driver.dart';
import 'estimate.dart';

enum TripStatus {
  NEW,
  PICKING_UP,
  REACHED_PICKUP,
  DROPPING_OFF,
  REACHED_DROPOFF,
  CANCELLED,
  UNDEFINED
}

class Order {
  String? id;
  TripStatus? status;
  String? tripId;
  GeoPoint? pickup;
  GeoPoint? dropoff;
  String?
      rider; // currently just email, TODO: add more stuff from the user's account like phone number, name, etc
  Driver? driver;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  int? queuePosition;
  int? waitEstimate;
  Estimate? estimate;

  Order(
      {this.id,
      required this.status,
      this.tripId,
      required this.pickup,
      required this.dropoff,
      required this.rider,
      this.driver,
      this.createdAt,
      this.updatedAt,
      this.queuePosition,
      this.waitEstimate,
      this.estimate});

  Order.fromSnapshot(DocumentSnapshot snap) {
    this.id = snap.id;
    this.status = TripStatus.values.firstWhere(
        (value) => value.toString() == 'TripStatus.' + snap.get('status'),
        orElse: () => TripStatus.UNDEFINED);

    this.tripId = snap.get('trip_id');
    this.pickup = snap.get('pickup');
    this.dropoff = snap.get('dropoff');

    this.rider = snap.get('rider');

    if (snap.get('driver') != null)
      this.driver = Driver.fromDocument(snap.get('driver'));

    this.createdAt = snap.get('created_at');
    this.updatedAt = snap.get('updated_at');

    this.queuePosition = snap.get('queue_position');
    if (snap.get('estimate') != null) {
      this.estimate = Estimate.fromDocument(snap.get('estimate'));

      this.waitEstimate = snap.get('wait_estimate');
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      'status': this.status.toString().substring(11),
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
