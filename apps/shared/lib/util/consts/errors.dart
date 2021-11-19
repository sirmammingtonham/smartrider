class SRError {
  const SRError({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() {
    return '$message (Error code: $code)';
  }

  static const blocErorr =
      SRError(code: 'blocc', message: 'Error in the bloc');

  static const networkError = SRError(
      code: 'bruh', message: 'No internet or shuttle server unavailable.',);

  static const userCancelledError = SRError(
      code: 'cancel_culture',
      message: 'User cancelled ride. Going back to home screen.',);
}
