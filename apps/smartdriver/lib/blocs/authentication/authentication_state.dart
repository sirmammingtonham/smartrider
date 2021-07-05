part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoggedInState extends AuthenticationState {
  final Driver user;

  const AuthenticationLoggedInState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthenticationLoggedOutState extends AuthenticationState {
  final String? driverName, phoneNumber, vehicleId;
  const AuthenticationLoggedOutState(
      {this.driverName, this.phoneNumber, this.vehicleId});

  @override
  List<Object?> get props => [driverName, phoneNumber, vehicleId];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
