import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  final Widget homePage;

  const WelcomeScreen({@required this.homePage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationInit) {
        return 
        Theme(data: Theme.of(context).copyWith(canvasColor: Colors.transparent),child: SignupUI());
        // bruh this is an event not a state
        // } else if (state is AuthenticationLoggedIn) {
        //   return HomePage();
      } else if (state is AuthenticationSuccess) {
        return homePage;
      } else if (state is AuthenticationFailure) {
        final SnackBar snackbar = SnackBar(
            content: Text(
          "Email or Password is Incorrect",
          textAlign: TextAlign.center,
        ));
        Scaffold.of(context).showSnackBar(snackbar);
        return SignupUI();
      } else {
        return Center(child: Text("bruh moment occured"));
      }
    }));
  }
}

class SignupUI extends StatefulWidget {
  @override
  _SignupUIState createState() => _SignupUIState();
}

class _SignupUIState extends State<SignupUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  Color primary;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              child: Align(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  width: 150,
                  height: 150,
                ),
              ),
              height: 154,
            )),
            Positioned(
              child: Container(
                  padding: EdgeInsets.only(right: 35),
                  height: 130,
                  child: Align(
                    child: Text(
                      "smart",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )),
            ),
            Positioned(
              child: Container(
                  padding: EdgeInsets.only(left: 40),
                  height: 210,
                  child: Align(
                    child: Text(
                      "rider",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              bottom: MediaQuery.of(context).size.height * 0.046,
              right: MediaQuery.of(context).size.width * 0.22,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.08,
              bottom: 0,
              right: MediaQuery.of(context).size.width * 0.32,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //input widget
  Widget _input(Icon icon, String hint, TextEditingController controller,
      bool obscure, Function valFunc) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: valFunc,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }

  //button widget
  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
      ),
      onPressed: () {
        function();
      },
    );
  }

  void _loginUser() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationLoggedIn(_emailController.text, _passwordController.text),
      );

      // _email = _emailController.text;
      // _password = _passwordController.text;
      // _emailController.clear();
      // _passwordController.clear();
    }
  }

  void _registerUser() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationSignUp(_emailController.text, _passwordController.text),
      );

      // _email = _emailController.text;
      // _password = _passwordController.text;
      // _rin = _nameController.text;
      // _emailController.clear();
      // _passwordController.clear();
      // _nameController.clear();
    }
  }

  String _emailValidation(String value) {
    if (value.isEmpty) {
      return 'Enter an email';
    } else if (!value.contains("@rpi.edu")) {
      return "Please enter a valid rpi email";
    } else {
      return null;
    }
  }

  String _passValidation(String value) {
    if (value.length < 6) {
      return 'Password needs to be at least 6 characters';
    } else if (value.isEmpty) {
      return "Please enter a password.";
    }

    return null;
  }

  String _rinValidation(String val) {
    if (val.length != 9 || !val.startsWith("66")) {
      return 'Please enter a valid RIN';
    }
    return null;
  }

  void _showLoginSheet() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _emailController.clear();
                            _passwordController.clear();
                          },
                          icon: Icon(
                            Icons.highlight_off,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  height: 50,
                  width: 50,
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  child: Text(
                                    "login",
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 60),
                          child: _input(Icon(Icons.email), "RPI EMAIL",
                              _emailController, false, _emailValidation),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(Icon(Icons.lock), "PASSWORD",
                              _passwordController, true, _passValidation),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            child: _button("LOGIN", Colors.white, primary,
                                primary, Colors.white, _loginUser),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  void _showRegisterSheet() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _emailController.clear();
                            _passwordController.clear();
                            _nameController.clear();
                          },
                          icon: Icon(
                            Icons.highlight_off,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  height: 50,
                  width: 50,
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Align(
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 30, right: 44),
                                child: Text(
                                  "regi",
                                  style: TextStyle(
                                    fontSize: 54,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              child: Align(
                                child: Container(
                                  padding: EdgeInsets.only(top: 55, left: 20),
                                  width: 130,
                                  child: Text(
                                    "ster",
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          top: 60,
                        ),
                        child: _input(Icon(Icons.account_circle), "RIN",
                            _nameController, false, _rinValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: _input(Icon(Icons.email), "RPI EMAIL",
                            _emailController, false, _emailValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: _input(Icon(Icons.lock), "PASSWORD",
                            _passwordController, true, _passValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: _button("REGISTER", Colors.white, primary,
                              primary, Colors.white, _registerUser),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    primary = Theme.of(context).primaryColor;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            logo(),
            Padding(
              child: Container(
                child: _button("LOGIN", primary, Colors.white, Colors.white,
                    primary, _showLoginSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            ),
            Padding(
              child: Container(
                child: OutlineButton(
                  highlightedBorderColor: Colors.white,
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  highlightElevation: 0.0,
                  splashColor: Colors.white,
                  highlightColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    _showRegisterSheet();
                  },
                ),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
