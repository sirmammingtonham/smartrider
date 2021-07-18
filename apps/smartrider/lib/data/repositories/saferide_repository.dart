import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/saferide/position_data.dart';
import '../providers/saferide_provider.dart';

class SaferideRepository {
  SaferideRepository.create();
  final _saferideProvider = SaferideProvider();

  Future<Stream<DocumentSnapshot>> createNewOrder(
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

  Future<void> cancelOrder(DocumentReference order) async =>
      _saferideProvider.cancelOrder(order);

  Future<DocumentSnapshot> getOrder(String orderId) async =>
      _saferideProvider.getOrder(orderId);

  Stream<List<PositionData>> getSaferideLocationsStream() =>
      _saferideProvider.getSaferideLocationsStream();
}
