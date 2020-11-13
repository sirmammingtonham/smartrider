import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';

import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
//import '../models/bus/bus_stop_time.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';
import '../models/bus/bus_trip.dart';
import '../models/bus/bus_timetable.dart';

/// A provider for Bus data.
///
/// Implemented as a collection of functions that utilizes
/// a REST API to retrieve json files of bus data.
/// Each member function decodes a json file and returns
/// a dart iterable containing the relevent bus data object.
class BusProvider {
  final defaultRoutes = ['87-185', '286-185', '289-185', '286-184',];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Fetchs data from the JSON API and returns a decoded JSON.
  Future<QuerySnapshot> fetch(String collection,
      {String idField, List routes}) async {
    return firestore
        .collection(collection)
        .where(idField, whereIn: routes)
        .get();
  }

  // /// The status of the most recent [fetch] call.
  // bool get getIsConnected => isConnected;

  /// Returns a [Map] of <[BusRoute.routeShortName], [BusRoute]>  pairs.
  Future<Map<String, BusRoute>> getRoutes() async {
    var response =
        await fetch('routes', idField: 'route_id', routes: defaultRoutes);

    Map<String, BusRoute> routeMap = response != null
        ? Map.fromIterable(response.docs,
            key: (doc) => doc['route_short_name'],
            value: (doc) => BusRoute.fromJson(doc))
        : {};
    return routeMap;
  }

  /// Returns a [Map] of [BusShape] objects.
  Future<Map<String, BusShape>> getPolylines() async {
    var response =
        await fetch('polylines', idField: 'route_id', routes: defaultRoutes);

    Map<String, BusShape> shapesMap = response != null
        ? Map.fromIterable(response.docs,
            key: (doc) => doc['route_id'],
            value: (doc) => BusShape.fromJson(json.decode(doc['geoJSON'])))
        : {};
    return shapesMap;
  }

  /// Returns a [List] of [BusStop] objects.
  // Future<List<BusStop>> getStops() async {
  //   var response = await fetch('busStops',
  //       query: {'query': '{"route_id": ["87-184","286-184","289-184"]}'});

  //   List<BusStop> stopsList = response != null
  //       ? json
  //           .decode(response.body)
  //           .map<BusStop>((json) => BusStop.fromJson(json))
  //           .toList()
  //       : [];
  //   return stopsList;
  // }

  /// Returns a [List] of [BusTripUpdate] objects.
  Future<List<BusTripUpdate>> getTripUpdates() async {
    var response =
        await http.get('http://64.128.172.149:8080/gtfsrealtime/TripUpdates');

    Set<String> routeIds = {'87', '286', '289'};

    List<BusTripUpdate> tripUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusTripUpdate.fromPBEntity(entity))
            .where((update) => routeIds.contains(update.routeId))
            .toList()
        : [];
    return tripUpdatesList;
  }

  // /// Returns a [List] of [BusTrip] objects.
  // Future<List<BusTrip>> getTrip() async {
  //   var response = await fetch('busTrips', query: {
  //     'query': '{"route_id": ["87-184","286-184","289-184"]}'
  //   }); //trips for 87,286 and 289

  //   List<BusTrip> tripList = response != null
  //       ? json
  //           .decode(response.body)
  //           .map<BusTrip>((json) => BusTrip.fromJson(json))
  //           .toList()
  //       : [];

  //   return tripList;
  // }

  /// Returns a [List] of [BusVehicleUpdate] objects.
  Future<List<BusVehicleUpdate>> getVehicleUpdates() async {
    var response = await http
        .get('http://64.128.172.149:8080/gtfsrealtime/VehiclePositions');

    Set<String> routeIds = {'87', '286', '289'};

    List<BusVehicleUpdate> vehicleUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusVehicleUpdate.fromPBEntity(entity))
            .where((update) => routeIds.contains(update.routeId))
            .toList()
        : [];
    return vehicleUpdatesList;
  }

  ///Returns a [Map] of <[BusStop],[BusTimeTable]>
  Future<Map<String, List<BusTimeTable>>> getBusTimeTable() async {
    var test = await firestore
        .collection('timetables')
        .where('route_id', whereIn: defaultRoutes)
        .get();
    test.docs.forEach((element) {
      print(element['route_id']);
    });
    // var response = await fetch("busTimetable");
    Map<String, List<BusTimeTable>> retmap = {};
    // Map<String, dynamic> tablemap = response != null
    //     ? (json.decode(response.body) as Map<String, dynamic>)
    //     : [];
    // tablemap.forEach((key, value) {
    //   List<dynamic> b = value["stops"];
    //   List<BusTimeTable> bl =
    //       b.map((element) => BusTimeTable.fromJson(element)).toList();
    //   retmap[key] = bl;
    // });
    return retmap;
  }

  /// Creates a JSON file [fileName] and stores it in a local directory.
  ///
  /// Does nothing if [fetch] cannot establish a connection
  Future createJSONFile(String fileName, http.Response response) async {
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      await file.writeAsString(response.body);
    }
  }
}
