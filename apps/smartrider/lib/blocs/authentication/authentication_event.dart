part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  String get getemail => '';
  String get getpass => '';
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationDelete extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  const AuthenticationLoggedIn(this.email, this.pass, this.role);
  final String email, pass, role;

  @override
  String get getemail => email;
  @override
  String get getpass => pass;

  String get getrole => role;
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationSignUp extends AuthenticationEvent {
  const AuthenticationSignUp(
      this.email, this.name, this.pass, this.rin, this.role);
  final String email, name, pass, rin, role;
}

class AuthentificationResetPass extends AuthenticationEvent {
  const AuthentificationResetPass(this.email);
  final String? email;
}
