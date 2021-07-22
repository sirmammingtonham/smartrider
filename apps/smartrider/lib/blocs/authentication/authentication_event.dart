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
    required this.phoneNumber,
    required this.password,
  });
  final String email, phoneNumber, password;

  @override
  List<Object> get props => [email, phoneNumber, password];
}

class AuthenticationResetPhoneEvent extends AuthenticationEvent {
  const AuthenticationResetPhoneEvent({
    required this.email,
    required this.password,
    required this.newPhoneNumber,
  });
  final String email, newPhoneNumber, password;

  @override
  List<Object> get props => [email, newPhoneNumber, password];
}

class AuthenticationResetPasswordEvent extends AuthenticationEvent {}
