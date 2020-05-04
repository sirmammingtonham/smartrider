import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrider/backend/database.dart';
class Authsystem {

  final FirebaseAuth fbauth = FirebaseAuth.instance;
  final DatabaseService db = new DatabaseService();
  //   User fireuser(FirebaseUser user) {
  //     if(user != null){
  //       return User(userid: user.uid);
  //     }
  //     else{
  //       return null;
  //     }
  // }

  Stream<FirebaseUser> get getuser{ //get keyword used for get method
    return fbauth.onAuthStateChanged;   //listen to firebase if a user's auth changed return the user
  }

  Future<FirebaseUser> signInAnon() async {  //for debugging purpose only (signin anonomysly)
    try {  //try signing user in
      AuthResult result = await fbauth.signInAnonymously(); 
      FirebaseUser user = result.user;
      return user;
    } catch (e) {  
      print(e.toString()); //print error if it fails
      return null;
    }
  }

  Future signout() async{
    try{
      return await fbauth.signOut();
    }
    catch(e){
      print(e); //catch the error if signout fails.
    }
  }

  Future registerwithEandP(String email, String pass) async{
    try{
      AuthResult result = await fbauth.createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user= result.user;
      db.updateUserData(user.displayName, 'Student');
     return  user.uid;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
   Future signinwithEandP(String email, String pass) async{
    try{
      AuthResult result = await fbauth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user= result.user;
     return  user.uid;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  

  

}