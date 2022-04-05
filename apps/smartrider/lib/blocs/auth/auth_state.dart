part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthSignedOutState extends AuthState {}

class AuthSignedInState extends AuthState {
  const AuthSignedInState({
    required this.user,
  });

  final Rider user;

  @override
  List<Object> get props => [user];
}

class AuthFailedState extends AuthState {
  const AuthFailedState({
    this.exception,
    required this.message,
  });

  final Exception? exception;
  final String message;

  @override
  List<Object?> get props => [exception, message];
}

//create phone reset state,
class AuthVerifyPhoneState extends AuthState {
  const AuthVerifyPhoneState({
    required this.verificationId,
    required this.resendToken,
  });
  final String verificationId;
  final int? resendToken;
  @override
  List<Object?> get props => [verificationId, resendToken];
}
