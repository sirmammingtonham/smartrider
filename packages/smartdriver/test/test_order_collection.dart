import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.collection('orders_test').add({
    'status': 'WAITING',
    'pickup': GeoPoint(-21.50872, 52.62132),
    'dropoff': GeoPoint(21.50872, -52.62132),
    'rider':
        FirebaseFirestore.instance.doc('users/t3P9MDIDp1dM1epa1872maQCXhA2'),
    'vehicle': null,
    'updated_at': FieldValue.serverTimestamp(),
    'estimated_pickup': null,
    'queue_position': null,
  });
}