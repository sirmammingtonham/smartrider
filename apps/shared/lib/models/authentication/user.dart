import 'package:cloud_firestore/cloud_firestore.dart';

class SRUser {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber; //TODO: authentication for phone number?

  const SRUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory SRUser.fromSnapshot(DocumentSnapshot snap) {
    final data = (snap.data()! as Map<String, dynamic>);
    return SRUser(
        uid: snap.id,
        name: data['name'] ?? 'Ethan',
        email: data['email'] ?? '123@gmail.com',
        phoneNumber: data['phone'] ?? '1234567890');
    // return SRUser(
    //     uid: snap.id,
    //     name: snap.get('name'),
    //     email: snap.get('email'),
    //     phoneNumber: snap.get('phone'));
  }
}
