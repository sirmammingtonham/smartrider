part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInit extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String displayName,role;

  const AuthenticationSuccess(this.displayName,this.role);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'AuthenticationSuccess($displayName)';
}

class AuthenticationFailure extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailure(this.errorMessage);
  
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'AuthenticationFailure($errorMessage)';
}

class AwaitEmailVerify extends AuthenticationState {}
