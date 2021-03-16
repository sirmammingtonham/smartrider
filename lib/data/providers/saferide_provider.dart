import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Saferide models
import '../models/saferide/location_data.dart';
import '../models/saferide/order.dart';

class SaferideProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createOrder(Order order) async {
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');
      orders.add({
        'id': order.id,
        'status': order.status,
        'tripId': order.tripId,
        'pickup': order.pickup,
        'dropoff': order.dropoff,
        'rider': order.rider,
        'driver': order.driver,
        'createdAt': order.createdAt,
        'updatedAt': order.updatedAt
      })
      .then((value)=> print("Order successfully added."))
      .catchError((error) => print("Failed to add order: $error"));
  }

}