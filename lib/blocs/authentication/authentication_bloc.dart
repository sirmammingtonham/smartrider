import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:smartrider/services/user_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Authsystem _userRepository;

  AuthenticationBloc({@required Authsystem userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        
        super(AuthenticationInit());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState(event.email,event.pass);
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
    else if (event is AuthenticationSignUp){
      yield* _mapAuthenticationSignUpToState(event.email, event.pass);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final name = await _userRepository.getUser();
      yield AuthenticationSuccess(name);
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState(e,p) async* {
     AuthResult result = await _userRepository.signInWithCredentials(e, p);  //attempt to signin user

      if(result==null){   //wrong email or password
        yield AuthenticationFailure();
      }
      else{  //enter else if signing in user is successful
        yield AuthenticationSuccess(e);
      }
    
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapAuthenticationSignUpToState(e,p) async*{
    AuthResult result = await _userRepository.signUp(e,p);
     if(result==null){   //wrong email or password
        yield AuthenticationFailure();
      }
      else{  //sign up user is successful
        yield AuthenticationSuccess(e);
      }
  }
}