import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared/models/auth/rider.dart';

class AuthProvider {
  AuthProvider() {
    _providerHasLoaded = _init();
  }

  static final RegExp phoneRegex = RegExp(
    r'(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?',
  );

  late final Future _providerHasLoaded;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Rider? currentUser;

  Future get waitForLoad => _providerHasLoaded;
  bool get isSignedIn => _firebaseAuth.currentUser != null;
  Stream<User?> get userChangeStream => _firebaseAuth.authStateChanges();

  Future<void> _init() async {
    if (_firebaseAuth.currentUser != null) {
      // print(_firebaseAuth.currentUser);
      // print(_firebaseAuth.currentUser!.uid);
      currentUser = Rider.fromJson(
        await _firebaseFirestore
            .doc('users/${_firebaseAuth.currentUser!.uid}')
            .get(),
      );
    }
  }

  Future<Rider> signIn(
    String token,
  ) async {
    try {
      final cred = await _firebaseAuth.signInWithCustomToken(
        token,
      );
      currentUser = Rider.fromJson(
        await _firebaseFirestore.doc('users/${cred.user!.uid}').get(),
      );

      return currentUser!;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> updatePhone(String phoneNumber) async {
    final cleanPhoneNumber = processPhoneNumber(phoneNumber);
    // print(_firebaseAuth.currentUser!.uid);
    // print(currentUser!.uid);
    // print(_firebaseAuth.currentUser!.uid == currentUser!.uid);
    await currentUser?.ref.update({'phone': cleanPhoneNumber});
  }

  // create function logic here, Update phone number in firestore, need wrappers in repo
  // currentuser.ref
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
  }) =>
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: processPhoneNumber(phoneNumber),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

  String processPhoneNumber(String phoneNumber) {
    final matches = phoneRegex.firstMatch(phoneNumber)!;
    if (matches.group(1) == null) {
      return '+1 (${matches.group(2)})-${matches.group(3)}-${matches.group(4)}';
    } else {
      return '+${matches.group(1)} '
          '(${matches.group(2)})-${matches.group(3)}-${matches.group(4)}';
    }
  }
}
