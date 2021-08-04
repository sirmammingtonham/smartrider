import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared/models/saferide/position_data.dart';

// saferide models
// import 'package:shared/models/saferide/order.dart';
// import 'package:shared/models/saferide/driver.dart';

class SaferideProvider {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference vehicles =
      FirebaseFirestore.instance.collection('vehicles');
  final CollectionReference pastorders =
      FirebaseFirestore.instance.collection('pastorders');
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Map<String?, Driver>? _driversMap;

  // fill in the fields specified in order.dart
  // with the orders collection in the firebase
  Future<Stream<DocumentSnapshot>> createOrder(
      {required String pickupAddress,
      required GeoPoint pickupPoint,
      required String dropoffAddress,
      required GeoPoint dropoffPoint,
      required int estimateWaitTime}) async {
    final uid = auth.currentUser!.uid;
    final ref = orders.doc(uid);
    await ref.set({
      'status': 'WAITING',
      'pickup_address': pickupAddress,
      'pickup_point': pickupPoint,
      'dropoff_address': dropoffAddress,
      'dropoff_point': dropoffPoint,
      'rider': uid,
      'updated_at': FieldValue.serverTimestamp(),
      'estimated_pickup': estimateWaitTime,
      'pickup_time': DateTime.now().millisecondsSinceEpoch
    });
    return ref.snapshots();
  }

  Future<void> cancelOrder(DocumentReference order) async {
    await order.delete();
  }

  Future<DocumentSnapshot> getOrder(String orderId) async {
    return orders.doc(orderId).get();
  }

  Future<int> getQueueSize() async {
    final query = orders.where('status', isEqualTo: 'WAITING');
    return (await query.get()).size;
  }

  Future<int> estimateWaitTime(double distance) async {
    // get estimate wait time based on distance from caller
    final distanceInInt = convertDistance(distance);
    final snap = await pastorders.get();
    return snap.docs[0].get('$distanceInInt') as int;
  }

  int convertDistance(double distance) {
    // link for number scaling: https://stats.stackexchange.com/questions/281162/scale-a-number-between-a-range
    distance = distance.clamp(1.0, 3300.0);
    final distanceInInt = ((distance / 3300.0) * (5.0) + 0.0).ceil();
    return distanceInInt;
  }

  Future<void> updatePastOrders(double distance, int newTime) async {
    // estimate arrival time using exponential averaging: https://www.youtube.com/watch?v=k_HN0wOKDd0
    final distanceInInt = convertDistance(distance);
    final refs = await pastorders.get();
    final newminutes =
        ((DateTime.now().millisecondsSinceEpoch - newTime) / 60000)
            .ceil(); // time from order to pick up in minutes
    final A_old = await refs.docs[0].get('last$distanceInInt') as int;
    //the higher alpha, more emphasis is put on more recent data
    final alpha = await refs.docs[0].get('alpha') as double;
    final F_old = await estimateWaitTime(distance);
    final newEstimate = (alpha * A_old + (1 - alpha) * F_old).round();

    await refs.docs.first.reference
        .set({'last$distanceInInt': newminutes}, SetOptions(merge: true));
    await refs.docs.first.reference
        .set({'$distanceInInt': newEstimate}, SetOptions(merge: true));
  }

  Stream<List<PositionData>> getSaferideLocationsStream() =>
      vehicles.snapshots().map((snap) =>
          snap.docs.map((doc) => PositionData.fromDocSnapshot(doc)).toList());
}
