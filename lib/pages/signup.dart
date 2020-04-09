import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartrider/services/userauth.dart';
 

 class Signuppage extends StatelessWidget {
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: "smart rider signup",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SignupHome(title: 'Smartrider Signup'),
        );
      }
    }

 class SignupHome extends StatefulWidget {
      SignupHome({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignupHomeState createState() => _SignupHomeState();
    }
      
    class _SignupHomeState extends State<SignupHome> {
      TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
      String email = '';
      String password = '';
      String confirmpassword = '';
      String error = '';
      final Authsystem _auth = Authsystem();
      final formkey= GlobalKey<FormState>();
      @override
      Widget build(BuildContext context) {
        
        final titletext = Text(
            "SignUp for Smartrider", 
            textAlign: TextAlign.center,
            style: GoogleFonts.alef(fontSize: 30),
        );
        final emailField = TextFormField(
          validator: (val) {
             if(val.isEmpty){
               return 'Enter an email';
             }
             else{
               return null;
             }
          },
          obscureText: false,
          style: style,
          onChanged: (val){
              email = val;
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final passwordField = TextFormField(
          validator: (val){
            if(val.length<6){
              return 'Password too short (needs to be at least 6 character long)';
            }
            else if(val.isEmpty){
              return "Please enter a password.";
            }
            else{
              return null;
            }
          },
          obscureText: true,
          style: style,
          onChanged: (val){
            setState(() {
              password = val;
            });
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        
        final registerButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.lightBlue,
          child: MaterialButton(
           minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
                if(formkey.currentState.validate()){//make sure user input are acceptable
                    dynamic result = await _auth.registerwithEandP(email, password);
                    if(result == null){
                      setState((){
                        error= 'bruh';
                      });
                    }
                }
            },
            child: Text("Register",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        

        return Scaffold(
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: formkey,
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                        child: titletext,
                      ),
                      // SizedBox(
                      //   height: 100.0,
                      //   child: Image.asset(
                      //     "assets/ridericon.png",
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),  //change this to a signup title
                      
                      SizedBox(height: 45.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      registerButton,
                      SizedBox(
                        height:  10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }


