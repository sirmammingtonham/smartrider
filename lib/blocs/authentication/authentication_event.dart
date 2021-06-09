import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String driverEmail, driverName, vehicleId, password, phoneNumber;
  const AuthenticationLoginEvent(
      {required this.driverEmail,
      required this.driverName,
      required this.vehicleId,
      required this.password,
      required this.phoneNumber});
}

class AuthenticationLogoutEvent extends AuthenticationEvent {}
