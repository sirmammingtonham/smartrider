//implementation imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';

// page imports
import 'package:smartrider/pages/welcome.dart';
import 'package:smartrider/pages/home.dart';
// import 'package:smartrider/pages/onboarding.dart';

import 'package:smartrider/data/providers/bus_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TestApp());
  // runApp(SmartRider());
}

class TestApp extends StatelessWidget {
  final provider = BusProvider();

  test() {
    provider.getBusTimeTable().then((res) {
      print(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            test();
          },
          child: Icon(Icons.ac_unit),
        ),
      ),
    );
  }
}

// class SmartRider extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<PrefsBloc>(
//           create: (context) {
//             PrefsBloc pBloc = PrefsBloc();
//             pBloc.add(LoadPrefsEvent());
//             return pBloc;
//           },
//         ),
//         BlocProvider<AuthenticationBloc>(create: (context) {
//           AuthenticationBloc aBloc =
//               AuthenticationBloc(authRepository: AuthRepository());
//           aBloc.add(AuthenticationStarted());
//           return aBloc;
//         }),
//       ],
//       child: BlocBuilder<PrefsBloc, PrefsState>(
//           builder: (context, state) => _buildWithTheme(context, state)),
//     );
//   }
// }

// Widget _buildWithTheme(BuildContext context, PrefsState state) {
//   if (state is PrefsLoadedState) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'smartrider Prototype',
//         theme: state.theme,
//         home: WelcomeScreen(homePage: HomePage()));
//   } else {
//     return MaterialApp(home: CircularProgressIndicator());
//   }
// }
