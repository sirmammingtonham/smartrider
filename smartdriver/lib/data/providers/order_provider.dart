import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver.dart';
import '../models/order.dart';

class OrderProvider {
  final FirebaseFirestore firestore;
  // dependency injection for unit testing
  OrderProvider({required this.firestore});

  Future<DocumentReference> acceptOrder(Driver driver, Order order) async {
    // need to use geolocator to provide updates on location and stuff probably (should go in its own bloc)
    await order.orderRef
        .update({'status': 'PICKING_UP', 'vehicle': driver.vehicleRef});
    await driver.vehicleRef.update({'current_order': order.orderRef});
    return order.orderRef;
  }

  Future<DocumentReference> declineOrder(Order order) async {
    return order.orderRef; // empty for now, might want custom logic
  }

  Future<DocumentReference> cancelOrder(Driver driver, Order order) async {
    await order.orderRef
        .update({'status': 'CANCELLED', 'vehicle': driver.vehicleRef});
    await driver.vehicleRef.update({'available': true});
    return order.orderRef;
  }
}