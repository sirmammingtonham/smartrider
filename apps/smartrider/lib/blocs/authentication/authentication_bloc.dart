import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/data/repositories/authentication_repository.dart';
import 'package:smartrider/data/providers/database.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

//TODO: rework this mess
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthenticationInit());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthenticationStarted:
        yield* _mapAuthenticationStartedToState();
        break;
      case AuthenticationLoggedIn:
        yield* _mapAuthenticationLoggedInToState(
            (event as AuthenticationLoggedIn).email, event.pass, event.role);
        break;
      case AuthenticationLoggedOut:
        yield* _mapAuthenticationLoggedOutToState();
        break;
      case AuthenticationSignUp:
        yield* _mapAuthenticationSignUpToState(
            (event as AuthenticationSignUp).email,
            event.name,
            event.pass,
            event.rin,
            event.role);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = _authRepository.isSignedIn;
    if (isSignedIn) {
      final name = _authRepository.getUser;
      final user = _authRepository.getActualUser!;
      final role = await DatabaseService(usid: user.uid).getUserRole();
      yield AuthenticationSuccess(name, role ?? 'Student');
    } else {
      yield AuthenticationInit();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState(
      String e, String p, String role) async* {
    final result = await (_authRepository.signInWithCredentials(
        e, p)); //attempt to signin user

    switch (result.runtimeType) {
      case UserCredential:
        {
          //if signing in user is successful
          final user = _authRepository.getActualUser!;
          if (user.emailVerified) {
            yield AuthenticationSuccess(e, role);
          } else {
            await user.sendEmailVerification();
            yield AwaitEmailVerify();
          }
        }
        break;
      default:
        yield const AuthenticationFailure('Email or Password is Incorrect');
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    await _authRepository.signOut();
    yield AuthenticationInit();
  }

  Stream<AuthenticationState> _mapAuthenticationSignUpToState(
      String e, String n, String p, String r, String role) async* {
    dynamic result = await _authRepository.signUp(e, p);

    switch (result.runtimeType) {
      case UserCredential:
        {
          User user = result.user;
          await DatabaseService(usid: user.uid).updateUserData(user.email, role,
              rin: r,
              name: n); // usertype will be student for now, modify later
          await user.sendEmailVerification();
          yield AwaitEmailVerify();
        }
        break;
      default:
        yield AuthenticationFailure(result.message);
    }
  }
}
