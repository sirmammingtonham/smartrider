import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

  Map<String, Driver> _driversMap;

  //fill in the fields specified in order.dart with the orders collection in the firebase
  Future<Stream<DocumentSnapshot>> createOrder(Order order) async {
    CollectionReference orders = firestore.collection('orders');
    final ref = await orders.add({
      'status': order.status,
      'tripId': order.tripId,
      'pickup': order.pickup,
      'dropoff': order.dropoff,
      'rider': order.rider,
      'driver': order.driver,
      'createdAt': order.createdAt,
      'updatedAt': order.updatedAt
    });
    return ref.snapshots();
  }

  Future<Map<String, Driver>> getDrivers() async {
    QuerySnapshot response = await firestore.collection('drivers').get();

    _driversMap = Map.fromIterable(response.docs,
        key: (doc) => doc['device_id'],
        value: (doc) => Driver.fromDocument(doc.data()));
    return _driversMap;
  }

  Future<MovementStatus> getDeviceUpdate(String deviceId) async =>
      await hypertrack.getDeviceUpdate(deviceId);

  Stream<MovementStatus> subscribeToDeviceUpdates(String deviceId) =>
      hypertrack.subscribeToDeviceUpdates(deviceId);

  Future<Map<String, MovementStatus>> getDriverUpdates() async {
    assert(_driversMap != null);

    Map<String, MovementStatus> updates = {};
    for (String id in _driversMap.keys) {
      try {
        updates[id] = await hypertrack.getDeviceUpdate(id);
      } on PlatformException catch (e) {
        // TODO: better error handling
        // (not really an error, just signals the device is inactive)
        // should probably update hypertrack views library to not
        // raise exception in this case?
        print(e);
      }
    }
    return updates;
  }

  Map<String, Stream<MovementStatus>> getDriverUpdateSubscriptions() {
    assert(_driversMap != null);

    return Map.fromIterable(_driversMap.keys,
        key: (id) => id,
        value: (id) => hypertrack
            .subscribeToDeviceUpdates(id)
            .skipWhile((status) => status.deviceId == null));
  }

  Future<int> getOrderPosition(DocumentSnapshot snap) async {
    String id = snap.id;
    Query orders = firestore
        .collection('orders')
        .where('status', isEqualTo: 'NEW')
        .orderBy('createdAt', descending: false);

    final response = await orders.get();
    return response.docs.map((doc) => doc.id).toList().indexOf(id);
  }
}
