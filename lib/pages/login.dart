import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/main.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/pages/settings.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';
import 'signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smart rider login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is AuthenticationInit) {
          //output loading screen
          return LoginWidget(
              title: "SmartRiderLogin",
              bloc: BlocProvider.of<AuthenticationBloc>(context),
              err: "");
        } else if (state is AuthenticationLoggedIn) {
          //if the user is already logged in stay that way
          return SettingsPage();
        } else if (state is AuthenticationSuccess) {
          return Stack(
            children: <Widget>[
              Center(
                child: RaisedButton(
                    child: Text(
                      'SIGN OUT',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        AuthenticationLoggedOut(),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
              ),
            ],
          );
        } else if (state is AuthenticationFailure) {
          return LoginWidget(
              title: "SmartRiderLogin",
              bloc: BlocProvider.of<AuthenticationBloc>(context),
              err: "email or password is incorrect");
        }
      }),
    );
  }
}

class LoginWidget extends StatefulWidget {
  final AuthenticationBloc bloc;
  LoginWidget({
    Key key,
    @required this.title,
    @required this.bloc,
    @required this.err,
  }) : super(key: key);
  final String title;
  final String err; // error from previous iteration

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String email = '';
  String password = '';
  String error = '';
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.err == "") {
      //if previous iteration didn't throw auth failure
      widget.bloc.add(AuthenticationStarted());
    }
    error = widget.err;
    final emailField = TextFormField(
      validator: (val) {
        if (val.isEmpty) {
          return 'Enter an email';
        } else if (!val.contains("@")) {
          return "Please enter a valid email";
        } else {
          return null;
        }
      },
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Emails",
          hintStyle: style,
          filled: true,
          fillColor: Colors.white.withOpacity(1),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final passwordField = TextFormField(
      validator: (val) {
        if (val.length < 6) {
          return 'Password needs to be at least 6 characters';
        } else if (val.isEmpty) {
          return "Please enter a password.";
        } else {
          return null;
        }
      },
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          hintStyle: style,
          filled: true,
          fillColor: Colors.white.withOpacity(1),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
    final loginButon = Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color.fromRGBO(93, 188, 210, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (formkey.currentState.validate()) {
            widget.bloc.add(
              AuthenticationLoggedIn(email, password),
            );
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final rememberme = Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color.fromRGBO(93, 188, 210, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (formkey.currentState.validate()) {
            widget.bloc.add(
              AuthenticationLoggedIn(email, password),
            );
            //  Navigator.push(
            //    context,
            // MaterialPageRoute(builder: (context) => MyHomePage(title: "SmartRiderLogin",bloc: widget.bloc),
            //   ));
          }
        },
        child: Text("Remember Me",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final signupButton = Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color.fromRGBO(93, 188, 210, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupPage()),
          );
        },
        child: Text("Signup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final errortext = Text(
      error,
      style: TextStyle(color: Colors.red),
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
                    SizedBox(
                      height: 50.0,
                      child: Text(
                        "SmartRider",
                        style: GoogleFonts.montserrat(fontSize: 35),
                      ),
                    ),
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
                    signupButton,
                    errortext,
                    SizedBox(
                      height: 10.0,
                    ),
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
    paint.color = Color.fromRGBO(102, 94, 255, 1);
    var xcoord = width;
    var ycoord = height / 2 + 40;

    canvas.drawCircle(Offset(xcoord, ycoord), 200, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
