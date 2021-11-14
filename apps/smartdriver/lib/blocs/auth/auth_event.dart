part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStartedEvent extends AuthEvent {}

class AuthSignInEvent extends AuthEvent {
  const AuthSignInEvent(
      {required this.driverName,
      required this.password,
      required this.vehicleId,
      required this.phoneNumber});
  final String driverName, phoneNumber, vehicleId, password;
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}
