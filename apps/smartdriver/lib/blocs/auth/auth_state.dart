part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthSignedInState extends AuthState {
  const AuthSignedInState({required this.user});
  final Driver user;

  @override
  List<Object?> get props => [user];
}

class AuthSignedOutState extends AuthState {
  const AuthSignedOutState({this.driverName, this.phoneNumber, this.vehicleId});
  final String? driverName, phoneNumber, vehicleId;

  @override
  List<Object?> get props => [driverName, phoneNumber, vehicleId];
}

class AuthFailureState extends AuthState {
  const AuthFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
