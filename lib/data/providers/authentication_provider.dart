import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartdriver/blocs/authentication/authentication_exception.dart';
import 'package:smartdriver/data/models/saferide/driver.dart';

class AuthenticationProvider {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  // dependency injection for unit testing
  AuthenticationProvider({required this.firestore, required this.firebaseAuth});

  Future<Driver> tryLogin(
      {required String name,
      required String phoneNumber,
      required String vehicleId,
      required String password}) async {
    try {
      // might have to use cloud functions to generate a unique token instead of doing all this (more secure)
      await firebaseAuth.signInAnonymously();

      // user should have access to orders and vehicles collection now
      final vehicleSnapshot = await firestore.doc('vehicles/$vehicleId').get();
      if (vehicleSnapshot.exists) {
        vehicleSnapshot.reference
            .update({'available': true, 'name': name, 'phone': phoneNumber});
        return Driver(
            vehicleId: vehicleId,
            name: name,
            phone: phoneNumber,
            ref: vehicleSnapshot.reference);
      } else {
        throw AuthenticationException(
            'vehicleDoesNotExist: Vehicle ID doesn\'t exist in database!');
      }
    } on FirebaseAuthException catch (error) {
      throw AuthenticationException('${error.code}: ${error.message}');
    }
  }

  Future<void> tryLogout() async {
    return firebaseAuth.signOut();
  }
}
