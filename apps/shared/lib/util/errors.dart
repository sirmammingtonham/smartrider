class SRError {
  final String code;
  final String message;
  const SRError({required this.code, required this.message});

  String toString() {
    return '${message} (Error code: ${code})';
  }

  static const BLOC_ERROR = SRError(
      code: 'blocc', message: 'Error in the bloc');

  static const NETWORK_ERROR = SRError(
      code: 'bruh', message: 'No internet or shuttle server unavailable.');

  static const USER_CANCELLED_ERROR = SRError(
      code: 'cancel_culture',
      message: 'User cancelled ride. Going back to home screen.');
}
