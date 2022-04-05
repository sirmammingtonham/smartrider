import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared/models/auth/rider.dart';
import 'package:smartrider/blocs/auth/data/auth_provider.dart';

class AuthRepository {
  AuthRepository._create() {
    _authProvider = AuthProvider();
  }

  late final AuthProvider _authProvider;

  bool get isSignedIn => _authProvider.isSignedIn;
  Rider? get getCurrentUser => _authProvider.currentUser;

  static RegExp get phoneRegex => AuthProvider.phoneRegex;

  Stream<User?> get userChangeStream => _authProvider.userChangeStream;

  /// Public factory
  static Future<AuthRepository> create() async {
    final self = AuthRepository._create();
    await self._authProvider.waitForLoad;
    return self;
  }

  Future<void> signOut() async => _authProvider.signOut();

  Future<Rider> signIn({
    required String token,
  }) async =>
      _authProvider.signIn(token);

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
      _authProvider.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

  Future<void> updatePhone({required String phoneNumber}) =>
      _authProvider.updatePhone(phoneNumber);

  String processPhoneNumber(String phoneNumber) =>
      _authProvider.processPhoneNumber(phoneNumber);
}
