import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/models/user.dart';
class Authsystem {

  final FirebaseAuth fbauth = FirebaseAuth.instance;
    User fireuser(FirebaseUser user) {
      if(user != null){
        return User(userid: user.uid);
      }
      else{
        return null;
      }
  }

  Stream<FirebaseUser> get getuser{ //get keyword used for get method
    return fbauth.onAuthStateChanged;   //listen to firebase if a user's auth changed return the user
  }

  Future<FirebaseUser> signInAnon() async {
    try {  //try signing user in
      AuthResult result = await fbauth.signInAnonymously(); 
      FirebaseUser user = result.user;
      return user;
    } catch (e) {  
      print(e.toString()); //print error if it fails
      return null;
    }
  }

  

}