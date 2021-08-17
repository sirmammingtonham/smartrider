import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final RegExp _phoneRegex =
      RegExp(r'^(\+\d{1,2}\s)?(\(?\d{3}\)?)[\s.-]?(\d{3})[\s.-]?(\d{4})$');

  bool get isSignedIn => _firebaseAuth.currentUser != null;
  bool get isEmailVerified =>
      _firebaseAuth.currentUser != null &&
      _firebaseAuth.currentUser!.email != null;
  bool get isPhoneVerified =>
      _firebaseAuth.currentUser != null &&
      _firebaseAuth.currentUser!.phoneNumber != null;

  Stream<User?> get userChangeStream => _firebaseAuth.authStateChanges();

  User? get getCurrentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> signUp(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
// TODO: create URL back to app for email verification
        await userCredential.user!.sendEmailVerification();
      }
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  String _processPhoneNumber(String phoneNumber) {
    final matches = _phoneRegex.firstMatch(phoneNumber)!;
    if (matches.groupCount == 4) {
      return '+1 (${matches.group(2)})-${matches.group(3)}-${matches.group(4)}';
    } else {
      return '${matches.group(1)} '
          '(${matches.group(2)})-${matches.group(3)}-${matches.group(4)}';
    }
  }
}
