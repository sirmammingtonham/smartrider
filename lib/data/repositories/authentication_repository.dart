import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/data/providers/authentication_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  AuthRepository.create();

  Future signInWithCredentials(String email, String password) async {
    return _authProvider.signInWithCredentials(email, password);
  }

  Future signUp(String email, String password) async {
    return _authProvider.signUp(email, password);
  }

  Future<void> signOut() async {
    return _authProvider.signOut();
  }

  bool get isSignedIn => _authProvider.isSignedIn();

  String get getUser => _authProvider.getUser();

  User get getActualUser => _authProvider.getActualUser();
}
