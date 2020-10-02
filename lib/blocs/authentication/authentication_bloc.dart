import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';
import 'package:smartrider/backend/database.dart';
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
      yield* _mapAuthenticationSignUpToState(
          event.email, event.pass, event.rin);
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

    if (result is AuthResult) {
      //if signing in user is successful
      FirebaseUser user = await _authRepository.getActualUser();
      if (user.isEmailVerified) {
        yield AuthenticationSuccess(e);
      } else {
        user.sendEmailVerification();
        yield AwaitEmailVerify();
      }
    } else {
      //wrong email or password
      yield AuthenticationFailure("Email or Password is Incorrect");
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    _authRepository.signOut();
    yield AuthenticationInit();
  }

  Stream<AuthenticationState> _mapAuthenticationSignUpToState(e, p, r) async* {
    var result = await _authRepository.signUp(e, p);
    if (result is AuthResult) {
      FirebaseUser user = result.user;
      await DatabaseService(usid: user.uid).updateUserData(
          user.email, 'Student',
          rin: r); // usertype will be student for now, modify later
      user.sendEmailVerification();
      yield AwaitEmailVerify();
    } else {
      yield AuthenticationFailure(result.message);
    }
  }
}
