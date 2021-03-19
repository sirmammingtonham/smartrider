import 'package:cloud_firestore/cloud_firestore.dart';

// saferide imports
import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';
import 'package:smartrider/util/strings.dart';
// saferide models
import '../models/saferide/order.dart';
import '../models/saferide/driver.dart';

class SaferideProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final HypertrackViewsFlutter hypertrack =
      HypertrackViewsFlutter(PUBLISHABLE_KEY);

  //fill in the fields specified in order.dart with the orders collection in the firebase
  Future<void> createOrder(Order order) async {
    CollectionReference orders = firestore.collection('orders');
    await orders.add({
      'id': order.id,
      'status': order.status,
      'tripId': order.tripId,
      'pickup': order.pickup,
      'dropoff': order.dropoff,
      'rider': order.rider,
      'driver': order.driver,
      'createdAt': order.createdAt,
      'updatedAt': order.updatedAt
    });
  }

  Future<Map<String, Driver>> getDrivers() async {
    QuerySnapshot response = await firestore.collection('drivers').get();

    Map<String, Driver> driversMap = Map.fromIterable(response.docs,
        key: (doc) => doc['device_id'],
        value: (doc) => Driver.fromDocument(doc.data()));

    return driversMap;
  }

  Stream<MovementStatus> subscribeToDeviceUpdates(String deviceId) =>
      hypertrack.subscribeToDeviceUpdates(deviceId);
}
