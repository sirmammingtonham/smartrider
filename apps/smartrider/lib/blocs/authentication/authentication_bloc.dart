import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/data/repositories/authentication_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.authRepository})
      : super(AuthenticationSignedOutState());
  final AuthenticationRepository authRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthenticationInitEvent:
        yield* _mapInitToState();
        break;
      case AuthenticationSignInEvent:
        yield* _mapSignInToState(event as AuthenticationSignInEvent);
        break;
      case AuthenticationSignOutEvent:
        yield* _mapSignOutToState();
        break;
      case AuthenticationSignUpEvent:
        yield* _mapSignUpToState(event as AuthenticationSignUpEvent);
        break;
      case AuthenticationResetPhoneEvent:
        yield* _mapResetPhoneToState(event as AuthenticationResetPhoneEvent);
        break;
      case AuthenticationResetPasswordEvent:
        break;
      case AuthenticationDeleteEvent:
        break;
      case AuthenticationPhoneSMSCodeSentEvent:
        yield AuthenticationVerifyPhoneState(
            verificationId:
                (event as AuthenticationPhoneSMSCodeSentEvent).verificationId,
            resendToken: event.resendToken);
        break;
      case AuthenticationPhoneSMSCodeEnteredEvent:
        {
          final credential = PhoneAuthProvider.credential(
              verificationId: (event as AuthenticationPhoneSMSCodeEnteredEvent)
                  .verificationId,
              smsCode: event.sms);
          await FirebaseAuth.instance.signInWithCredential(credential);
        }
        break;
    }
  }

//create state, put change phone number logic in state
  Stream<AuthenticationState> _mapResetPhoneToState(
      AuthenticationResetPhoneEvent event) async* {
    final user = authRepository.getCurrentUser;
    final auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: event.newPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          await user!.updatePhoneNumber(credential);
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) async {
          //need to prompt ui for sms code
          //yield new state, profile.dart blocbuilder, if state is verificaation state, have prompt to input
          add(AuthenticationPhoneSMSCodeSentEvent(
              verificationId: verificationId, resendToken: resendToken));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      yield AuthenticationPhoneFailedState(
          exception: e, message: 'Invalid SMS Code');
    }
  }

  Stream<AuthenticationState> _mapInitToState() async* {
    final user = authRepository.getCurrentUser;
    if (user != null) {
      if (!user.emailVerified) {
        yield AuthenticationAwaitVerificationState();
        return;
      }
      final userData = await authRepository.getCurrentUserData;
      yield AuthenticationSignedInState(
        user: authRepository.getCurrentUser!,
        email: userData!['email'],
        phoneNumber: userData['phone'],
        phoneVerified: userData['phone_verified'],
      );
    } else {
      yield AuthenticationSignedOutState();
    }
  }

  Stream<AuthenticationState> _mapSignInToState(
      AuthenticationSignInEvent event) async* {
    try {
      final userCredential = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      final user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          final userData = await authRepository.getCurrentUserData;
          yield AuthenticationSignedInState(
              user: authRepository.getCurrentUser!,
              email: userData!['email'],
              phoneNumber: userData['phone'],
              phoneVerified: userData['phone_verified']);
        } else {
          await user.sendEmailVerification();
          yield AuthenticationAwaitVerificationState();
        }
      }
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'user-not-found':
          yield AuthenticationFailedState(
            exception: exception,
            message: 'User not found! Please make an account.',
          );
          break;
        case 'wrong-password':
          yield AuthenticationFailedState(
            exception: exception,
            message: 'Incorrect password.',
          );
          break;
      }
    }
  }

// TODO: write functions for
  Stream<AuthenticationState> _mapSignOutToState() async* {
    await authRepository.signOut();
    yield AuthenticationSignedOutState();
  }

  Stream<AuthenticationState> _mapSignUpToState(
      AuthenticationSignUpEvent event) async* {
    try {
      await authRepository.signUp(
        email: event.email,
        phoneNumber: event.phoneNumber,
        password: event.password,
      );
      yield AuthenticationAwaitVerificationState();
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'weak-password':
          yield AuthenticationFailedState(
            exception: exception,
            message: 'Password too weak! Please try again.',
          );
          break;
        case 'email-already-in-use':
          yield AuthenticationFailedState(
            exception: exception,
            message: 'Email already in use! Log in or reset your password.',
          );
          break;
      }
    }
  }
}
