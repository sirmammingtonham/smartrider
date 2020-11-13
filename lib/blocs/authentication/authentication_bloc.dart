import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';
import 'package:smartrider/data/providers/database.dart';
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
      yield* _mapAuthenticationLoggedInToState(
          event.email, event.pass, event.role);
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    } else if (event is AuthenticationSignUp) {
      yield* _mapAuthenticationSignUpToState(
          event.email, event.name, event.pass, event.rin, event.role);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = _authRepository.isSignedIn();
    if (isSignedIn) {
      final name = _authRepository.getUser();
      yield AuthenticationSuccess(name, 'Student');
    } else {
      yield AuthenticationInit();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState(
      e, p, role) async* {
    UserCredential result = await _authRepository.signInWithCredentials(
        e, p); //attempt to signin user

    if (result is UserCredential) {
      //if signing in user is successful
      User user = _authRepository.getActualUser();
      if (user.emailVerified) {
        yield AuthenticationSuccess(e, role);
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

  Stream<AuthenticationState> _mapAuthenticationSignUpToState(
      e, n, p, r, role) async* {
    var result = await _authRepository.signUp(e, p);
    if (result is UserCredential) {
      User user = result.user;
      await DatabaseService(usid: user.uid).updateUserData(user.email, role,
          rin: r, name: n); // usertype will be student for now, modify later
      user.sendEmailVerification();
      yield AwaitEmailVerify();
    } else {
      yield AuthenticationFailure(result.message);
    }
  }
}
