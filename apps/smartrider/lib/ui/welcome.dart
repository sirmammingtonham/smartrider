import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/ui/home.dart';

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
            ),
          ),
          duration: const Duration(days: 1),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.runtimeType) {
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
  AuthenticationUIState createState() => AuthenticationUIState();
}

class AuthenticationUIState extends State<AuthenticationUI> {
  static const authUrl =
      'http://10.0.2.2:5001/smartrider-4e9e8/us-central1/casAuthenticate';

  @override
  void initState() {
    super.initState();
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await ChromeSafariBrowser().open(
                    url: Uri.parse(
                      authUrl,
                    ),
                    options: ChromeSafariBrowserClassOptions(
                      android: AndroidChromeCustomTabsOptions(
                        addDefaultShareMenuItem: false,
                      ),
                      ios: IOSSafariOptions(barCollapsingEnabled: true),
                    ),
                  );
                },
                child: const Text(
                  'LOGIN (CAS)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .secondary, //color of clip on bottom right
                height: 200,
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
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height + 5);
    final secondControlPoint =
        Offset(size.width - (size.width / 6), size.height);
    final secondEndPoint = Offset(size.width, 0);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
