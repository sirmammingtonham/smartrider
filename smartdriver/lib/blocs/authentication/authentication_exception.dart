part of 'authentication_bloc.dart';

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}
