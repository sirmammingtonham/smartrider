part of 'auth_bloc.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}
