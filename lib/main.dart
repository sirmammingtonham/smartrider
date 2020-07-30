import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/pages/login.dart';
import 'package:smartrider/pages/signup.dart';
import 'package:smartrider/services/user_repository.dart';
import 'package:smartrider/util/theme.dart';
import 'package:smartrider/util/theme_notifier.dart';

import 'package:smartrider/data/models/shuttle/shuttle_route.dart';
import 'package:smartrider/data/repository/shuttle_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

void main() => runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(lightTheme),
        child: SmartRider(),
      ),
    );

class SmartRider extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final Authsystem userRepository = Authsystem();
    return MultiBlocProvider(
        providers: [
          BlocProvider<PrefsBloc>(
            create: (context) => PrefsBloc(),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(userRepository: userRepository),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SmartRider Prototype',
            theme: themeNotifier.getTheme(),
            home: HomePage(),
            // home: Loginpage()
            ));
  }
}

class Test extends StatelessWidget {
  // void _test() async {
  //   ShuttleRepository repo = ShuttleRepository();
  //   var ye = await repo.getRoutes;
  //   int i = 0;
  //   ye.forEach((element) {
  //     print('${i++}');
  //     print(element);
  //   });
  // }

  void _test2() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      Response response = await Dio().download('https://www.cdta.org/schedules/google_transit.zip', '${directory.path}/test.zip');
      print("xxx");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Button'),
      ),
      body: Center(child: const Text('Press the button below!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _test2();
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }
}
