import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:shared/models/saferide/order.dart';
import '../providers/order_provider.dart';

class OrderRepository {
  final OrderProvider authProvider =
      OrderProvider(firestore: FirebaseFirestore.instance);

  Future<DocumentReference> acceptOrder(
      Driver driver, DocumentReference orderRef) async {
    return authProvider.acceptOrder(driver, orderRef);
  }

  Future<DocumentReference> reachedPickupOrder(
      DocumentReference orderRef) async {
    return authProvider.reachedPickupOrder(orderRef);
  }

  Future<DocumentReference> reachedDropoffOrder(
      Driver driver, DocumentReference orderRef) async {
    return authProvider.reachedDropoffOrder(driver, orderRef);
  }

  Future<DocumentReference> declineOrder(Order order) async {
    return authProvider.declineOrder(order);
  }

  Future<DocumentReference> cancelOrder(
      Driver driver, Order order, String reason) async {
    return authProvider.cancelOrder(driver, order, reason);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get orderStream =>
      authProvider.orderStream;
}
