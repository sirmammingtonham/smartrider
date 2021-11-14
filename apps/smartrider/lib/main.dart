import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/blocs/authentication/data/authentication_repository.dart';
import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:smartrider/blocs/map/data/shuttle_repository.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/data/saferide_repository.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/ui/home.dart';
import 'package:smartrider/ui/welcome.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// test imports
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // crashlytics not supported on web
  if (!kIsWeb) {
    if (kDebugMode) {
      // avoid generating crash reports when the app is in debug mode.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseFunctions.instance.useFunctionsEmulator('10.0.2.2', 5001);
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);

  final app = SmartRider(
    authRepo: AuthenticationRepository.create(),
    busRepo: await BusRepository.create(),
    shuttleRepo: ShuttleRepository.create(),
    saferideRepo: SaferideRepository.create(),
  );

  if (!kIsWeb) {
    //catch async errors as well
    await runZonedGuarded(
      () async {
        runApp(app);
      },
      FirebaseCrashlytics.instance.recordError,
    );
  } else {
    runApp(app);
  }
}

class SmartRider extends StatefulWidget {
  const SmartRider({
    Key? key,
    required this.authRepo,
    required this.busRepo,
    required this.shuttleRepo,
    required this.saferideRepo,
  }) : super(key: key);
  final AuthenticationRepository authRepo;
  final BusRepository busRepo;
  final ShuttleRepository shuttleRepo;
  final SaferideRepository saferideRepo;

  @override
  SmartRiderState createState() => SmartRiderState();
}

class SmartRiderState extends State<SmartRider> with WidgetsBindingObserver {
  late final AuthenticationBloc _authBloc;
  late final PrefsBloc _prefsBloc;
  late final MapBloc _mapBloc;
  late final SaferideBloc _saferideBloc;
  late final ScheduleBloc _scheduleBloc;
  static const FlexScheme colorScheme = FlexScheme.redWine;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    _prefsBloc = PrefsBloc()..add(const LoadPrefsEvent());
    _authBloc = AuthenticationBloc(authRepository: widget.authRepo)
      ..add(AuthenticationInitEvent());
    _saferideBloc = SaferideBloc(
      prefsBloc: _prefsBloc,
      saferideRepo: widget.saferideRepo,
      authRepo: widget.authRepo,
    );
    _mapBloc = MapBloc(
      saferideBloc: _saferideBloc,
      prefsBloc: _prefsBloc,
      busRepo: widget.busRepo,
      shuttleRepo: widget.shuttleRepo,
      saferideRepo: widget.saferideRepo,
    );
    _scheduleBloc = ScheduleBloc(
      mapBloc: _mapBloc,
      busRepo: widget.busRepo,
    );

    final window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      // This callback is called every time the brightness changes.
      _mapBloc.add(
        MapThemeChangeEvent(
          theme: window.platformBrightness == Brightness.light
              ? FlexColorScheme.light(scheme: colorScheme).toTheme
              : FlexColorScheme.dark(scheme: colorScheme).toTheme,
        ),
      );
      setState(() {});
    };

    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final deepLink = dynamicLink?.link;
        if (deepLink != null) {
          await _handleDeepLink(deepLink);
        }
      },
      onError: (OnLinkErrorException e) async {
        // print('onLinkError');
        // print(e.message);
        // TODO: error handling
      },
    );

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      await _handleDeepLink(deepLink);
    }
  }

  Future<void> _handleDeepLink(Uri link) async {
    final params = link.queryParameters;
    if (params.containsKey('error')) {
      // TODO: error handling
    } else {
      // _authBloc.add();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // monitor if the app is in the background (might not be needed but ¯\_(ツ)_/¯)
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PrefsBloc>(create: (context) => _prefsBloc),
        BlocProvider<AuthenticationBloc>(create: (context) => _authBloc),
        BlocProvider<SaferideBloc>(create: (context) => _saferideBloc),
        BlocProvider<MapBloc>(create: (context) => _mapBloc),
        BlocProvider<ScheduleBloc>(create: (context) => _scheduleBloc),
      ],
      child: MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
        title: 'smartrider Prototype',
        theme: FlexColorScheme.light(scheme: colorScheme).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: colorScheme).toTheme,
        home: ShowCaseWidget(
          builder: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  child: const Text('Test Auth Redirect and shid'),
                  onPressed: () async {
                    await ChromeSafariBrowser().open(
                      url: Uri.parse(
                          'http://10.0.2.2:5001/smartrider-4e9e8/us-central1/casAuthenticate'),
                      options: ChromeSafariBrowserClassOptions(
                        android: AndroidChromeCustomTabsOptions(
                          addDefaultShareMenuItem: false,
                        ),
                        ios: IOSSafariOptions(barCollapsingEnabled: true),
                      ),
                    );
                  },
                ),
              ),
            ), //const WelcomeScreen(homePage: HomePage()),
          ),
          autoPlay: true,
          autoPlayDelay: const Duration(seconds: 10),
        ),
        // TODO: put all this shid into an onboarding bloc so we dont rebuild
        //  the whole app each time we change settings...

        // BlocBuilder<PrefsBloc, PrefsState>(
        //     builder: (BuildContext context, PrefsState state) {
        //   if (state is PrefsLoadedState) {
        //     return ShowCaseWidget(
        //       builder: Builder(
        //           builder: (context) => state.firstLaunch!
        //               ? const OnboardingScreen()
        //               : const WelcomeScreen(homePage: HomePage())),
        //       autoPlay: true,
        //       autoPlayDelay: const Duration(seconds: 10),
        //     );
        //   } else {
        //     return const MaterialApp(home: CircularProgressIndicator());
        //   }
        // }),
      ),
    );
  }
}
