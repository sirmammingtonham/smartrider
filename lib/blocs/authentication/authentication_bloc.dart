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
    // Future<String> currentuser =  _userRepository.getUser();
    // if(currentuser != e){  //cannot find current user
    //     yield AuthenticationFailure();
    //     print(currentuser);
    //     print("adjflajdslkfjasldkfjlkasdjflasdjflasdfasdfasdfasdfsafasfasfsfdf");
    //     print(e);
    // }
    // else{ // can find current user
     AuthResult result = await _userRepository.signInWithCredentials(e, p);  //attempt to signin user

      if(result==null){   //wrong email or password
        yield AuthenticationFailure();
        print("wryyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
      }
      else{  //enter else if signing in user is successful
        yield AuthenticationSuccess(e);
         print("ok");
      }
    
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _userRepository.signOut();
  }
}