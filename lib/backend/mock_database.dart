import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:mock_cloud_firestore/mock_types.dart';
import 'package:smartrider/backend/user_list.dart';
import 'package:smartrider/backend/user.dart';

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

class DatabaseService {
  //unique user id, will be generated from authorization class after a user successfully logs in
  final String usid;
  //reference to the user collection in the database
  static final  String src = r"""
{
  "users": {
    "1": {
      "Rin": "1",
      "id": "1",
      "name": "1"
    }
  }
}
  """;
  final CollectionReference _userCollection = MockCloudFirestore(src).collection('users');

  DatabaseService({this.usid});

  Future updateUserData(String name, String userType, {String rin="0"}) async {
    //Updates the user data for the user corresponding to the usid
    return await _userCollection.document("1").setData({
      'name': name,
      'userType': userType,
      'rin': rin,
    });
  }

  //receive data function(s) go here

  // user list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((info){
      return User(

          name: info.data['name'],
          rin: info.data['rin'],
          userType: info.data['userType']

      );
    }).toList();
  }

  // gets user stream
  Stream<List<User>> get users {
    //takes user info from collection and creates a list of user objects
    return _userCollection.snapshots().map(_userListFromSnapshot);
  }



  void debug() {
    print("debugging");
    print(usid);
    Future<DocumentSnapshot> userRef =  _userCollection.document("1").get();
    userRef.then( (DocumentSnapshot ds) {
      print(ds.data);
    });
    /*
    _userCollection.where("topic", isEqualTo: "flutter").snapshots().listen(
        (data) =>
            data.documents.forEach( (doc) => print(doc["title"])));

     */
  }

}

