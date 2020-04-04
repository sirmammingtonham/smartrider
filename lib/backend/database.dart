import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartrider/backend/user_list.dart';
import 'package:smartrider/backend/user.dart';

/* Contains all the functions for handling the database */

class DatabaseService {
  //unique user id, will be generated from authorization class after a user successfully logs in
  final String usid;
  //reference to the user collection in the database
  final CollectionReference _userCollection = Firestore.instance.collection('users');

  DatabaseService({this.usid});

  Future updateUserData(String name, String userType, {String rin="0"}) async {
    //Updates the user data for the user corresponding to the usid
    return await _userCollection.document(usid).setData({
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

  //Stream<List<User>> get users {
  // gets user stream
  Stream<List<User>> get users {
    //takes user info from collection and creates a list of user objects
    return _userCollection.snapshots().map(_userListFromSnapshot);
  }

  //get the data associated with the specific user
 Map<String, dynamic> returnData() {
   //return the data associated with the user
   Map<String, dynamic> data;
   data = null;
   Future<DocumentSnapshot> userRef = _userCollection.document(usid).get();
   userRef.then((DocumentSnapshot ds){
     //print(ds.data);
     data = ds.data;
   })
       .catchError((e) {
          print(e.error);//Prints the error
          return(Null);
   });

   return data;
 }
}