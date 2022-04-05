part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitEvent extends AuthEvent {}

class AuthSignInEvent extends AuthEvent {
  const AuthSignInEvent({
    required this.token,
  });
  final String token;

  @override
  List<Object> get props => [token];
}

class AuthResetPhoneEvent extends AuthEvent {
  const AuthResetPhoneEvent({
    required this.newPhoneNumber,
  });
  final String newPhoneNumber;

  @override
  List<Object> get props => [newPhoneNumber];
}

class AuthPhoneSMSCodeEnteredEvent extends AuthEvent {
  const AuthPhoneSMSCodeEnteredEvent({
    required this.verificationId,
    required this.sms,
  });
  final String verificationId, sms;

  @override
  List<Object> get props => [verificationId, sms];
}

class AuthPhoneSMSCodeSentEvent extends AuthEvent {
  const AuthPhoneSMSCodeSentEvent({
    required this.verificationId,
    required this.resendToken,
  });
  final String verificationId;
  final int? resendToken;
}

class AuthFailedEvent extends AuthEvent {
  const AuthFailedEvent({
    this.exception,
    required this.message,
  });

  final Exception? exception;
  final String message;

  @override
  List<Object?> get props => [exception, message];
}

class AuthSignOutEvent extends AuthEvent {}
