import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartdriver/blocs/auth/data/auth_repository.dart';
import 'package:smartdriver/blocs/location/location_bloc.dart';

part 'auth_event.dart';
part 'auth_exception.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository, required this.locationBloc})
      : super(const AuthSignedOutState()) {
    add(AuthStartedEvent());
  }

  final AuthRepository authRepository;
  final LocationBloc locationBloc;
  late final SharedPreferences sharedPrefs;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthStartedEvent:
        {
          sharedPrefs = await SharedPreferences.getInstance();
          yield AuthSignedOutState(
            driverName: sharedPrefs.getString('driver_name'),
            phoneNumber: sharedPrefs.getString('phone_number'),
            vehicleId: sharedPrefs.getString('vehicle_id'),
          );
        }
        break;
      case AuthSignInEvent:
        yield* _mapSignInToState(event as AuthSignInEvent);
        break;
      case AuthSignOutEvent:
        yield* _mapSignOutToState(event as AuthSignOutEvent);
        break;
    }
  }

  Stream<AuthState> _mapSignInToState(AuthSignInEvent event) async* {
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
      yield AuthSignedInState(user: user);
    } on AuthException catch (error) {
      yield AuthFailureState(errorMessage: error.message);
    }
  }

  Stream<AuthState> _mapSignOutToState(AuthSignOutEvent event) async* {
    await authRepository.trySignOut();
    yield AuthSignedOutState(
      driverName: sharedPrefs.getString('driver_name'),
      phoneNumber: sharedPrefs.getString('phone_number'),
      vehicleId: sharedPrefs.getString('vehicle_id'),
    );
  }
}
