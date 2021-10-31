import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final RegExp phoneRegex = RegExp(
    r'(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?',
  );

  bool get isSignedIn => _firebaseAuth.currentUser != null;
  bool get isEmailVerified =>
      _firebaseAuth.currentUser != null &&
      _firebaseAuth.currentUser!.email != null &&
      _firebaseAuth.currentUser!.email!.isNotEmpty;
  bool get isPhoneVerified =>
      _firebaseAuth.currentUser != null &&
      _firebaseAuth.currentUser!.phoneNumber != null &&
      _firebaseAuth.currentUser!.phoneNumber!.isNotEmpty;

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

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
  }) =>
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: processPhoneNumber(phoneNumber),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

  String processPhoneNumber(String phoneNumber) {
    final matches = phoneRegex.firstMatch(phoneNumber)!;
    if (matches.group(1) == null) {
      return '+1 (${matches.group(2)})-${matches.group(3)}-${matches.group(4)}';
    } else {
      return '+${matches.group(1)} '
          '(${matches.group(2)})-${matches.group(3)}-${matches.group(4)}';
    }
  }
}
