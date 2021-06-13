import 'package:cloud_firestore/cloud_firestore.dart';

/// shouldn't be used, just here to show the different status enum values
enum _OrderStatus { WAITING, PICKING_UP, DROPPING_OFF, CANCELLED, ERROR }

class Order {
  /// reference to the order in firestore
  final DocumentReference orderRef;

  /// status enum
  final String status;

  /// pickup
  final String pickupAddress;
  final GeoPoint pickupPoint;

  /// dropoff
  final String dropoffAddress;
  final GeoPoint dropoffPoint;

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
  final int? queuePosition;

  /// cancellation reason if status == CANCELLED else null
  final String? cancellationReason;

  Order(
      {required this.orderRef,
      required this.status,
      required this.pickupAddress,
      required this.pickupPoint,
      required this.dropoffAddress,
      required this.dropoffPoint,
      required this.rider,
      this.vehicleRef,
      required this.updatedAt,
      this.estimatedPickup,
      required this.queuePosition,
      this.cancellationReason});

  Future<String> get riderName async => (await rider.get()).get('name');

  factory Order.fromSnapshot(DocumentSnapshot snap) {
    return Order(
        orderRef: snap.reference,
        status: snap.get('status'),
        pickupAddress: snap.get('pickup_address'),
        dropoffAddress: snap.get('dropoff_address'),
        pickupPoint: snap.get('pickup_point'),
        dropoffPoint: snap.get('dropoff_point'),
        rider: snap.get('rider'),
        vehicleRef: snap.get('vehicle'),
        updatedAt: snap.get('updated_at'),
        estimatedPickup: snap.get('estimated_pickup'),
        queuePosition: snap.get('queue_position'),
        cancellationReason: snap.get('status') == 'CANCELLED'
            ? snap.get('cancel_reason')
            : null);
  }
}
