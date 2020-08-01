import 'package:flutter/material.dart';
import 'package:smartrider/pages/home.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';

void main() => runApp(SmartRider());

class SmartRider extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return MultiBlocProvider(
        providers: [
          BlocProvider<PrefsBloc>(
            create: (context) {
              PrefsBloc pBloc = PrefsBloc();
              pBloc.add(LoadPrefsEvent());
              return pBloc;
            },
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(authRepository: authRepository),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SmartRider Prototype',
          home: BlocBuilder<PrefsBloc, PrefsState>(
              builder: (context, state) => _buildWithTheme(context, state)),
          // home: Loginpage()
        ));
  }
}

Widget _buildWithTheme(BuildContext context, PrefsState state) {
  if (state is PrefsLoadedState) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartRider Prototype',
      theme: state.getTheme,
      home: HomePage(),
      // home: Loginpage()
    );
  } else {
    return MaterialApp(home: CircularProgressIndicator());
  }
}

// class Test extends StatelessWidget {
//   // void _test() async {
//   //   ShuttleRepository repo = ShuttleRepository();
//   //   var ye = await repo.getRoutes;
//   //   int i = 0;
//   //   ye.forEach((element) {
//   //     print('${i++}');
//   //     print(element);
//   //   });
//   // }

//   void _test2() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     final _busProvider = BusProvider();
//     _busProvider.fetch();
//     print("Finished running");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Floating Action Button'),
//       ),
//       body: Center(child: const Text('Press the button below!')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _test2();
//         },
//         child: Icon(Icons.navigation),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }
