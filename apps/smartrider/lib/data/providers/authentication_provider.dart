import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  bool get isSignedIn => _firebaseAuth.currentUser != null;

  Stream<User?> get userChangeStream => _firebaseAuth.authStateChanges();

  User? get getCurrentUser => _firebaseAuth.currentUser;

  DocumentReference? getCurrentUserRef() {
    if (_firebaseAuth.currentUser != null) {
      return _users.doc(getCurrentUser!.uid);
    }
  }

  Future<DocumentSnapshot?> getCurrentUserData() async {
    if (_firebaseAuth.currentUser != null) {
      return _users.doc(getCurrentUser!.uid).get();
    }
  }

  Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> signUp(
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (userCredential.user != null) {
// TODO: create URL back to app for email verification
// TODO: create a phone verification that happens before a user
// calls their first safe ride
        await userCredential.user!.sendEmailVerification();
        await _users.doc(userCredential.user!.uid).update({
          'email': email,
          'phone': phoneNumber,
          'phone_verified': false,
        });
      }
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
