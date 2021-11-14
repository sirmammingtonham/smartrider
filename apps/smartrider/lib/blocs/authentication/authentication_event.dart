part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitEvent extends AuthenticationEvent {}

class AuthenticationSignInEvent extends AuthenticationEvent {
  const AuthenticationSignInEvent({
    required this.token,
  });
  final String token;

  @override
  List<Object> get props => [token];
}

class AuthenticationResetPhoneEvent extends AuthenticationEvent {
  const AuthenticationResetPhoneEvent({
    required this.newPhoneNumber,
  });
  final String newPhoneNumber;

  @override
  List<Object> get props => [newPhoneNumber];
}

class AuthenticationPhoneSMSCodeEnteredEvent extends AuthenticationEvent {
  const AuthenticationPhoneSMSCodeEnteredEvent({
    required this.verificationId,
    required this.sms,
  });
  final String verificationId, sms;

  @override
  List<Object> get props => [verificationId, sms];
}

class AuthenticationPhoneSMSCodeSentEvent extends AuthenticationEvent {
  const AuthenticationPhoneSMSCodeSentEvent({
    required this.verificationId,
    required this.resendToken,
  });
  final String verificationId;
  final int? resendToken;
}

class AuthenticationFailedEvent extends AuthenticationEvent {
  const AuthenticationFailedEvent({
    this.exception,
    required this.message,
  });

  final Exception? exception;
  final String message;

  @override
  List<Object?> get props => [exception, message];
}

class AuthenticationSignOutEvent extends AuthenticationEvent {}
