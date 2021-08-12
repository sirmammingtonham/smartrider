import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:shared/models/saferide/order.dart';
import 'package:smartdriver/blocs/order/data/order_provider.dart';

class OrderRepository {
  final OrderProvider orderProvider =
      OrderProvider(firestore: FirebaseFirestore.instance);

  Future<DocumentReference> acceptOrder(
      Driver driver, DocumentReference orderRef) async {
    return orderProvider.acceptOrder(driver, orderRef);
  }

  Future<DocumentReference> reachedPickupOrder(
      DocumentReference orderRef) async {
    return orderProvider.reachedPickupOrder(orderRef);
  }

  Future<DocumentReference> reachedDropoffOrder(
      Driver driver, DocumentReference orderRef) async {
    return orderProvider.reachedDropoffOrder(driver, orderRef);
  }

  Future<DocumentReference> declineOrder(Order order) async {
    return orderProvider.declineOrder(order);
  }

  Future<DocumentReference> cancelOrder(
      Driver driver, DocumentReference orderRef, String reason) async {
    return orderProvider.cancelOrder(driver, orderRef, reason);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get orderStream =>
      orderProvider.orderStream;
}
