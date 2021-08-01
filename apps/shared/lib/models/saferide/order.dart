import 'package:cloud_firestore/cloud_firestore.dart';

/// shouldn't be used, just here to show the different status enum values
// enum _OrderStatus
// { WAITING, PICKING_UP, DROPPING_OFF, COMPLETED, CANCELLED, ERROR }

class Order {
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
      required this.pickupTime,
      this.cancellationReason,
      });

  factory Order.fromSnapshot(DocumentSnapshot snap) {
    final data = (snap.data()! as Map<String, dynamic>);
    return Order(
        orderRef: snap.reference,
        status: data['status']!,
        pickupAddress: data['pickup_address']!,
        dropoffAddress: data['dropoff_address']!,
        pickupPoint: data['pickup_point']!,
        dropoffPoint: data['dropoff_point']!,
        rider: data['rider']!,
        vehicleRef: data['vehicle'],
        updatedAt: data['updated_at']!,
        estimatedPickup: data['estimated_pickup'],
        queuePosition: data['queue_position'],
        pickupTime: data['pickup_time'],
        cancellationReason:
            data['status'] == 'CANCELLED' ? data['cancel_reason'] : null);
  }

  /// reference to the order in firestore
  final DocumentReference orderRef;

  /// status enum
  final String status;

  /// pickup
  final String pickupAddress;
  final GeoPoint pickupPoint;
  final int pickupTime;
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
  final int? estimatedPickup;

  /// queue position, updated on writes through cloud functions
  final int? queuePosition;

  /// cancellation reason if status == CANCELLED else null
  final String? cancellationReason;
}
