import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 

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
      @override
      Widget build(BuildContext context) {
        
        final titletext = Text(
            "SignUp for Smartrider", 
            textAlign: TextAlign.center,
            style: GoogleFonts.alef(fontSize: 30),
        );
        final emailField = TextField(
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Username",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final passwordField = TextField(
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final loginButon = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.green,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        final registerButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.lightBlue,
          child: MaterialButton(
           minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
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
                    loginButon,
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
        );
      }
    }


