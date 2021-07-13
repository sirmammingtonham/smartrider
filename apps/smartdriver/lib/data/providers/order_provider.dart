import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:shared/models/saferide/order.dart';

class OrderProvider {
  final FirebaseFirestore firestore;
  // dependency injection for unit testing
  OrderProvider({required this.firestore});

  Stream<QuerySnapshot<Map<String, dynamic>>> get orderStream => firestore
      .collection('orders')
      .where('status', isEqualTo: 'WAITING')
      .snapshots();

  Future<DocumentReference> acceptOrder(
      Driver driver, DocumentReference orderRef) async {
    await orderRef
        .update({'status': 'PICKING_UP', 'vehicle': driver.vehicleRef});
    await driver.vehicleRef
        .update({'current_order': orderRef, 'available': false});
    return orderRef;
  }

  Future<DocumentReference> reachedPickupOrder(
      DocumentReference orderRef) async {
    await orderRef.update({'status': 'DROPPING_OFF'});
    return orderRef;
  }

  Future<DocumentReference> reachedDropoffOrder(
      Driver driver, DocumentReference orderRef) async {
    await orderRef.update(
        {'status': 'COMPLETED', 'completed_at': FieldValue.serverTimestamp()});
    await driver.vehicleRef.update({'available': true});
    return orderRef;
  }

  Future<DocumentReference> declineOrder(Order order) async {
    return order.orderRef; // empty for now, might want custom logic
  }

  Future<DocumentReference> cancelOrder(
      Driver driver, DocumentReference orderRef, String reason) async {
    await orderRef.update({
      'status': 'CANCELLED',
      'vehicle': driver.vehicleRef,
      'cancel_reason': reason
    });
    await driver.vehicleRef.update({'available': true});
    return orderRef;
  }
}
