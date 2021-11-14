import 'dart:async';
import 'package:shared/models/auth/rider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/blocs/authentication/data/authentication_provider.dart';

class AuthenticationRepository {
  AuthenticationRepository._create() {
    _authProvider = AuthenticationProvider();
  }

  late final AuthenticationProvider _authProvider;

  bool get isSignedIn => _authProvider.isSignedIn;
  Rider? get getCurrentUser => _authProvider.currentUser;

  static RegExp get phoneRegex => AuthenticationProvider.phoneRegex;

  Stream<User?> get userChangeStream => _authProvider.userChangeStream;

/// Public factory
  static Future<AuthenticationRepository> create() async {
    final self = AuthenticationRepository._create();
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

  String processPhoneNumber(String phoneNumber) =>
      _authProvider.processPhoneNumber(phoneNumber);
}
