import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show required;
import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';

import '../models/saferide/driver.dart';
import '../models/saferide/order.dart';
import '../providers/saferide_provider.dart';

class SaferideRepository {
  final _saferideProvider = SaferideProvider();

  Future<Stream<DocumentSnapshot>> createOrder({@required Order order}) async =>
      _saferideProvider.createOrder(order);

  Future<Map<String, Driver>> get getDrivers async =>
      _saferideProvider.getDrivers();

  Future<MovementStatus> getDeviceUpdate(String deviceId) async =>
      _saferideProvider.getDeviceUpdate(deviceId);

  Stream<MovementStatus> subscribeToDeviceUpdates(String deviceId) =>
      _saferideProvider.subscribeToDeviceUpdates(deviceId);

  Future<Map<String, MovementStatus>> get getDriverUpdates async =>
      _saferideProvider.getDriverUpdates();

  Map<String, Stream<MovementStatus>> get getDriverUpdateSubscriptions =>
      _saferideProvider.getDriverUpdateSubscriptions();

  Future<int> getOrderPosition({@required DocumentSnapshot order}) async =>
      _saferideProvider.getOrderPosition(order);
}
