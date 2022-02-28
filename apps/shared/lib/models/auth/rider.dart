import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Rider extends Equatable {
  Rider({
    required this.ref,
    required this.name,
    required this.email,
    required this.rin,
    required this.uid,
    required this.phoneNumber,
  });

  factory Rider.fromJson(DocumentSnapshot snap) {
    final data = snap.data()! as Map<String, dynamic>;
    return Rider(
      ref: snap.reference,
      uid: data['uid'] as String,
      name: data['displayName'] as String,
      email: data['email'] as String,
      rin: data['rin'] as String,
      phoneNumber: data['phone'] as String?,
    );
  }
  final DocumentReference ref;
  final String name;
  final String email;
  final String rin;
  final String uid;
  String? phoneNumber;

  bool get phoneVerified => phoneNumber != null;

  @override
  List<Object?> get props => [ref, name, email, rin, uid, phoneNumber];
}
