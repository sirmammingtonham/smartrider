part of 'authentication_bloc.dart';

class AuthenticationException implements Exception {
  const AuthenticationException(this.message);
  final String message;
}
