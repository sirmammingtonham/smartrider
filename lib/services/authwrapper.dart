import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smartrider/pages/signup.dart';
import 'package:smartrider/services/user_repository.dart';
class authwrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final fbuser = Provider.of<FirebaseUser>(context);
    print(fbuser);
    return Signuppage();
  }
}