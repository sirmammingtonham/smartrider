//implementation imports
import 'package:flutter/material.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';
import 'package:smartrider/data/models/time/time.dart';
// page imports
import 'package:smartrider/pages/welcome.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/pages/onboarding.dart';

import 'package:smartrider/data/providers/bus_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
  AndroidInitializationSettings('app_notf_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      });
  runApp(SmartRider());
}
  
class SmartRider extends StatelessWidget {
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
              AuthenticationBloc(authRepository: AuthRepository());
          aBloc.add(AuthenticationStarted());
          return aBloc;
        }),
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
        theme: state.theme,
        home: OnboardingScreen());
  } else {
    return MaterialApp(home: CircularProgressIndicator());
  }
}
