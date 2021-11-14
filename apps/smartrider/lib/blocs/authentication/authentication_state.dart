part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationSignedOutState extends AuthenticationState {}

class AuthenticationSignedInState extends AuthenticationState {
  const AuthenticationSignedInState({
    required this.user,
  });

  final Rider user;

  @override
  List<Object> get props => [user];
}

class AuthenticationFailedState extends AuthenticationState {
  const AuthenticationFailedState({
    this.exception,
    required this.message,
  });

  final Exception? exception;
  final String message;

  @override
  List<Object?> get props => [exception, message];
}

//create phone reset state,
class AuthenticationVerifyPhoneState extends AuthenticationState {
  const AuthenticationVerifyPhoneState({
    required this.verificationId,
    required this.resendToken,
  });
  final String verificationId;
  final int? resendToken;
  @override
  List<Object?> get props => [verificationId, resendToken];
}
