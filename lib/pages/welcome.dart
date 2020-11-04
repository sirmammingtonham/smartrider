import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/pages/home.dart';

class WelcomeScreen extends StatelessWidget {
  final HomePage homePage;

  const WelcomeScreen({@required this.homePage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
      if (state is AuthenticationFailure) {
        final SnackBar snackbar = SnackBar(
            content: Text(
          state.errorMessage,
          textAlign: TextAlign.center,
        ));
        Scaffold.of(context).showSnackBar(snackbar);
      } else if (state is AwaitEmailVerify) {
        final SnackBar snackbar = SnackBar(
            content: Text(
          "Please check your email for verification",
          textAlign: TextAlign.center,
        ));
        Scaffold.of(context).showSnackBar(snackbar);
      }
    }, child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
      if (state is AuthenticationInit) {
        return Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: SignupUI());
      } else if (state is AuthenticationSuccess) {
        return homePage;
      } else if (state is AuthenticationFailure) {
        return Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: SignupUI());
      } else if (state is AwaitEmailVerify) {
        return Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: SignupUI());
      } else {
        return Center(child: Text("bruh moment occured"));
      }
    })));
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
  TextEditingController _rinController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String role =
      'Student'; // default role is student (implement role chooser in the future)
  PersistentBottomSheetController _sheetController;
  bool _obscurePass = true;

  Color primary;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  //Image(image: AssetImage('assets/app_icons/App\ Logo\ v1.png'))

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Align(
        child: Container(
          height: 250.0,
          width: 250.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/app_icons/logo_v1.png")),
          ),
        ),
        alignment: Alignment.center,
      ),
    );
    Padding(padding: EdgeInsets.only(top: 15),
    child: Align(
      child: Text( // THIS TEXT IS NOT APPEARING FOR SOME REASON
        "SMARTRIDER",
        style: TextStyle(
          fontSize: 100,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
      alignment: Alignment.center,
    ));
  }

  /*

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
                  //padding: EdgeInsets.only(right: 35),
                  height: 10,
                  child: Align(
                    child: Text(
                      "SMARTRIDER",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    alignment: Alignment.center,
                  )),
            ),
            /*
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
            */
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
  */

  //input widget
  Widget _input(Icon icon, String hint, TextEditingController controller,
      bool isPassField, Function valFunc) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassField ? _obscurePass : false,
        validator: valFunc,
        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.redAccent),
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorLight,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorLight,
              width: 2,
            ),
          ),
          prefixIcon: Padding(
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).primaryColor),
              child: icon,
            ),
            padding: EdgeInsets.only(left: 30, right: 10),
          ),
          // create a password visibility button for password fields
          suffixIcon: isPassField
              ? Padding(
                  child: IconTheme(
                    data: IconThemeData(color: Theme.of(context).primaryColor),
                    child: IconButton(
                        icon: _obscurePass
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () => _sheetController.setState(() {
                              _obscurePass = !_obscurePass;
                            })),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 10),
                )
              : null,
        ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
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
        AuthenticationLoggedIn(
            _emailController.text, _passwordController.text, role),
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
        AuthenticationSignUp(_emailController.text, _nameController.text,
            _passwordController.text, _rinController.text, role),
      );
      BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationLoggedIn(
            _emailController.text, _passwordController.text, role),
      );

      // _email = _emailController.text;
      // _password = _passwordController.text;
      // _rin = _rinController.text;
      // _emailController.clear();
      // _passwordController.clear();
      // _rinController.clear();
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
    if (val.trim().length != 9 || !val.startsWith("66")) {
      return 'Please enter a valid RIN';
    }
    return null;
  }

  String _nameValidation(String val) {
    if (val.trim().length == 0) {
      return "Please don't leave the name field blank";
    }
    return null;
  }

  void _showLoginSheet() {
    _sheetController =
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
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 37,
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
    _sheetController =
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
                            _rinController.clear();
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
                                //padding: EdgeInsets.only(bottom: 30, right: 44),
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            /*
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
                            */
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          top: 60,
                        ),
                        child: _input(Icon(Icons.contacts), "RIN",
                            _rinController, false, _rinValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: _input(Icon(Icons.account_circle), "FIRST NAME",
                            _nameController, false, _nameValidation),
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
    /*
      Area to implement bypass if auto signed in

      return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
      if (state is AuthenticationSuccess) {
        return homePage;
      }})

    */

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
                height: 65,
              ),
              padding: EdgeInsets.only(top: 200, left: 20, right: 20),
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
                height: 65,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 450,
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
