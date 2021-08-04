import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/data/providers/authentication_provider.dart';

class AuthenticationRepository {
  AuthenticationRepository.create();

  final AuthenticationProvider _authProvider = AuthenticationProvider();

  User? get getCurrentUser => _authProvider.getCurrentUser;

  bool get isSignedIn => _authProvider.isSignedIn;
  bool get isEmailVerified => _authProvider.isEmailVerified;
  bool get isPhoneVerified => _authProvider.isPhoneVerified;

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
}
