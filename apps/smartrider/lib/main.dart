//implementation imports

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';

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
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // String host = defaultTargetPlatform == TargetPlatform.android
  //     ? '10.0.2.2:8080'
  //     : 'localhost:8080';

  // FirebaseFirestore.instance.settings = Settings(host: host, sslEnabled: false);

  runApp(
    SmartRider(
        authRepo: AuthRepository.create(),
        busRepo: await BusRepository.create(),
        shuttleRepo: ShuttleRepository.create(),
        saferideRepo: SaferideRepository.create()),
  );
}

class SmartRider extends StatelessWidget {
  final AuthRepository authRepo;
  final BusRepository busRepo;
  final ShuttleRepository shuttleRepo;
  final SaferideRepository saferideRepo;

  SmartRider({
    required this.authRepo,
    required this.busRepo,
    required this.shuttleRepo,
    required this.saferideRepo,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PrefsBloc>(
          create: (context) => PrefsBloc()..add(LoadPrefsEvent()),
        ),
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(authRepository: authRepo)
              ..add(AuthenticationStarted())),
        BlocProvider<SaferideBloc>(
          create: (context) => SaferideBloc(
              prefsBloc: BlocProvider.of<PrefsBloc>(context),
              saferideRepo: saferideRepo,
              authRepo: authRepo),
        ),
        BlocProvider<MapBloc>(
            create: (context) => MapBloc(
                saferideBloc: BlocProvider.of<SaferideBloc>(context),
                prefsBloc: BlocProvider.of<PrefsBloc>(context),
                busRepo: busRepo,
                shuttleRepo: shuttleRepo,
                saferideRepo: saferideRepo)),
        BlocProvider<ScheduleBloc>(
          create: (context) => ScheduleBloc(
            mapBloc: BlocProvider.of<MapBloc>(context),
            busRepo: busRepo,
          ),
        ),
      ],
      child: BlocBuilder<PrefsBloc, PrefsState>(
          builder: (context, state) => _buildWithTheme(context, state)),
    );
  }
}

Widget _buildWithTheme(BuildContext context, PrefsState state) {
  if (state is PrefsLoadedState) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'smartrider Prototype',
          theme: state.theme,
          home: ShowCaseWidget(
            builder: Builder(
                builder: (context) => state.firstLaunch!
                    ? OnboardingScreen()
                    : WelcomeScreen(homePage: HomePage())),
            autoPlay: true,
            autoPlayDelay: Duration(seconds: 10),
          ),
        );
      },
    );
  } else {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(home: CircularProgressIndicator()));
  }
}
