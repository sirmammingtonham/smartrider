//implementation imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:smartrider/data/providers/bus_provider.dart';
import 'package:smartrider/data/providers/bus_provider_deprecated.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BusProvider prov = BusProvider();
  var a = await prov.getNewTripUpdates();
  a.forEach((key, value){
    print("key:"+key);
    print("value:");
    print(value);
  });
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  var b = await prov.getNewBusTimeTable();
  b.forEach((key, value) {
    print("key:"+key);
    print("value:");
    print(value);
  });
  print(b.length);
  //runApp(TestApp());
}

// class TestApp extends StatelessWidget {
//   final provider = BusProvider();

  Future<void> test() async {
    // print(await provider.getRoutes());
    // print(await provider.getPolylines());
    // print(await provider.getStops());
    // print(await provider.getTrips());
    // print(await provider.getBusTimetable());

    // print(await provider.getTripUpdates());
    // print(await provider.getVehicleUpdates());
    // var bruh = await provider.getBusTimetable();
    // print(bruh['87-185'].timetableDisplay);
    // return;
  }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'test',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('test'),
//         ),
//         body: Center(
//           child: Text('Hello World'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Stopwatch stopwatch = new Stopwatch()..start();
//             test().then((_) {
//               print('executed in ${stopwatch.elapsed}');
//             });
//           },
//           child: Icon(Icons.ac_unit),
//         ),
//       ),
//     );
//   }
// }
