import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';

import '../models/saferide/order.dart';
import '../providers/saferide_provider.dart';

class SaferideRepository {
  final _saferideProvider = SaferideProvider();

  Future<void> createOrder(Order order) async =>
      _saferideProvider.createOrder(order);

  Stream<MovementStatus> subscribeToDeviceUpdates(String deviceId) =>
      _saferideProvider.subscribeToDeviceUpdates(deviceId);
}
