import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final defaultRoutes = ['87-185', '286-185', '289-185'];

FirebaseFirestore firestore = FirebaseFirestore.instance;

/// Fetchs data from the JSON API and returns a decoded JSON.
Future<QuerySnapshot> fetch(String collection,
    {String idField, List routes}) async {
  return firestore
      .collection(collection)
      .where(idField, arrayContainsAny: routes)
      .get();
}

main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  print(await fetch('routes', idField: 'route_id', routes: defaultRoutes));
}
