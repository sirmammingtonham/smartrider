part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final driverName, vehicleId, password, phoneNumber;
  const AuthenticationLoginEvent(
      {required this.driverName,
      required this.vehicleId,
      required this.password,
      required this.phoneNumber});
}

class AuthenticationLogoutEvent extends AuthenticationEvent {}
