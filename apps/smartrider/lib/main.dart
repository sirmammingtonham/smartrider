//implementation imports
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// data repository imports
import 'package:smartrider/data/repositories/authentication_repository.dart';
import 'package:smartrider/data/repositories/bus_repository.dart';
import 'package:smartrider/data/repositories/saferide_repository.dart';
import 'package:smartrider/data/repositories/shuttle_repository.dart';

// page imports
import 'package:smartrider/pages/welcome.dart';
import 'package:smartrider/pages/home.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/pages/onboarding.dart';

// test imports
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // avoid generating crash reports when the app is in debug mode.
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  await AwesomeNotifications().initialize(
    null, // default app icon
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
  );

  // final host = defaultTargetPlatform == TargetPlatform.android
  //     ? '10.0.2.2:8080'
  //     : 'localhost:8080';
//FirebaseFirestore.instance.settings = Settings(host: host, sslEnabled: false);

  final app = SmartRider(
      authRepo: AuthRepository.create(),
      busRepo: await BusRepository.create(),
      shuttleRepo: ShuttleRepository.create(),
      saferideRepo: SaferideRepository.create());

  runZonedGuarded(() {
    //catch async errors as well
    runApp(
      DevicePreview(
        enabled: false, //!kReleaseMode,  // uncomment to use device_preview
        builder: (context) => app,
      ), // Wrap your app
    );
  }, FirebaseCrashlytics.instance.recordError);
}

class SmartRider extends StatefulWidget {
  const SmartRider({
    Key? key,
    required this.authRepo,
    required this.busRepo,
    required this.shuttleRepo,
    required this.saferideRepo,
  }) : super(key: key);
  final AuthRepository authRepo;
  final BusRepository busRepo;
  final ShuttleRepository shuttleRepo;
  final SaferideRepository saferideRepo;

  @override
  _SmartRiderState createState() => _SmartRiderState();
}

class _SmartRiderState extends State<SmartRider> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
        BlocProvider<PrefsBloc>(
          create: (context) => PrefsBloc()..add(const LoadPrefsEvent()),
        ),
        BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(authRepository: widget.authRepo)
                  ..add(AuthenticationStarted())),
        BlocProvider<SaferideBloc>(
          create: (context) => SaferideBloc(
              prefsBloc: BlocProvider.of<PrefsBloc>(context),
              saferideRepo: widget.saferideRepo,
              authRepo: widget.authRepo),
        ),
        BlocProvider<MapBloc>(
            create: (context) => MapBloc(
                saferideBloc: BlocProvider.of<SaferideBloc>(context),
                prefsBloc: BlocProvider.of<PrefsBloc>(context),
                busRepo: widget.busRepo,
                shuttleRepo: widget.shuttleRepo,
                saferideRepo: widget.saferideRepo)),
        BlocProvider<ScheduleBloc>(
          create: (context) => ScheduleBloc(
            mapBloc: BlocProvider.of<MapBloc>(context),
            busRepo: widget.busRepo,
          ),
        ),
      ],
      child: const BlocBuilder<PrefsBloc, PrefsState>(builder: _buildWithTheme),
    );
  }
}

Widget _buildWithTheme(BuildContext context, PrefsState state) {
  if (state is PrefsLoadedState) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          // so we can test on multiple device sizes
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          debugShowCheckedModeBanner: false,
          title: 'smartrider Prototype',
          theme: state.theme,
          home: ShowCaseWidget(
            builder: Builder(
                builder: (context) => state.firstLaunch!
                    ? const OnboardingScreen()
                    : const WelcomeScreen(homePage: HomePage())),
            autoPlay: true,
            autoPlayDelay: const Duration(seconds: 10),
          ),
        );
      },
    );
  } else {
    return const MaterialApp(home: CircularProgressIndicator());
  }
}
