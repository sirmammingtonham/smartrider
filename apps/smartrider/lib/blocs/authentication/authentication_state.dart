part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationEmailVerificationState extends AuthenticationState {}

class AuthenticationSignedOutState extends AuthenticationState {}

class AuthenticationSignedInState extends AuthenticationState {
  const AuthenticationSignedInState({
    required this.user,
    required this.email,
    required this.phoneNumber,
    required this.phoneVerified,
  });

  final User user;
  final String email, phoneNumber;
  final bool phoneVerified;

  @override
  List<Object> get props => [user, email, phoneNumber, phoneVerified];
}

class AuthenticationFailedState extends AuthenticationState {
  const AuthenticationFailedState({
    required this.exception,
    required this.message,
  });

  final FirebaseAuthException exception;
  final String message;

  @override
  List<Object> get props => [exception, message];
}
