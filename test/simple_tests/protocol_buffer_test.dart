// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smartrider/data/providers/bus_provider.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';
import 'package:smartrider/data/models/bus/bus_trip_update.dart';
// import '../../lib/data/models/bus/gtfs-realtime.pb.dart';

const defaultRoutesShort = [
  '87',
  '286',
  '289',
];

void main() async {
  /// test for getDatetime()
  print('starting');
  await test2();
}

void test2() async {
  print(DateTime.now().hour * 3600 + DateTime.now().minute * 60 + DateTime.now().second);
}

void test1(BusProvider b) async {
  http.Response response =
      await http.get('http://64.128.172.149:8080/gtfsrealtime/TripUpdates');

  var routes = ["87", "286", "289"];
  List<BusTripUpdate> tripUpdatesList = response != null
      ? FeedMessage.fromBuffer(response.bodyBytes)
          .entity
          .map((entity) => BusTripUpdate.fromPBEntity(entity))
          // .where((update) =>
          // defaultRoutes.contains(update.routeId)) // check if trip id is active
          .toList()
      : [];
  tripUpdatesList
      .sort((first, second) => first.routeId.compareTo(second.routeId));
  tripUpdatesList.forEach((element) {
    print(element.routeId);
  });
  print(tripUpdatesList.map((e) => e.routeId));
}
