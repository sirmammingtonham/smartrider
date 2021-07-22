import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/pages/home.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key, required this.homePage}) : super(key: key);
  final HomePage homePage;
// TODO: add forgot password thing
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case AuthenticationEmailVerificationState:
//TODO: create widget for email verification, or maybe persist snackbar
              return Container();
            case AuthenticationFailedState:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text((state as AuthenticationFailedState).message),
              ));
              return const AuthenticationUI();
            case AuthenticationSignedOutState:
              return const AuthenticationUI();
            case AuthenticationSignedInState:
              return homePage;
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class AuthenticationUI extends StatefulWidget {
  const AuthenticationUI({Key? key}) : super(key: key);
  @override
  _AuthenticationUIState createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  late final RegExp phoneRegex;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;
  late final GlobalKey<FormState> formKey;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // matches any form of valid phone number lol
    phoneRegex = RegExp(r'(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}');
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  Widget logoWidget({
    required BuildContext context,
  }) {
    String pathToImage;
    if (Theme.of(context).brightness == Brightness.dark) {
      // in dark mode
      pathToImage = 'assets/onboarding_images/logo_light.png';
    } else {
      pathToImage = 'assets/onboarding_images/logo_dark.png';
    }
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 53.h,
          width: 95.w,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(pathToImage)),
          ),
        ),
      ),
    );
  }

// Padding(padding: const EdgeInsets.only(bottom: 20, top: 25),
  //input widget
  Widget formInputField({
    required BuildContext context,
    required Icon icon,
    required String hint,
    required TextEditingController controller,
    StateSetter? setPasswordState, // if this field is password
    String? Function(String?)? validator,
  }) =>
      Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextFormField(
          controller: controller,
          obscureText: setPasswordState != null ? obscurePassword : false,
          validator: validator,
          style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: icon),
            // create a password visibility button for password fields
            suffixIcon: setPasswordState != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 30, right: 10),
                    child: IconButton(
                      icon: obscurePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () => setPasswordState(() {
                        obscurePassword = !obscurePassword;
                      }),
                    ),
                  )
                : null,
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).accentColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).accentColor, // text-box border
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .primaryColorDark, // text-box border when selected
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).errorColor,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).errorColor.withOpacity(1),
              ),
            ),
          ),
        ),
      );

  //button widget
  Widget welcomeScreenButton({
    required BuildContext context,
    required String text,
    required void Function() onPressed,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );

  void attemptSignIn({
    required BuildContext context,
  }) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context)
          .add(AuthenticationSignInEvent(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  void attemptSignUp({
    required BuildContext context,
  }) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context)
          .add(AuthenticationSignUpEvent(
        email: emailController.text,
        phoneNumber: phoneController.text,
        password: passwordController.text,
      ));
    }
  }

  String? emailValidation(String? value) {
    if (value == null) return 'uh oh... null';
    if (value.isEmpty) {
      return 'Please enter an email';
    } else if (!value.endsWith('@rpi.edu')) {
      return 'You must enter a valid RPI email.';
    } else {
      return null;
    }
  }

  String? passwordValidation(String? value) {
    if (value == null) return 'uh oh... null';
    if (value.isEmpty) {
      return 'Please enter a password.';
    } else if (value.length < 6) {
      return 'Password needs to be at least 6 characters';
    } else {
      return null;
    }
  }

  String? phoneValidation(String? value) {
    if (value == null) return 'uh oh... null';
    if (value.isEmpty) {
      return 'Please enter a phone number.';
    } else if (!phoneRegex.hasMatch(value)) {
      return 'You must enter a valid phone number.';
    } else {
      return null;
    }
  }

  void showAuthenticationSheet({
    required BuildContext context,
    required String text,
    required List<Widget> formFields,
  }) =>
      showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0)),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 80.h
                      : 55.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // phoneController.clear();
                                          // emailController.clear();
                                          // passwordController.clear();
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 40.0,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      )))
                            ],
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(children: <Widget>[
                            SizedBox(
                              // width: MediaQuery.of(context).size.width,
                              height: 10.h,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ...formFields,
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                height: 50,
                                width: 60.w,
                                child: welcomeScreenButton(
                                  context: context,
                                  text: text,
                                  onPressed: () =>
                                      attemptSignUp(context: context),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          logoWidget(
            context: context,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: 7.h,
              child: welcomeScreenButton(
                context: context,
                text: 'LOGIN',
                onPressed: () => showAuthenticationSheet(
                  context: context,
                  text: 'LOGIN',
                  formFields: [
                    formInputField(
                      context: context,
                      icon: const Icon(Icons.email),
                      hint: 'RPI Email',
                      controller: emailController,
                      validator: emailValidation,
                    ),
                    StatefulBuilder(
                      builder: (context, setPasswordState) => formInputField(
                        context: context,
                        icon: const Icon(Icons.lock),
                        hint: 'Password',
                        controller: passwordController,
                        setPasswordState: setPasswordState,
                        validator: passwordValidation,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SizedBox(
              height: 7.h,
              child: welcomeScreenButton(
                context: context,
                text: 'REGISTER',
                onPressed: () => showAuthenticationSheet(
                  context: context,
                  text: 'REGISTER',
                  formFields: [
                    formInputField(
                      context: context,
                      icon: const Icon(Icons.email),
                      hint: 'RPI Email',
                      controller: emailController,
                      validator: emailValidation,
                    ),
                    formInputField(
                      context: context,
                      icon: const Icon(Icons.phone_iphone),
                      hint: 'Phone Number',
                      controller: phoneController,
                      validator: phoneValidation,
                    ),
                    StatefulBuilder(
                      builder: (context, setPasswordState) => formInputField(
                        context: context,
                        icon: const Icon(Icons.lock),
                        hint: 'Password',
                        controller: passwordController,
                        setPasswordState: setPasswordState,
                        validator: passwordValidation,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: Theme.of(context)
                    .accentColor, //color of clip on bottom right
                height: 15.h,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..lineTo(0.0, size.height + 5);
    final secondControlPoint =
        Offset(size.width - (size.width / 6), size.height);
    final secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
