import 'package:cloud_firestore/cloud_firestore.dart';

// saferide models
import 'package:shared/models/saferide/order.dart';
import 'package:shared/models/saferide/driver.dart';

class SaferideProvider {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders_test');

  String? orderId;

  Map<String?, Driver>? _driversMap;

  //fill in the fields specified in order.dart with the orders collection in the firebase
  Future<Stream<DocumentSnapshot>> createOrder(
      {required DocumentReference user,
      required String pickupAddress,
      required GeoPoint pickupPoint,
      required String dropoffAddress,
      required GeoPoint dropoffPoint}) async {
    final ref = await orders.add({
      'status': 'WAITING',
      'pickup_address': pickupAddress,
      'pickup_point': pickupPoint,
      'dropoff_address': dropoffAddress,
      'dropoff_point': dropoffPoint,
      'rider': user,
      'updated_at': FieldValue.serverTimestamp()
    });
    orderId = ref.id;
    return ref.snapshots();
  }

  Future<void> cancelOrder() async {
    if (this.orderId != null) {
      DocumentReference ref = orders.doc(this.orderId);
      await ref.delete();
    }
  }

  Future<DocumentSnapshot> getOrder(String orderId) async {
    return orders.doc(orderId).get();
  }

  Future<int> getQueueSize() async {
    Query query = orders.where('status', isEqualTo: 'WAITING');
    return (await query.get()).size;
  }
}
