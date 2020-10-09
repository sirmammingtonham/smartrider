// import 'package:flutter/material.dart';

// // bloc imports
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
// import 'package:smartrider/data/repository/authentication_repository.dart';

// // page imports
// import 'package:smartrider/pages/welcome.dart';
// import 'package:smartrider/pages/home.dart';

// void main() => runApp(SmartRider());

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
//         })
//       ],
//       child: BlocBuilder<PrefsBloc, PrefsState>(
//         builder: (context, state) => _buildWithTheme(context, state)),
//     );
//   }
// }

// Widget _buildWithTheme(BuildContext context, PrefsState state) {
//   if (state is PrefsLoadedState) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'SmartRider Prototype',
//         theme: state.getTheme,
//         home: WelcomeScreen(homePage: HomePage()));
//   } else {
//     return MaterialApp(home: CircularProgressIndicator());
//   }
// }
import 'package:flutter/material.dart';
import 'package:smartrider/data/providers/bus_provider.dart';
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    final _busProvider = BusProvider();
    _busProvider.setup();
    print('running fetch:');
    String temp = await _busProvider.fetch("agency");

    print('running fromString:');
    // BusAgency agency = BusAgency.fromString(temp);

    print('running printData()');
    // print(agency);

    print("Finished running");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}