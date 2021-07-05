import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:smartdriver/blocs/location/location_bloc.dart';
import 'package:smartdriver/data/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_exception.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authRepository;
  final LocationBloc locationBloc;
  late final SharedPreferences sharedPrefs;

  AuthenticationBloc({required this.authRepository, required this.locationBloc})
      : super(AuthenticationLoggedOutState()) {
    add(AuthenticationStartedEvent());
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthenticationStartedEvent:
        {
          sharedPrefs = await SharedPreferences.getInstance();
          yield AuthenticationLoggedOutState(
            driverName: sharedPrefs.getString('driver_name'),
            phoneNumber: sharedPrefs.getString('phone_number'),
            vehicleId: sharedPrefs.getString('vehicle_id'),
          );
        }
        break;
      case AuthenticationLoginEvent:
        yield* _mapAuthenticationLoginToState(
            event as AuthenticationLoginEvent);
        break;
      case AuthenticationLogoutEvent:
        yield* _mapAuthenticationLogoutToState(
            event as AuthenticationLogoutEvent);
        break;
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoginToState(
      AuthenticationLoginEvent event) async* {
    try {
      Driver user = await authRepository.tryLogin(
          name: event.driverName,
          vehicleId: event.vehicleId,
          password: event.password,
          phoneNumber: event.phoneNumber);
      locationBloc.add(LocationStartTrackingEvent(vehicleRef: user.vehicleRef));
      sharedPrefs.setString('driver_name', event.driverName);
      sharedPrefs.setString('phone_number', event.phoneNumber);
      sharedPrefs.setString('vehicle_id', event.vehicleId);
      yield AuthenticationLoggedInState(user: user);
    } on AuthenticationException catch (error) {
      yield AuthenticationFailureState(errorMessage: error.message);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLogoutToState(
      AuthenticationLogoutEvent event) async* {
    await authRepository.tryLogout();
    yield AuthenticationLoggedOutState(
      driverName: sharedPrefs.getString('driver_name'),
      phoneNumber: sharedPrefs.getString('phone_number'),
      vehicleId: sharedPrefs.getString('vehicle_id'),
    );
  }
}
