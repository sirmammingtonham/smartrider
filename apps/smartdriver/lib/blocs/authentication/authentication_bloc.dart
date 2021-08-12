import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:smartdriver/blocs/location/location_bloc.dart';
import 'package:smartdriver/blocs/authentication/data/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_exception.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.authRepository, required this.locationBloc})
      : super(const AuthenticationSignedOutState()) {
    add(AuthenticationStartedEvent());
  }

  final AuthenticationRepository authRepository;
  final LocationBloc locationBloc;
  late final SharedPreferences sharedPrefs;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthenticationStartedEvent:
        {
          sharedPrefs = await SharedPreferences.getInstance();
          yield AuthenticationSignedOutState(
            driverName: sharedPrefs.getString('driver_name'),
            phoneNumber: sharedPrefs.getString('phone_number'),
            vehicleId: sharedPrefs.getString('vehicle_id'),
          );
        }
        break;
      case AuthenticationSignInEvent:
        yield* _mapSignInToState(
            event as AuthenticationSignInEvent);
        break;
      case AuthenticationSignOutEvent:
        yield* _mapSignOutToState(
            event as AuthenticationSignOutEvent);
        break;
    }
  }

  Stream<AuthenticationState> _mapSignInToState(
      AuthenticationSignInEvent event) async* {
    try {
      final user = await authRepository.trySignIn(
          name: event.driverName,
          vehicleId: event.vehicleId,
          password: event.password,
          phoneNumber: event.phoneNumber);
      locationBloc.add(LocationStartTrackingEvent(vehicleRef: user.vehicleRef));
      await sharedPrefs.setString('driver_name', event.driverName);
      await sharedPrefs.setString('phone_number', event.phoneNumber);
      await sharedPrefs.setString('vehicle_id', event.vehicleId);
      yield AuthenticationSignedInState(user: user);
    } on AuthenticationException catch (error) {
      yield AuthenticationFailureState(errorMessage: error.message);
    }
  }

  Stream<AuthenticationState> _mapSignOutToState(
      AuthenticationSignOutEvent event) async* {
    await authRepository.trySignOut();
    yield AuthenticationSignedOutState(
      driverName: sharedPrefs.getString('driver_name'),
      phoneNumber: sharedPrefs.getString('phone_number'),
      vehicleId: sharedPrefs.getString('vehicle_id'),
    );
  }
}
