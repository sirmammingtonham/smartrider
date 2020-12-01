import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';

/// static gtfs models
import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip.dart';
import '../models/bus/bus_timetable.dart';

/// realtime gtfs models
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';

/// A provider for Bus data.
///
/// Implemented as a collection of functions that utilizes the cloud
/// firestore to retrieve bus gtfs data.
/// Each member function queries the firestore and returns
/// a map containing route names and their relevent bus data object.
class BusProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const defaultRoutes = [
    '87-185',
    '286-185',
    '289-185',
    '288-185', // cdta express shuttle
  ];

  /// Fetchs data from the JSON API and returns a decoded JSON.
  Future<QuerySnapshot> fetch(String collection,
      {String idField = 'route_id', List routes = defaultRoutes}) async {
    return firestore
        .collection(collection)
        .where(idField, whereIn: routes)
        .get();
  }

  // /// The status of the most recent [fetch] call.
  // bool get getIsConnected => isConnected;

  /// Returns a [Map] of <[BusRoute.routeShortName], [BusRoute]>  pairs.
  Future<Map<String, BusRoute>> getRoutes() async {
    QuerySnapshot response =
        await fetch('routes', idField: 'route_id', routes: defaultRoutes);

    Map<String, BusRoute> routeMap = Map.fromIterable(response.docs,
        key: (doc) => doc['route_id'],
        value: (doc) => BusRoute.fromJson(doc.data()));
    return routeMap;
  }

  /// Returns a [Map] of [BusShape] objects.
  Future<Map<String, BusShape>> getPolylines() async {
    QuerySnapshot response =
        await fetch('polylines', idField: 'route_id', routes: defaultRoutes);

    Map<String, BusShape> shapesMap = Map.fromIterable(response.docs,
        key: (doc) => doc['route_id'],
        value: (doc) => BusShape.fromJson(json.decode(doc['geoJSON'])));
    return shapesMap;
  }

  /// Returns a [Map] of [BusStop] objects.
  Future<Map<String, BusStop>> getStops() async {
    QuerySnapshot response = await firestore
        .collection('stops')
        .where('route_ids', arrayContainsAny: defaultRoutes)
        .get();

    Map<String, BusStop> stopsMap = Map.fromIterable(response.docs,
        key: (doc) => doc['stop_id'],
        value: (doc) => BusStop.fromJson(doc.data()));

    return stopsMap;
  }

  /// Returns a [List] of [BusTrip] objects.
  Future<Map<String, BusTrip>> getTrips() async {
    QuerySnapshot response =
        await fetch('trips', idField: 'route_id', routes: defaultRoutes);

    Map<String, BusTrip> tripList = Map.fromIterable(response.docs,
        key: (doc) => doc['route_id'],
        value: (doc) => BusTrip.fromJson(doc.data()));

    return tripList;
  }

  /// Returns a [List] of [BusTripUpdate] objects.
  Future<List<BusTripUpdate>> getTripUpdates() async {
    http.Response response =
        await http.get('http://64.128.172.149:8080/gtfsrealtime/TripUpdates');

    var routes = ["87", "286", "289", "288"];
    List<BusTripUpdate> tripUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusTripUpdate.fromPBEntity(entity))
            // .where((update) =>
                // trips.contains(update.id)) // check if trip id is active
            .toList()
        : [];
    return tripUpdatesList;
  }

  Future<Map<String, Map<String, String>>> getNewTripUpdates() async {
    http.Response response =
        await http.get('http://64.128.172.149:8080/gtfsrealtime/TripUpdates');

    var routes = ["87", "286", "289", "288"];
    List<BusTripUpdate> tripUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusTripUpdate.fromPBEntity(entity))
            .where((update) => routes.contains(update.routeId))
            .toList()
        : [];
    Map<String, Map<String, String>> m = {};
    tripUpdatesList.forEach((element) {
      Map<String, String> m1 = {};
      element.stopTimeUpdate.forEach((stoptime) {
        m1[stoptime.stopId] = DateFormat('HH:mm').format(
            DateTime.fromMillisecondsSinceEpoch(
                stoptime.arrivalTime.toInt() * 1000));
      });
      m[element.routeId] = m1;
    });

    return m;
  }

  /// Returns a [List] of [BusVehicleUpdate] objects.
  Future<List<BusVehicleUpdate>> getVehicleUpdates() async {
    http.Response response = await http
        .get('http://64.128.172.149:8080/gtfsrealtime/VehiclePositions');

    List<BusVehicleUpdate> vehicleUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusVehicleUpdate.fromPBEntity(entity))
            .where((update) => defaultRoutes.contains(update.routeId))
            .toList()
        : [];
    return vehicleUpdatesList;
  }

  /// Returns a [Map] of <route_name,[BusTimetable]>
  Future<Map<String, BusTimetable>> getBusTimetable() async {
    String day = DateFormat('EEEE').format(DateTime.now());
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    if (weekdays.contains(day)) {
      day = "weekday";
    }
    QuerySnapshot response = await firestore
        .collection('timetables')
        .where('route_id', whereIn: defaultRoutes)
        .get();

    Map<String, BusTimetable> timetableMap = {};
    // since timetables are nested in subcollection we have to retrieve those
    for (QueryDocumentSnapshot route in response.docs) {
      var table =
          await route.reference.collection(day.toLowerCase()).doc('0').get();

      timetableMap[route.data()['route_id']] =
          BusTimetable.fromJson(table.data());
    }

    return timetableMap;
  }

  Future<void> test() async {
    Stopwatch stopwatch = new Stopwatch()..start();
    // await getPolylines();
    // await getStops();
    // await getVehicleUpdates();
    print('executed in ${stopwatch.elapsed}');
  }

  // Future<Map<String, List<List<String>>>> getBusTimetableFlat() async {
  //   var timetable = await getBusTimetable();
  //   Map<String, List<List<String>>> retmap = {};

  //   timetable.forEach((route, table) {

  //   });
  // }
}
