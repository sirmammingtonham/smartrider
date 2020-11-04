import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartrider/data/models/backend/user_list.dart';
import 'package:smartrider/data/models/backend/user.dart';

/* Contains all the functions for handling the database */

class DatabaseService {
  //unique user id, will be generated from authorization class after a user successfully logs in
  final String usid;
  //reference to the user collection in the database
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');
  //referencing all rpi shuttles collection  (for future use)
  final CollectionReference _shuttleCollection =
      Firestore.instance.collection('active_shuttles');
  DatabaseService({this.usid});
  Future updateUserData(String email, String userType,
      {String rin = "0", String name}) async {
    //Updates the user data for the user corresponding to the usid
    return await _userCollection.document(usid).setData({
      'email': name,
      'userType': userType,
      'rin': rin,
      'name': name,
    });
  }

  //receive data function(s) go here

  // user list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((info) {
      return User(
          email: info.data['email'],
          rin: info.data['rin'],
          userType: info.data['userType'],
          name: info.data["name"]);
    }).toList();
  }

  //Stream<List<User>> get users {
  // gets user stream
  Stream<List<User>> get users {
    //takes user info from collection and creates a list of user objects
    return _userCollection.snapshots().map(_userListFromSnapshot);
  }

  //get the data associated with the specific user
  Future<Map<String, dynamic>> returnData() async {
    //return the data associated with the user
    Map<String, dynamic> data;
    data = null;
    Future<DocumentSnapshot> userRef = _userCollection.document(usid).get();
    await userRef.then((DocumentSnapshot ds) {
      //print(ds.data);
      data = ds.data;
    }).catchError((e) {
      print("Error Found: $e"); //Prints the error
      return null;
    });

    return data;
  }
}
