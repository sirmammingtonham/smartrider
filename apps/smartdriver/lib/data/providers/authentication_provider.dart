import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartdriver/blocs/authentication/authentication_bloc.dart';
import 'package:shared/models/saferide/driver.dart';

class AuthenticationProvider {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  late Driver currentDriver;

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
      // TODO: plaintext pass for now, need to hash with bcrypt at some point
      if (vehicleSnapshot.exists && vehicleSnapshot['password'] == password) {
        vehicleSnapshot.reference.update({
          'available': true,
          'current_driver': {'name': name, 'phone_number': phoneNumber}
        });
        currentDriver = Driver(
            vehicleId: vehicleId,
            name: name,
            phone: phoneNumber,
            vehicleRef: vehicleSnapshot.reference);
        return currentDriver;
      } else {
        throw AuthenticationException(
            'incorrectCredentials: Incorrect vehicle ID and password combination!');
      }
    } on FirebaseAuthException catch (error) {
      throw AuthenticationException('${error.code}: ${error.message}');
    }
  }

  Future<void> tryLogout() async {
    return firebaseAuth.signOut();
  }
}
