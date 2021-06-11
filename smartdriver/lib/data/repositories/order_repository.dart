import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/driver.dart';
import '../../data/models/order.dart';
import '../providers/order_provider.dart';

class OrderRepository {
  final OrderProvider authProvider =
      OrderProvider(firestore: FirebaseFirestore.instance);

  Future<DocumentReference> acceptOrder(Driver driver, Order order) async {
    return authProvider.acceptOrder(driver, order);
  }

  Future<DocumentReference> declineOrder(Order order) async {
    return authProvider.declineOrder(order);
  }

  Future<DocumentReference> cancelOrder(Driver driver, Order order) async {
    return authProvider.cancelOrder(driver, order);
  }
}
