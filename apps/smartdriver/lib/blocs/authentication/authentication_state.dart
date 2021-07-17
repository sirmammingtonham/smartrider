part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoggedInState extends AuthenticationState {
  const AuthenticationLoggedInState({required this.user});
  final Driver user;

  @override
  List<Object?> get props => [user];
}

class AuthenticationLoggedOutState extends AuthenticationState {
  const AuthenticationLoggedOutState(
      {this.driverName, this.phoneNumber, this.vehicleId});
  final String? driverName, phoneNumber, vehicleId;

  @override
  List<Object?> get props => [driverName, phoneNumber, vehicleId];
}

class AuthenticationFailureState extends AuthenticationState {
  const AuthenticationFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
