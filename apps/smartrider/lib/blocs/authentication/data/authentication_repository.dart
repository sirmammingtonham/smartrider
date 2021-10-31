import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/blocs/authentication/data/authentication_provider.dart';

class AuthenticationRepository {
  AuthenticationRepository.create();

  final AuthenticationProvider _authProvider = AuthenticationProvider();

  User? get getCurrentUser => _authProvider.getCurrentUser;

  bool get isSignedIn => _authProvider.isSignedIn;
  bool get isEmailVerified => _authProvider.isEmailVerified;
  bool get isPhoneVerified => _authProvider.isPhoneVerified;
  static RegExp get phoneRegex => AuthenticationProvider.phoneRegex;

  Stream<User?> get userChangeStream => _authProvider.userChangeStream;

  Future<void> signOut() async => _authProvider.signOut();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async =>
      _authProvider.signIn(email, password);

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async =>
      _authProvider.signUp(email, password);

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
