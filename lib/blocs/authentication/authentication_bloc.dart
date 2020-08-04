import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(AuthenticationInit());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState(event.email, event.pass);
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    } else if (event is AuthenticationSignUp) {
      yield* _mapAuthenticationSignUpToState(event.email, event.pass);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final name = await _authRepository.getUser();
      yield AuthenticationSuccess(name);
    } else {
      yield AuthenticationInit();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState(e, p) async* {
    AuthResult result = await _authRepository.signInWithCredentials(
        e, p); //attempt to signin user

    if (result == null) {
      //wrong email or password
      yield AuthenticationFailure();
    } else {
      //enter else if signing in user is successful
      yield AuthenticationSuccess(e);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _authRepository.signOut();
  }

  Stream<AuthenticationState> _mapAuthenticationSignUpToState(e, p) async* {
    AuthResult result = await _authRepository.signUp(e, p);
    if (result == null) {
      //wrong email or password
      yield AuthenticationFailure();
    } else {
      //sign up user is successful
      yield AuthenticationSuccess(e);
    }
  }
}
