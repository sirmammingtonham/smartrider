// //implementation imports import 'dart:math';

// import 'package:flutter/material.dart'; import
// 'package:firebase_core/firebase_core.dart'; import
// 'package:shared/models/bus/bus_route.dart'; import
// 'package:shared/models/bus/bus_vehicle_update.dart';

// import 'package:smartrider/data/providers/bus_provider.dart';

// void main() async {WidgetsFlutterBinding.ensureInitialized(); await
//   Firebase.initializeApp(); runApp(TestApp());
// }

// class TestApp extends StatelessWidget {final provider = BusProvider();

//   Future<void> testRouteId() async {var routes = await provider.getRoutes();
//     var vehicles = await provider.getVehicleUpdates();

//     BusVehicleUpdate update = vehicles[0]; BusStopSimplified stop =
//     routes[update.routeId! + '-185']!
//     .forwardStops[update.currentStopSequence!];

//     double lat1 = update.latitude!; double lat2 = stop.stopLat!; double lon1
//     = update.longitude!; double lon2 = stop.stopLon!;

//     double heading = atan2(sin(lon2 - lon1) * cos(lat2), cos(lat1) *
//             sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1)) % 2 * pi;

//     print(heading); return;
//   }

//   Future<void> test() async {var timetable = await
//     provider.getBusTimetable(); for (int i = 0; i <
//     timetable['87-185']!.numColumns; i++)
//     {print(timetable['87-185']!.getClosestTimes(i));
//     }
//     return;
//   }

//   Future<void> test0() async {var routes = await provider.getRoutes(); for
//     (var stop in routes['87-185']!.forwardStops) {print(stop.toJson());
//     }
//     return;
//   }

//   @override Widget build(BuildContext context) {return MaterialApp(title:
//   'test', home: Scaffold(appBar: AppBar(title: const Text('test'),
//         ),
//         body: const Center(
//           child: Text('Hello World'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Stopwatch stopwatch = new Stopwatch()..start();
//             testRouteId().then((_) {
//               print('executed in ${stopwatch.elapsed}');
//             });
//           },
//           child: const Icon(Icons.ac_unit),
//         ),
//       ),
//     );
//   }
// }
