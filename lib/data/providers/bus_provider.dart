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
    '286-184',
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
        key: (doc) => doc['route_short_name'],
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
  Future<Map<String, List<BusStop>>> getStops() async {
    QuerySnapshot response = await firestore
        .collection('stops')
        .where('route_ids', arrayContainsAny: defaultRoutes)
        .get();

    List<BusStop> stopsList = response.docs
        .map<BusStop>((doc) => BusStop.fromJson(doc.data()))
        .toList();

    Map<String, List<BusStop>> stopsMap = {};

    for (String route in defaultRoutes) {
      stopsMap[route] =
          stopsList.where((stop) => stop.routeIds.contains(route)).toList();
    }

    return stopsMap;
  }

  // /// Returns a [Map] of [BusStop] objects.
  // Future<Map<String, List<BusStop>>> getStops() async {
  //   QuerySnapshot response = await firestore
  //       .collection('stops')
  //       .where('route_ids', arrayContainsAny: defaultRoutes)
  //       .get();

  //   Map<String, List<BusStop>> stopsMap = {};
  //   for (QueryDocumentSnapshot doc in response.docs) {
  //     for (String routeId in doc['route_ids']) {
  //       if (!stopsMap.containsKey(routeId)) {
  //         stopsMap[routeId] = [BusStop.fromJson(doc.data())];
  //       } else {
  //         stopsMap[routeId].add(BusStop.fromJson(doc.data()));
  //       }
  //     }
  //   }
  //   return stopsMap;
  // }

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

    List<BusTripUpdate> tripUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusTripUpdate.fromPBEntity(entity))
            .where((update) => defaultRoutes.contains(update.routeId))
            .toList()
        : [];
    return tripUpdatesList;
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
  Future<Map<String, List<BusTimetable>>> getBusTimetable() async {
    String day = DateFormat('EEEE').format(DateTime.now());
    QuerySnapshot response = await firestore
        .collection('timetables')
        .where('route_id', whereIn: defaultRoutes)
        .get();

    Map<String, List<BusTimetable>> retmap = {};
    // since timetables are nested in subcollection we have to retrieve those
    for (QueryDocumentSnapshot route in response.docs) {
      List<BusTimetable> currentTable = [];
      var table = await route.reference
          .collection(day.toLowerCase())
          .orderBy('stop_sequence') // order them by the stop sequence
          .get();
      for (var stop in table.docs) {
        currentTable.add(BusTimetable.fromJson(stop.data()));
      }
      retmap[route['route_id']] = currentTable;
    }

    return retmap;
  }

  // Future<Map<String, List<List<String>>>> getBusTimetableFlat() async {
  //   var timetable = await getBusTimetable();
  //   Map<String, List<List<String>>> retmap = {};

  //   timetable.forEach((route, table) {

  //   });
  // }
}
