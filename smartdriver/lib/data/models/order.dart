import 'package:cloud_firestore/cloud_firestore.dart';

/// shouldn't be used, just here to show the different status enum values
enum _OrderStatus { WAITING, PICKING_UP, DROPPING_OFF, CANCELLED, ERROR }

class Order {
  /// reference to the order in firestore
  final DocumentReference orderRef;

  /// status enum
  final String status;

  /// pickup point
  final GeoPoint pickup;

  /// dropoff point
  final GeoPoint dropoff;

  /// reference to rider's document in users collection
  final DocumentReference rider;

  /// reference to the assigned vehicle (null when status == WATIING)
  final DocumentReference? vehicleRef;

  /// timestamp of when the order was last updated
  /// (doesn't account for queue position updates)
  final Timestamp updatedAt;

  /// timestamp of estimated pickup (when status == PICKUP_UP)
  final Timestamp? estimatedPickup;

  /// queue position, updated on writes through cloud functions
  final int queuePosition;

  Order(
      {required this.orderRef,
      required this.status,
      required this.pickup,
      required this.dropoff,
      required this.rider,
      this.vehicleRef,
      required this.updatedAt,
      this.estimatedPickup,
      required this.queuePosition});

  factory Order.fromSnapshot(DocumentSnapshot snap) {
    return Order(
      orderRef: snap.reference,
      status: snap.get('status'),
      pickup: snap.get('pickup'),
      dropoff: snap.get('dropoff'),
      rider: snap.get('rider'),
      vehicleRef: snap['vehicle_reference'],
      updatedAt: snap.get('updated_at'),
      estimatedPickup: snap['estimated_pickup'],
      queuePosition: snap.get('queue_position'),
    );
  }
}
