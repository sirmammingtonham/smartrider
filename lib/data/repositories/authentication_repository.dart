import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartdriver/data/models/saferide/driver.dart';
import 'package:smartdriver/data/providers/authentication_provider.dart';

class AuthenticationRepository {
  final AuthenticationProvider authProvider = AuthenticationProvider(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance);

  Future<Driver> tryLogin(
      {required String name,
      required String phoneNumber,
      required String vehicleId,
      required String password}) async {
    return authProvider.tryLogin(
        name: name,
        phoneNumber: phoneNumber,
        vehicleId: vehicleId,
        password: password);
  }

  Future<void> tryLogout() async {
    return;
  }
}
