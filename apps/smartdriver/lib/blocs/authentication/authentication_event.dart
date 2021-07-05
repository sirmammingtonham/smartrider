part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStartedEvent extends AuthenticationEvent {}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String driverName, phoneNumber, vehicleId, password;
  const AuthenticationLoginEvent(
      {required this.driverName,
      required this.password,
      required this.vehicleId,
      required this.phoneNumber});
}

class AuthenticationLogoutEvent extends AuthenticationEvent {
  const AuthenticationLogoutEvent();
}
