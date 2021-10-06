part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationInitEvent extends AuthenticationEvent {}

class AuthenticationDeleteEvent extends AuthenticationEvent {}

class AuthenticationSignInEvent extends AuthenticationEvent {
  const AuthenticationSignInEvent({
    required this.email,
    required this.password,
  });
  final String email, password;

  @override
  List<Object> get props => [email, password];
}

class AuthenticationSignOutEvent extends AuthenticationEvent {}

class AuthenticationSignUpEvent extends AuthenticationEvent {
  const AuthenticationSignUpEvent({
    required this.email,
    required this.password,
  });
  final String email, password;

  @override
  List<Object> get props => [email, password];
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
  const AuthenticationPhoneSMSCodeEnteredEvent(
      {required this.verificationId, required this.sms});
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

class AuthenticationResetPasswordEvent extends AuthenticationEvent {}
