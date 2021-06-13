import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared/models/bus/pb/gtfs-realtime.pb.dart';

/// static gtfs models
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_stop.dart';
import 'package:shared/models/bus/bus_trip.dart';
import 'package:shared/models/bus/bus_timetable.dart';

/// realtime gtfs models
import 'package:shared/models/bus/bus_trip_update.dart';
import 'package:shared/models/bus/bus_vehicle_update.dart';

/// A provider for Bus data.
///
/// Implemented as a collection of functions that utilizes the cloud
/// firestore to retrieve bus gtfs data.
/// Each member function queries the firestore and returns
/// a map containing route names and their relevent bus data object.
class BusProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String?, String?>? routeMapping;

  List<String?>? _defaultRoutes;
  Future? _providerHasLoaded;

  static const shortRouteIds = [
    '87',
    '286',
    '289',
    '288', // cdta express shuttle
  ];

  BusProvider() {
    _providerHasLoaded = _init();
  }

  // we need to await in the constructor, so doing it like this allows for the factory to wait for initialization
  Future<void> _init() async {
    var routes = await _firestore
        .collection('routes')
        .where('route_short_name', whereIn: shortRouteIds)
        .get();

    routeMapping = Map.fromIterable(routes.docs,
        key: (doc) => doc['route_id'], value: (doc) => doc['route_short_name']);

    _defaultRoutes = routeMapping!.keys.toList();
  }

  Future? get waitForLoad => _providerHasLoaded;

  /// Fetchs data from the JSON API and returns a decoded JSON.
  Future<QuerySnapshot> fetch(String collection,
      {List? routes, String idField = 'route_id'}) async {
    return _firestore
        .collection(collection)
        .where(idField, whereIn: _defaultRoutes)
        .get();
  }

  // /// The status of the most recent [fetch] call.
  // bool get getIsConnected => isConnected;

  /// Returns a [Map] of <[BusRoute.routeShortName], [BusRoute]>  pairs.
  Future<Map<String?, BusRoute>> getRoutes() async {
    QuerySnapshot response =
        await fetch('routes', idField: 'route_id', routes: _defaultRoutes);

    Map<String?, BusRoute> routeMap = Map.fromIterable(response.docs,
        key: (doc) => doc['route_short_name'],
        value: (doc) => BusRoute.fromJson(doc.data()));

    return routeMap;
  }

  /// Returns a [Map] of [BusShape] objects.
  Future<Map<String?, BusShape>> getPolylines() async {
    QuerySnapshot response =
        await fetch('polylines', idField: 'route_id', routes: _defaultRoutes);

    Map<String?, BusShape> shapesMap = Map.fromIterable(response.docs,
        key: (doc) => routeMapping![doc['route_id']],
        value: (doc) => BusShape.fromJson(json.decode(doc['geoJSON'])));
    return shapesMap;
  }

  /// Returns a [Map] of [BusStop] objects.
  Future<Map<String?, BusStop>> getStops() async {
    QuerySnapshot response = await _firestore
        .collection('stops')
        .where('route_ids', arrayContainsAny: _defaultRoutes)
        .get();

    Map<String?, BusStop> stopsMap = Map.fromIterable(response.docs,
        key: (doc) => doc['stop_id'],
        value: (doc) => BusStop.fromJson(doc.data()));

    return stopsMap;
  }

  /// Returns a [List] of [BusTrip] objects.
  Future<Map<String?, BusTrip>> getTrips() async {
    QuerySnapshot response =
        await fetch('trips', idField: 'route_id', routes: _defaultRoutes);

    Map<String?, BusTrip> tripList = Map.fromIterable(response.docs,
        key: (doc) => routeMapping![doc['route_id']],
        value: (doc) => BusTrip.fromJson(doc.data()));

    return tripList;
  }

  /// Returns a [List] of [BusTripUpdate] objects.
  Future<List<BusTripUpdate>> getTripUpdates() async {
    http.Response response = await http
        .get(Uri.parse('http://64.128.172.149:8080/gtfsrealtime/TripUpdates'));

    // var routes = ["87", "286", "289", "288"];
    List<BusTripUpdate> tripUpdatesList =
        FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusTripUpdate.fromPBEntity(entity))
            // .where((update) =>
            // trips.contains(update.id)) // check if trip id is active
            .toList();
    return tripUpdatesList;
  }

  /// Returns a [List] of [BusVehicleUpdate] objects.
  Future<List<BusVehicleUpdate>> getVehicleUpdates() async {
    http.Response response = await http.get(
        Uri.parse('http://64.128.172.149:8080/gtfsrealtime/VehiclePositions'));

    List<BusVehicleUpdate> vehicleUpdatesList =
        FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusVehicleUpdate.fromPBEntity(entity))
            .where((update) => _defaultRoutes!
                .map((str) => str!.split('-')[0])
                .contains(update.routeId))
            .toList();
    return vehicleUpdatesList;
  }

  /// Returns a [Map] of <route_name,[BusTimetable]>
  Future<Map<String?, BusTimetable>> getBusTimetable() async {
    String day = DateFormat('EEEE').format(DateTime.now());
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    if (weekdays.contains(day)) {
      day = "weekday";
    }
    QuerySnapshot response = await _firestore
        .collection('timetables')
        .where('route_id', whereIn: _defaultRoutes)
        .get();

    Map<String?, BusTimetable> timetableMap = {};
    // since timetables are nested in subcollection we have to retrieve those
    for (QueryDocumentSnapshot route in response.docs) {
      var table =
          await route.reference.collection(day.toLowerCase()).doc('0').get();

      if (table.data() != null) {
        var entry = BusTimetable.fromJson(table.data()!);
        // check if today is in exclusive dates
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat.yMMMMd('en_US');
        final String today = formatter.format(now);
        if (entry.excludeDates!.contains(today)) {
          // special case: today is excluded
          // search through other possible days for inclusive dates that contains today
          var possibleDays = ['weekday', 'saturday', 'sunday'];
          for (String d in possibleDays) {
            if (d != day) {
              table = await route.reference
                  .collection(d.toLowerCase())
                  .doc('0')
                  .get();
              if (table.data() != null) {
                var temp = BusTimetable.fromJson(table.data()!);
                if (temp.includeDates!.contains(today) &&
                    !temp.excludeDates!.contains(today)) {
                  // check for exclusive just in case
                  // replace today's schedule with another day's (e.g: today is a weekday, but uses sunday schedule)
                  timetableMap[routeMapping![route.get('route_id')]] = temp;
                  break;
                }
              }
            }
          }
        } else {
          // normal case: today not in exclude dates
          timetableMap[routeMapping![route.get('route_id')]] = entry;
        }
      }
    }

    return timetableMap;
  }
}
