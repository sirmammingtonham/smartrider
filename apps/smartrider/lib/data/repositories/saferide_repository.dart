import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';

import 'package:shared/models/saferide/driver.dart';
import 'package:shared/models/saferide/order.dart';
import '../providers/saferide_provider.dart';

class SaferideRepository {
  final _saferideProvider = SaferideProvider();

  SaferideRepository.create();

  Future<Stream<DocumentSnapshot>> createOrder(
          {required DocumentReference user,
          required String pickupAddress,
          required GeoPoint pickupPoint,
          required String dropoffAddress,
          required GeoPoint dropoffPoint}) async =>
      _saferideProvider.createOrder(
          user: user,
          pickupAddress: pickupAddress,
          pickupPoint: pickupPoint,
          dropoffAddress: dropoffAddress,
          dropoffPoint: dropoffPoint);

  Future<void> cancelOrder() async => _saferideProvider.cancelOrder();

  // Future<Map<String?, Driver>?> get getDrivers async =>
  //     _saferideProvider.getDrivers();

  // Future<MovementStatus> getDeviceUpdate(String deviceId) async =>
  //     _saferideProvider.getDeviceUpdate(deviceId);

  // Stream<MovementStatus> subscribeToDeviceUpdates(String deviceId) =>
  //     _saferideProvider.subscribeToDeviceUpdates(deviceId);

  // Future<Map<String?, MovementStatus>> get getDriverUpdates async =>
  //     _saferideProvider.getDriverUpdates();

  // Future<int> get getQueueSize async => _saferideProvider.getQueueSize();

  // Map<String?, Stream<MovementStatus>> get getDriverUpdateSubscriptions =>
  //     _saferideProvider.getDriverUpdateSubscriptions();

//   Future<int> getOrderPosition({required DocumentSnapshot order}) async =>
//       _saferideProvider.getOrderPosition(order);
}
