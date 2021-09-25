part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStartedEvent extends AuthenticationEvent {}

class AuthenticationSignInEvent extends AuthenticationEvent {
  const AuthenticationSignInEvent(
      {required this.driverName,
      required this.password,
      required this.vehicleId,
      required this.phoneNumber});
  final String driverName, phoneNumber, vehicleId, password;
}

class AuthenticationSignOutEvent extends AuthenticationEvent {
  const AuthenticationSignOutEvent();
}
