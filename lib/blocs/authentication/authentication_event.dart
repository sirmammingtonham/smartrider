part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  String get getemail => "";
  String get getpass => "";
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationDelete extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String email, pass, role;
  const AuthenticationLoggedIn(this.email, this.pass, this.role);
  @override
  String get getemail => email;
  @override
  String get getpass => pass;
  @override
  String get getrole => role;
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationSignUp extends AuthenticationEvent {
  final String email, name, pass, rin, role;
  const AuthenticationSignUp(
      this.email, this.name, this.pass, this.rin, this.role);
}

class AuthentificationResetPass extends AuthenticationEvent {
  final String email;
  const AuthentificationResetPass(this.email);
}
