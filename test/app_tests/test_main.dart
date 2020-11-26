//implementation imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:smartrider/data/providers/bus_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  final provider = BusProvider();

  Future<void> test() async {
    // print(await provider.getRoutes());
    // print(await provider.getPolylines());
    // print(await provider.getStops());
    // print(await provider.getTrips());
    // print(await provider.getBusTimetable());

    // print(await provider.getTripUpdates());
    // print(await provider.getVehicleUpdates());
    var bruh = await provider.getBusTimetable();
    print(bruh['87-185'].stops);
    return;
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
            Stopwatch stopwatch = new Stopwatch()..start();
            test().then((_) {
              print('executed in ${stopwatch.elapsed}');
            });
          },
          child: Icon(Icons.ac_unit),
        ),
      ),
    );
  }
}
