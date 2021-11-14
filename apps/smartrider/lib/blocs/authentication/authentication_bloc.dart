import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/blocs/authentication/data/authentication_repository.dart';
import 'package:shared/models/auth/rider.dart';

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
      case AuthenticationResetPhoneEvent:
        yield* _mapResetPhoneToState(event as AuthenticationResetPhoneEvent);
        break;
      case AuthenticationPhoneSMSCodeSentEvent:
        {
          yield AuthenticationVerifyPhoneState(
            verificationId:
                (event as AuthenticationPhoneSMSCodeSentEvent).verificationId,
            resendToken: event.resendToken,
          );
          yield AuthenticationSignedInState(
            user: authRepository.getCurrentUser!,
          );
        }
        break;
      case AuthenticationPhoneSMSCodeEnteredEvent:
        {
          final credential = PhoneAuthProvider.credential(
            verificationId: (event as AuthenticationPhoneSMSCodeEnteredEvent)
                .verificationId,
            smsCode: event.sms,
          );
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            yield AuthenticationFailedState(
              exception: e,
              message: 'Invalid code',
            );
          }
          yield AuthenticationSignedInState(
            user: authRepository.getCurrentUser!,
          );
        }
        break;
      case AuthenticationFailedEvent:
        {
          yield AuthenticationFailedState(
            exception: (event as AuthenticationFailedEvent).exception,
            message: event.message,
          );
          if (authRepository.getCurrentUser != null) {
            yield AuthenticationSignedInState(
              user: authRepository.getCurrentUser!,
            );
          } else {
            yield AuthenticationSignedOutState();
          }
        }
        break;
    }
  }

  Stream<AuthenticationState> _mapSignOutToState() async* {
    await authRepository.signOut();
    yield AuthenticationSignedOutState();
  }

//create state, put change phone number logic in state
  Stream<AuthenticationState> _mapResetPhoneToState(
    AuthenticationResetPhoneEvent event,
  ) async* {
    final auth = FirebaseAuth.instance;
// TODO: update user number on firestore
// move this into provider
    await authRepository.verifyPhoneNumber(
      phoneNumber: event.newPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        await auth.currentUser!.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        add(
          AuthenticationFailedEvent(
            exception: e,
            message: 'Phone Verification Failed',
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        add(
          AuthenticationPhoneSMSCodeSentEvent(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Stream<AuthenticationState> _mapInitToState() async* {
    final user = authRepository.getCurrentUser;
    if (user != null) {
      yield AuthenticationSignedInState(
        user: authRepository.getCurrentUser!,
      );
    } else {
      yield AuthenticationSignedOutState();
    }
  }

  Stream<AuthenticationState> _mapSignInToState(
    AuthenticationSignInEvent event,
  ) async* {
    try {
      yield AuthenticationSignedInState(
        user: await authRepository.signIn(
          token: event.token,
        ),
      );
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
}
