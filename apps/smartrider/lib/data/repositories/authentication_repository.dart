import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/data/providers/authentication_provider.dart';

class AuthenticationRepository {
  AuthenticationRepository.create();

  final AuthenticationProvider _authProvider = AuthenticationProvider();

  User? get getCurrentUser => _authProvider.getCurrentUser;

  DocumentReference? get getCurrentUserRef => _authProvider.getCurrentUserRef();
  Future<DocumentSnapshot?> get getCurrentUserData async =>
      _authProvider.getCurrentUserData();

  bool get isSignedIn => _authProvider.isSignedIn;

  Stream<User?> get userChangeStream => _authProvider.userChangeStream;

  Future<void> signOut() async => _authProvider.signOut();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async =>
      _authProvider.signIn(email, password);

  Future<UserCredential> signUp({
    required String email,
    required String phoneNumber,
    required String password,
  }) async =>
      _authProvider.signUp(email, phoneNumber, password);
}
