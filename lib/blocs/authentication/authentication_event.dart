part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  String get getemail => "";
  String get getpass => "";
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String email,pass;
  const AuthenticationLoggedIn(this.email,this.pass);
  @override
  String get getemail => email;
  @override
  String get getpass => pass;
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationSignUp extends AuthenticationEvent{
  final String email,pass,rin;
  const AuthenticationSignUp(this.email,this.pass,this.rin);
}