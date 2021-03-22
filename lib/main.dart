//implementation imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// data repository imports
import 'package:smartrider/data/repository/authentication_repository.dart';
import 'package:smartrider/data/repository/bus_repository.dart';
import 'package:smartrider/data/repository/saferide_repository.dart';
import 'package:smartrider/data/repository/shuttle_repository.dart';

// page imports
import 'package:smartrider/pages/welcome.dart';
import 'package:smartrider/pages/home.dart';
// import 'package:smartrider/pages/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    SmartRider(), // Wrap your app
  );
}

class SmartRider extends StatelessWidget {
  final AuthRepository authRepo = AuthRepository();
  final BusRepository busRepo = BusRepository();
  final ShuttleRepository shuttleRepo = ShuttleRepository();
  final SaferideRepository saferideRepo = SaferideRepository();
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PrefsBloc>(
          create: (context) {
            PrefsBloc pBloc = PrefsBloc();
            pBloc.add(LoadPrefsEvent());
            return pBloc;
          },
        ),
        BlocProvider<AuthenticationBloc>(create: (context) {
          AuthenticationBloc aBloc =
              AuthenticationBloc(authRepository: authRepo);
          aBloc.add(AuthenticationStarted());
          return aBloc;
        }),
        BlocProvider<SaferideBloc>(
          create: (context) => SaferideBloc(
            saferideRepo: saferideRepo,
            authRepo: authRepo
          ),
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
            // panelController: _panelController,
            // tabController: _tabController
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'smartrider Prototype',
        // locale: DevicePreview.locale(context), // Add the locale here
        // builder: DevicePreview.appBuilder,
        theme: state.theme,
        home: WelcomeScreen(homePage: HomePage()));
  } else {
    return MaterialApp(home: CircularProgressIndicator());
  }
}
