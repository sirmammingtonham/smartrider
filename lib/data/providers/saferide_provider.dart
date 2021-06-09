import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/saferide/driver.dart';
import '../models/saferide/order.dart';

class SaferideProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final HypertrackViewsFlutter hypertrack =
  //     HypertrackViewsFlutter(PUBLISHABLE_KEY);

  String? orderId;

  Map<String?, Driver>? _driversMap;

  //fill in the fields specified in order.dart with the orders collection in the firebase
  Future<Stream<DocumentSnapshot>> createOrder(Order order) async {
    CollectionReference orders = firestore.collection('orders');
    final ref = await orders.add({
      ...order.toJSON(),
      'created_at': FieldValue.serverTimestamp()
    }); // spread syntax
    orderId = ref.id;
    return ref.snapshots();
  }

  Future<void> cancelOrder() async {
    if (this.orderId != null) {
      DocumentReference orders =
          firestore.collection('orders').doc(this.orderId);
      await orders.delete();
    }
  }

  // Future<Map<String?, Driver>?> getDrivers() async {
  //   QuerySnapshot response = await firestore.collection('drivers').get();
  //   _driversMap = Map.fromIterable(response.docs,
  //       key: (doc) => doc['device_id'],
  //       value: (doc) => Driver.fromDocument(doc.data()));
  //   return _driversMap;
  // }

  Future<int> getOrderPosition(DocumentSnapshot snap) async {
    String id = snap.id;
    Query orders = firestore
        .collection('orders')
        .where('status', isEqualTo: 'NEW')
        .orderBy('created_at', descending: false);

    final response = await orders.get();
    return response.docs.map((doc) => doc.id).toList().indexOf(id);
  }

  Future<int> getQueueSize() async {
    Query orders =
        firestore.collection('orders').where('status', isEqualTo: 'NEW');
    return (await orders.get()).size;
  }
}
