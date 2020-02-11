import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String identifier;
  final CollectionReference _userCollection = Firestore.instance.collection('users');

  DatabaseService({this.identifier});

  Future updateUserData(String name, String rin) async {
    return await _userCollection.document(identifier).setData({
      'name': name,
      'rin': rin
    });
  }
}