import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:smartdriver/data/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_exception.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authRepository;

  AuthenticationBloc({required AuthenticationRepository authRepository})
      : _authRepository = authRepository,
        super(AuthenticationLoggedOutState());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    switch (event.runtimeType) {
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
      Driver user = await _authRepository.tryLogin(
          name: event.driverName,
          vehicleId: event.vehicleId,
          password: event.password,
          phoneNumber: event.phoneNumber);
      yield AuthenticationLoggedInState(user: user);
    } on AuthenticationException catch (error) {
      yield AuthenticationFailureState(errorMessage: error.message);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLogoutToState(
      AuthenticationLogoutEvent event) async* {
    await _authRepository.tryLogout();
  }
}
