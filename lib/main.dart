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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartRider Prototype',
      theme: themeNotifier.getTheme(),
      home: MultiBlocProvider(
              providers:[ BlocProvider<PrefsBloc>(
          create: (context) => PrefsBloc(), 
     ),
     BlocProvider<AuthenticationBloc>(
       create: (context) => AuthenticationBloc(userRepository: userRepository),
       )
              ],
            child: HomePage(),
      )
    );
  }
}

class Test extends StatelessWidget {
  void _test() async {
    ShuttleRepository repo = ShuttleRepository();
    var ye = await repo.getRoutes;
    int i = 0;
    ye.forEach((element) {
      print('${i++}');
      print(element);
    });
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
          _test();
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),

    );
  }
}
