import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/blocs/auth/data/auth_repository.dart';
import 'package:shared/models/auth/rider.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(AuthSignedOutState());
  final AuthRepository authRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthInitEvent:
        yield* _mapInitToState();
        break;
      case AuthSignInEvent:
        yield* _mapSignInToState(event as AuthSignInEvent);
        break;
      case AuthSignOutEvent:
        yield* _mapSignOutToState();
        break;
      case AuthResetPhoneEvent:
        yield* _mapResetPhoneToState(event as AuthResetPhoneEvent);
        break;
      case AuthPhoneSMSCodeSentEvent:
        {
          yield AuthVerifyPhoneState(
            verificationId: (event as AuthPhoneSMSCodeSentEvent).verificationId,
            resendToken: event.resendToken,
          );
          yield AuthSignedInState(
            user: authRepository.getCurrentUser!,
          );
        }
        break;
      case AuthPhoneSMSCodeEnteredEvent:
        {
          final credential = PhoneAuthProvider.credential(
            verificationId:
                (event as AuthPhoneSMSCodeEnteredEvent).verificationId,
            smsCode: event.sms,
          );
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            yield AuthFailedState(
              exception: e,
              message: 'Invalid code',
            );
          }
          yield AuthSignedInState(
            user: authRepository.getCurrentUser!,
          );
        }
        break;
      case AuthFailedEvent:
        {
          yield AuthFailedState(
            exception: (event as AuthFailedEvent).exception,
            message: event.message,
          );
          if (authRepository.getCurrentUser != null) {
            yield AuthSignedInState(
              user: authRepository.getCurrentUser!,
            );
          } else {
            yield AuthSignedOutState();
          }
        }
        break;
    }
  }

  Stream<AuthState> _mapSignOutToState() async* {
    await authRepository.signOut();
    yield AuthSignedOutState();
  }

//create state, put change phone number logic in state
  Stream<AuthState> _mapResetPhoneToState(
    AuthResetPhoneEvent event,
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
          AuthFailedEvent(
            exception: e,
            message: 'Phone Verification Failed',
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        add(
          AuthPhoneSMSCodeSentEvent(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Stream<AuthState> _mapInitToState() async* {
    final user = authRepository.getCurrentUser;
    if (user != null) {
      yield AuthSignedInState(
        user: authRepository.getCurrentUser!,
      );
    } else {
      yield AuthSignedOutState();
    }
  }

  Stream<AuthState> _mapSignInToState(
    AuthSignInEvent event,
  ) async* {
    try {
      yield AuthSignedInState(
        user: await authRepository.signIn(
          token: event.token,
        ),
      );
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'user-not-found':
          yield AuthFailedState(
            exception: exception,
            message: 'User not found! Please make an account.',
          );
          break;
        case 'wrong-password':
          yield AuthFailedState(
            exception: exception,
            message: 'Incorrect password.',
          );
          break;
      }
    }
  }
}
