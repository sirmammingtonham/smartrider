import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/ui/home.dart';
// import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key, required this.homePage}) : super(key: key);
  final HomePage homePage;

  void showErrorSnackBar({
    required BuildContext context,
    required String text,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // backgroundColor: Theme.of(context).primaryColorDark,
          content: ListTile(
              leading: const Icon(Icons.warning, color: Colors.white),
              title: Text(
                text,
                style: const TextStyle(color: Colors.white),
              )),
          duration: const Duration(days: 1),
        ),
      );

// TODO: add forgot password thing
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AuthenticationAwaitVerificationState:
              showErrorSnackBar(
                context: context,
                text: 'Please check email for verification.',
              );
              break;
            case AuthenticationFailedState:
              showErrorSnackBar(
                context: context,
                text: (state as AuthenticationFailedState).message,
              );
              break;
            default:
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              break;
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case AuthenticationSignedOutState:
              case AuthenticationFailedState:
              case AuthenticationAwaitVerificationState:
                return const AuthenticationUI();
              case AuthenticationSignedInState:
              default:
                return homePage;
            }
          },
        ),
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
  late final TextEditingController passwordConfirmController;
  // late final TextEditingController phoneController;
  late final GlobalKey<FormState> formKey;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // fat regex matches any form of valid phone number lol
    phoneRegex = RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    // phoneController = TextEditingController();
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
          height: 422,
          width: 380,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(pathToImage)),
          ),
        ),
      ),
    );
  }

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
          style: const TextStyle(fontSize: 20),
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
                //color: Theme.of(context).accentColor, // text-box border
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                // color: Theme.of(context)
                //     .primaryColorDark, // text-box border when selected
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                //color: Theme.of(context).errorColor,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              // borderSide: BorderSide(
              //   color: Theme.of(context).errorColor.withOpacity(1),
              // ),
            ),
          ),
        ),
      );

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
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ));
    }
  }

  void attemptSignUp({
    required BuildContext context,
  }) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context)
          .add(AuthenticationSignUpEvent(
        email: emailController.text.trim(),
        // phoneNumber: phoneController.text.trim(),
        password: passwordController.text.trim(),
      ));
    }
  }

  String? emailValidation(String? value) {
    if (value == null) return 'uh oh... null';
    value = value.trim();
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
    value = value.trim();
    if (value.isEmpty) {
      return 'Please enter a password.';
    } else if (value.length < 6) {
      return 'Password needs to be at least 6 characters';
    } else {
      return null;
    }
  }

  String? passwordConfirmValidation(String? value) {
    if (value == null) return 'uh oh... null';
    value = value.trim();
    if (value.isEmpty) {
      return 'Please confirm your password.';
    } else if (value != passwordController.text.trim()) {
      return 'Password needs to be at least 6 characters';
    } else {
      return null;
    }
  }

  // String? phoneValidation(String? value) {
  //   if (value == null) return 'uh oh... null';
  //   value = value.trim();
  //   if (value.isEmpty) {
  //     return 'Please enter a phone number.';
  //   } else if (!phoneRegex.hasMatch(value)) {
  //     return 'Your passwords don\'t match!';
  //   } else {
  //     return null;
  //   }
  // }

  void showAuthenticationSheet({
    required BuildContext context,
    required String text,
    required List<Widget> formFields,
    required Function({
      required BuildContext context,
    })
        authFunction,
  }) =>
      showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 350
                      : 438,
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
                                          //color: Theme.of(context).accentColor,
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
                              height: 79,
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
                                width: 250,
                                child: welcomeScreenButton(
                                  context: context,
                                  text: text,
                                  onPressed: () {
                                    authFunction(context: context);
                                    Navigator.of(context).pop();
                                  },
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
              height: 55,
              child: welcomeScreenButton(
                context: context,
                text: 'LOGIN',
                onPressed: () => showAuthenticationSheet(
                  context: context,
                  text: 'LOGIN',
                  authFunction: attemptSignIn,
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
              height: 55,
              child: welcomeScreenButton(
                context: context,
                text: 'REGISTER',
                onPressed: () => showAuthenticationSheet(
                  context: context,
                  text: 'REGISTER',
                  authFunction: attemptSignUp,
                  formFields: [
                    formInputField(
                      context: context,
                      icon: const Icon(Icons.email),
                      hint: 'RPI Email',
                      controller: emailController,
                      validator: emailValidation,
                    ),
                    // formInputField(
                    //   context: context,
                    //   icon: const Icon(Icons.phone_iphone),
                    //   hint: 'Phone Number',
                    //   controller: phoneController,
                    //   validator: phoneValidation,
                    // ),
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
                    StatefulBuilder(
                      builder: (context, setPasswordState) => formInputField(
                        context: context,
                        icon: const Icon(Icons.check_circle),
                        hint: 'Confirm Password',
                        controller: passwordConfirmController,
                        setPasswordState: setPasswordState,
                        validator: passwordConfirmValidation,
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
                    .primaryColor, //color of clip on bottom right
                height: 120,
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
