part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInit extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(this.displayName, this.role);

  final String? displayName, role;

  @override
  List<Object?> get props => [displayName];

  @override
  String toString() => 'AuthenticationSuccess($displayName)';
}

class AuthenticationFailure extends AuthenticationState {
  const AuthenticationFailure(this.errorMessage);

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => 'AuthenticationFailure($errorMessage)';
}

class AwaitEmailVerify extends AuthenticationState {}
