part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationAwaitVerificationState extends AuthenticationState {
  /// hack to get our state to rebuild even if this state is yielded again
  @override
  bool operator ==(Object other) => false;

  /// redundant but stops linter from complaining
  @override
  int get hashCode => super.hashCode * 1;
}

class AuthenticationSignedOutState extends AuthenticationState {}

class AuthenticationSignedInState extends AuthenticationState {
  const AuthenticationSignedInState({
    required this.user,
    required this.emailVerified,
    required this.phoneVerified,
  });

  final User user;
  final bool emailVerified; // should always be true, here for symmetry lol
  final bool phoneVerified;

  @override
  List<Object> get props => [user, emailVerified, phoneVerified];
}

class AuthenticationFailedState extends AuthenticationState {
  const AuthenticationFailedState({
    required this.exception,
    required this.message,
  });

  final FirebaseAuthException exception;
  final String message;

  @override
  List<Object> get props => [exception, message];
}

class AuthenticationPhoneFailedState extends AuthenticationState {
  const AuthenticationPhoneFailedState({
    required this.exception,
    required this.message,
  });

  final FirebaseAuthException exception;
  final String message;

  @override
  List<Object> get props => [exception, message];
}

//create phone reset state,
class AuthenticationVerifyPhoneState extends AuthenticationState {
  const AuthenticationVerifyPhoneState({
    required this.verificationId,
    required this.resendToken,
  });
  final String verificationId;
  final int? resendToken;
  @override
  List<Object?> get props => [verificationId, resendToken];
}
