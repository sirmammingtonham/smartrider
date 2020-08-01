import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/pages/login.dart';
import 'package:smartrider/services/user_repository.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


 class Signuppage extends StatelessWidget {
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        AuthenticationBloc authbloc = BlocProvider.of<AuthenticationBloc>(context);
        return MaterialApp(
          title: "smart rider signup",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context,state){
            if(state is AuthenticationInit){
               return SignupHome(title: 'Smartrider Signup', bloc: authbloc);
            }
            else if (state is AuthenticationFailure){
               return SignupHome(title: 'Smartrider Signup', bloc: authbloc);
            }
            else {  //sign up is sucessful
               return Stack(children: <Widget>[Center(
                              child: RaisedButton(
                            child: Text(
                              'SIGN OUT',
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: ()  {
                              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut(),);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loginpage()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))),
              ),],);
            }
          }),
        );
      }
    }

 class SignupHome extends StatefulWidget {
      SignupHome({Key key, 
      @required this.bloc,
      this.title}) : super(key: key);
      final String title;
      final AuthenticationBloc bloc;
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
            "Welcome!", 
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 30),
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
              hintText: "Enter RPI email",
              hintStyle: style,
                 filled: true,
              fillColor: Colors.white.withOpacity(1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
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
              hintStyle: style,
                 filled: true,
              fillColor: Colors.white.withOpacity(1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
        final confirmpasswordField = TextFormField(
          validator: (val){
            if(val.length<6){
              return 'confirm password too short.';
            }
            else if(val.isEmpty){
              return "Please confirm your password.";
            }
            else if(confirmpassword!=password){
              return "The passwords entered do not match.";
            }
            else{
              return null;
            }
          },
          obscureText: true,
          style: style,
          onChanged: (val){
            setState(() {
              confirmpassword = val;
            });
          },
          decoration: InputDecoration(
               contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Confirm Password",
              hintStyle: style,
                 filled: true,
              fillColor: Colors.white.withOpacity(1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
        
        final registerButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(93, 188, 210,1),
          child: MaterialButton(
           minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
                if(formkey.currentState.validate()){//make sure user input are acceptable
                  widget.bloc.add(AuthenticationSignUp(email, password));
                }
            },
            child: Text("Register",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        final backButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(93, 188, 210,1),
          child: MaterialButton(
           minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
                    Navigator.push(
                              context,
                       MaterialPageRoute(builder: (context) => Loginpage()),
                              );
            },
            child: Text("Back",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        return Scaffold(
          body: CustomPaint(
            painter: BluePainter(),
                      child: Center(
              child: Container(
                
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: formkey,
                                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        titletext,
                        SizedBox(height: 45.0),
                        emailField,
                        SizedBox(height: 25.0),
                        passwordField,
                        SizedBox(
                          height: 25.0,
                        ),
                        confirmpasswordField,
                        SizedBox(
                          height: 30.0,
                        ),
                        registerButton,
                        SizedBox(
                          height:  10.0,
                        ),
                        backButton,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint(); 

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = 	Color.fromRGBO(102, 94, 255,1);
    var xcoord = width;
    var ycoord = height/2+40;
    
    canvas.drawCircle(Offset(xcoord,ycoord), 200, paint);
  }
    
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
  }


