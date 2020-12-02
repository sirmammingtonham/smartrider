// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smartrider/data/models/bus/bus_vehicle_update.dart';
import 'package:smartrider/data/providers/bus_provider.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';
import 'package:smartrider/data/models/bus/bus_trip_update.dart';
// import '../../lib/data/models/bus/gtfs-realtime.pb.dart';

const defaultRoutes = [
  '87-185',
  '286-185',
  '289-185',
  '288-185', // cdta express shuttle
];

void main() async {
  /// test for getDatetime()
  print('starting');
  await test3();
}

Future test3() async {
  http.Response response = await http
      .get('http://64.128.172.149:8080/gtfsrealtime/VehiclePositions');

  // var routes = ["87", "286", "289"];
  // List<BusVehicleUpdate> vehicleUpdatesList = response != null
  //     ? FeedMessage.fromBuffer(response.bodyBytes)
  //         .entity
  //         .map((entity) => BusVehicleUpdate.fromPBEntity(entity))
  //         .where((update) => defaultRoutes
  //             .map((str) => str.split('-')[0])
  //             .contains(update.routeId))
  //         .toList()
  //     : [];
  // print(vehicleUpdatesList.map((update) => update.currentStatus));

  List<FeedEntity> vehicleUpdatesList = response != null
      ? FeedMessage.fromBuffer(response.bodyBytes)
          .entity
          .map((entity) => entity)
          .toList()
      : [];
<<<<<<< Updated upstream
  for (FeedEntity ent in vehicleUpdatesList) {
    print(ent.toProto3Json());
  }
=======
  print(vehicleUpdatesList.map((e) => print(e.bearing)));
>>>>>>> Stashed changes
}

// Future test2() async {
//   print(DateTime.now().hour * 3600 +
//       DateTime.now().minute * 60 +
//       DateTime.now().second);
// }

// Future<void> test1() async {
//   http.Response response =
//       await http.get('http://64.128.172.149:8080/gtfsrealtime/TripUpdates');

//   // var routes = ["87", "286", "289"];
//   List<BusTripUpdate> tripUpdatesList = response != null
//       ? FeedMessage.fromBuffer(response.bodyBytes)
//           .entity
//           .map((entity) => BusTripUpdate.fromPBEntity(entity))
//           // .where((update) =>
//           // defaultRoutes.contains(update.routeId)) // check if trip id is active
//           .toList()
//       : [];
//   tripUpdatesList
//       .sort((first, second) => first.routeId.compareTo(second.routeId));
//   tripUpdatesList.forEach((element) {
//     print(element.routeId);
//   });
//   print(tripUpdatesList.map((e) => e.routeId));
// }
