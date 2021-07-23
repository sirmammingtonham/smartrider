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
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Map<String?, Driver>? _driversMap;

  // fill in the fields specified in order.dart
  // with the orders collection in the firebase
  Future<Stream<DocumentSnapshot>> createOrder(
      {required DocumentReference user,
      required String pickupAddress,
      required GeoPoint pickupPoint,
      required String dropoffAddress,
      required GeoPoint dropoffPoint}) async {
    final ref = orders.doc(auth.currentUser!.uid);
    await ref.set({
      'status': 'WAITING',
      'pickup_address': pickupAddress,
      'pickup_point': pickupPoint,
      'dropoff_address': dropoffAddress,
      'dropoff_point': dropoffPoint,
      'rider': user,
      'updated_at': FieldValue.serverTimestamp()
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

  Stream<List<PositionData>> getSaferideLocationsStream() =>
      vehicles.snapshots().map((snap) =>
          snap.docs.map((doc) => PositionData.fromDocSnapshot(doc)).toList());
}
