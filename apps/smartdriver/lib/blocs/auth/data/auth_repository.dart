import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:smartdriver/blocs/auth/data/auth_provider.dart';

class AuthRepository {
  final AuthProvider authProvider = AuthProvider(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance);

  Driver? get currentDriver => authProvider.currentDriver;

  Future<Driver> trySignIn(
      {required String name,
      required String phoneNumber,
      required String vehicleId,
      required String password}) async {
    return authProvider.trySignIn(
        name: name,
        phoneNumber: phoneNumber,
        vehicleId: vehicleId,
        password: password);
  }

  Future<void> setAvailibility(bool available) async {
    await authProvider.setAvailibility(available);
  }

  Future<void> trySignOut() async {
    await authProvider.trySignOut();
  }
}
