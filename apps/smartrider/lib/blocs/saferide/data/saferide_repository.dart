import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/saferide/vehicle.dart';
import 'package:smartrider/blocs/saferide/data/saferide_provider.dart';

class SaferideRepository {
  SaferideRepository.create();
  final _saferideProvider = SaferideProvider();

  Future<Stream<DocumentSnapshot>> createOrder({
    required String pickupAddress,
    required GeoPoint pickupPoint,
    required String dropoffAddress,
    required GeoPoint dropoffPoint,
    required double distance,
  }) async =>
      _saferideProvider.createOrder(
        pickupAddress: pickupAddress,
        pickupPoint: pickupPoint,
        dropoffAddress: dropoffAddress,
        dropoffPoint: dropoffPoint,
        distance: distance,
      );

  Future<void> cancelOrder(DocumentReference order) async =>
      _saferideProvider.cancelOrder(order);

  Future<DocumentSnapshot> getOrder(String orderId) async =>
      _saferideProvider.getOrder(orderId);

  Future<int> getQueueSize() async => _saferideProvider.getQueueSize();

  Stream<List<Vehicle>> getSaferideLocationsStream() =>
      _saferideProvider.getSaferideLocationsStream();

  Future<int> estimateWaitTime(double distance) async =>
      _saferideProvider.estimateWaitTime(distance);

  Future<void> updatePastOrders(double distance, int pickupTime) async =>
      _saferideProvider.updatePastOrders(distance, pickupTime);
}
