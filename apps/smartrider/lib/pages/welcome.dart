import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/pages/home.dart';
import 'package:sizer/sizer.dart';

//TODO:
class WelcomeScreen extends StatelessWidget {
  final HomePage homePage;

  const WelcomeScreen({required this.homePage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
      if (state is AuthenticationFailure) {
        final SnackBar snackbar = SnackBar(
            content: Text(
          state.errorMessage!,
          textAlign: TextAlign.center,
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else if (state is AwaitEmailVerify) {
        final SnackBar snackbar = SnackBar(
            content: Text(
          "Please check your email for verification",
          textAlign: TextAlign.center,
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
  late PersistentBottomSheetController _sheetController;
  bool _obscurePass = true;

  Color? primary;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  //Image(image: AssetImage('assets/app_icons/App\ Logo\ v1.png'))

  Widget logo() {
    String pathToImage = "";
    // if (Theme.of(context).brightness == Brightness.dark) {
    //   // in dark mode
    //   pathToImage = 'assets/app_icons/app_icon_word_dark_mode.png';
    // } else {
    //   pathToImage = 'assets/app_icons/app_icon_word_light_mode.png';
    // }
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Align(
        child: Container(
          height: 65.h,
          width: 95.w,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(pathToImage)),
          ),
        ),
        alignment: Alignment.center,
      ),
    );
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
      bool isPassField, String? Function(String?)? valFunc) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassField ? _obscurePass : false,
        validator: valFunc,
        style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Theme.of(context).errorColor),
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).accentColor), //text-box word placeholder
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor, // text-box border
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Theme.of(context)
                  .primaryColorDark, // text-box border when selected
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context)
                  .errorColor, // literally nothing, gave it errColor because its called "errorBorder"
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorDark, // even more nothing
              width: 2,
            ),
          ),
          prefixIcon: Padding(
            child: IconTheme(
              data: IconThemeData(
                  color: Theme.of(context)
                      .accentColor), // icons before text-box word placeholders
              child: icon,
            ),
            padding: EdgeInsets.only(left: 30, right: 10),
          ),
          // create a password visibility button for password fields
          suffixIcon: isPassField
              ? Padding(
                  child: IconTheme(
                    data: IconThemeData(
                        color: Theme.of(context)
                            .accentColor), // password visibility button
                    child: IconButton(
                        icon: _obscurePass
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () => _sheetController.setState!(() {
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          //highlightElevation: 0.0,
          // splashColor: splashColor,
          // highlightColor: highlightColor,
          elevation: 0.0,
          primary: fillColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        function();
      },
    );
  }

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
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
    if (_formKey.currentState!.validate()) {
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

  String? _emailValidation(String? value) {
    if (value == null) return null;
    if (value.isEmpty)
      return 'Enter an email';
    else if (!value.contains("@rpi.edu"))
      return "You must enter a valid RPI email.";
    else
      return null;
  }

  String? _passValidation(String? value) {
    if (value == null) return null;
    if (value.isEmpty)
      return "Please enter a password.";
    else if (value.length < 6)
      return 'Password needs to be at least 6 characters';
    else
      return null;
  }

  String? _nameValidation(String? val) {
    if (val == null) return null;
    if (val.trim().isEmpty) return "Please don't leave the name field blank";

    return null;
  }

  void _showLoginSheet() {
    _sheetController = _scaffoldKey.currentState!
        .showBottomSheet<void>((BuildContext context) {
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
                          child: Align(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _emailController.clear();
                                  _passwordController.clear();
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 40.0,
                                  // color: Theme.of(context)
                                  //     .accentColor, // back (X) icon color
                                ),
                              ),
                              alignment: Alignment.center))
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
                              /*
                                Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              */
                              Positioned(
                                left: 20,
                                top: 50,
                                child: Container(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      // LOGIN word color
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 25),
                          child: _input(Icon(Icons.email), "RPI Email",
                              _emailController, false, _emailValidation),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(Icon(Icons.lock), "Password",
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
                            child: _button(
                                "LOGIN",
                                Theme.of(context).primaryColorDark, //splash
                                Theme.of(context)
                                    .primaryColor, //highlight color
                                Theme.of(context)
                                    .accentColor, //button fill color
                                Theme.of(context)
                                    .primaryColorLight, // text color
                                _loginUser),
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
            color: Colors.white, // entire login sheet color
          ),
        ),
      );
    });
  }

  void _showRegisterSheet() {
    _sheetController = _scaffoldKey.currentState!
        .showBottomSheet<void>((BuildContext context) {
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
                          child: Align(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _rinController.clear();
                                  _nameController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 40.0,
                                  color: Theme.of(context)
                                      .accentColor, // back (X) icon color
                                ),
                              ),
                              alignment: Alignment.center))
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
                            /*
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
                            */
                            Positioned(
                              left: 20,
                              top: 50,
                              child: Container(
                                //padding: EdgeInsets.only(bottom: 30, right: 44),
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    // color: Theme.of(context).accentColor,
                                  ),
                                ),
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
                      /*     === DEPRECIATED ===
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          top: 25,
                        ),
                        child: _input(Icon(Icons.contacts), "RIN",
                            _rinController, false, _rinValidation),
                      ),
                      */
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: _input(Icon(Icons.account_circle), "First Name",
                            _nameController, false, _nameValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: _input(Icon(Icons.email), "RPI Email",
                            _emailController, false, _emailValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: _input(Icon(Icons.lock), "Password",
                            _passwordController, true, _passValidation),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: _button(
                              "REGISTER",
                              Theme.of(context).primaryColorDark, //splash
                              Theme.of(context).primaryColor, //highlight color
                              Theme.of(context).accentColor, //button fill color
                              Theme.of(context).primaryColorLight, // text color
                              _registerUser),
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
            color: Colors.white, // entire register sheet color
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
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        // backgroundColor:
        //     Theme.of(context).primaryColor, // main welcome screen color
        body: Column(
          children: <Widget>[
            logo(),
            /*
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Align(
                  child: Text(
                    "SMARTRIDER",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  alignment: Alignment.center,
                )),
                */
            Padding(
              child: Container(
                child: _button(
                    "LOGIN",
                    Theme.of(context).primaryColorDark, //splash
                    Theme.of(context).primaryColorDark, //highlight color
                    Theme.of(context).accentColor, //button fill color
                    Theme.of(context).primaryColor, // text color
                    _showLoginSheet),
                height: 7.h,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Padding(
              child: Container(
                child: _button(
                    "REGISTER",
                    Theme.of(context).primaryColorDark, //splash
                    Theme.of(context).primaryColorDark, //highlight color
                    Theme.of(context).primaryColor, //button fill color
                    Theme.of(context).accentColor, // text color
                    _showRegisterSheet),
                height: 7.h,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),

            /*
            Padding(
              child: Container(
                child: OutlineButton(
                  highlightedBorderColor: Theme.of(context).accentColor,
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor, width: 2.0), //color of border on register button
                  highlightElevation: 0.0,
                  splashColor: Theme.of(context).primaryColorDark, // splash when tapped color
                  highlightColor: Theme.of(context).primaryColorDark, // register button on press and hold
                  color: Theme.of(context).accentColor, // color of: idk
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor, //color of word register on button
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
            */
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Theme.of(context)
                        .accentColor, //color of clip on bottom right
                    height: 800,
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
