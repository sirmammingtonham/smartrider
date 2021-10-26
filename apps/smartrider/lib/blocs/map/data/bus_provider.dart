import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared/models/bus/bus_realtime_update.dart';

/// static gtfs models
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_stop.dart';
import 'package:shared/models/bus/bus_timetable.dart';
import 'package:shared/models/bus/bus_trip.dart';
import 'package:smartrider/blocs/map/data/http_util.dart';

/// A provider for Bus data.
///
/// Implemented as a collection of functions that utilizes the cloud
/// firestore to retrieve bus gtfs data.
/// Each member function queries the firestore and returns
/// a map containing route names and their relevent bus data object.
class BusProvider {
  BusProvider() {
    _providerHasLoaded = _init();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  late final Map<String, String> routeMapping;
  late final Future _providerHasLoaded;
  late final List<String> _defaultRoutes;

  static const shortRouteIds = [
    '87',
    '286',
    '289',
    '288', // cdta express shuttle
  ];

  List<String> getShortRoutes() {
    return shortRouteIds;
  }

  // we need to await in the constructor, so doing it like this
  // allows for the factory to wait for initialization
  Future<void> _init() async {
    final routes = await _firestore
        .collection('routes')
        .where('route_short_name', whereIn: shortRouteIds)
        .get();

    routeMapping = <String, String>{
      for (final doc in routes.docs)
        doc['route_id'] as String: doc['route_short_name'] as String
    };
    _defaultRoutes = routeMapping.keys.toList();
  }

  Future get waitForLoad => _providerHasLoaded;

  /// Fetchs data from the JSON API and returns a decoded JSON.
  Future<QuerySnapshot> fetch(
    String collection, {
    List<String>? routes,
    String idField = 'route_id',
  }) async {
    return _firestore
        .collection(collection)
        .where(idField, whereIn: _defaultRoutes)
        .get();
  }

  /// Returns a [Map] of <[BusRoute.routeShortName], [BusRoute]>  pairs.
  Future<Map<String, BusRoute>> getRoutes() async {
    final response = await fetch('routes', routes: _defaultRoutes);

    final routeMap = <String, BusRoute>{
      for (final doc in response.docs)
        doc['route_short_name'] as String:
            BusRoute.fromJson(doc.data()! as Map<String, dynamic>)
    };

    return routeMap;
  }

  /// Returns a [Map] of [BusShape] objects.
  Future<Map<String, BusShape>> getPolylines() async {
    final response = await fetch('polylines', routes: _defaultRoutes);

    final shapesMap = <String, BusShape>{
      for (final doc in response.docs)
        routeMapping[doc['route_id']]!: BusShape.fromJson(
          json.decode(doc['geoJSON'] as String) as Map<String, dynamic>,
        )
    };

    return shapesMap;
  }

  /// Returns a [Map] of [BusStop] objects.
  Future<Map<String, BusStop>> getStops() async {
    final response = await _firestore
        .collection('stops')
        .where('route_ids', arrayContainsAny: _defaultRoutes)
        .get();

    final stopsMap = <String, BusStop>{
      for (final doc in response.docs)
        doc['stop_id'] as String: BusStop.fromJson(doc.data())
    };

    return stopsMap;
  }

  /// Returns a [List] of [BusTrip] objects.
  Future<Map<String, BusTrip>> getTrips() async {
    final response = await fetch('trips', routes: _defaultRoutes);

    final tripList = <String, BusTrip>{
      for (final doc in response.docs)
        routeMapping[doc['route_id']]!:
            BusTrip.fromJson(doc.data()! as Map<String, dynamic>)
    };

    return tripList;
  }

// TO-DO get realtime timetable updates of all routes
  Future<Map<String, Map<String, String>>> getTimetableRealtime() async {
    final now = DateTime.now();
    final milliseconds = now.millisecondsSinceEpoch;
    final ret = <String, Map<String, String>>{};

    for (final route in shortRouteIds) {
      final response = await get<Map<String, dynamic>>(
        url: 'https://www.cdta.org/apicache/routebus_'
            '${route}_0.json?_=$milliseconds',
      );
      if (response != null) {
        // filter out null values from json response and convert to map
        final data = <String, String>{};
        response.forEach((String key, dynamic value) {
          if (value != null) {
            data[key] = value.toString();
          }
        });
        ret[route] = data;
      }
    }
    return ret;
  }

  /// Returns a [Map] of <route_name, List<[BusRealtimeUpdate]>>
  /// realtime update includes
  /// the realtime positions and bearings of the buses obtained from cdta api
  Future<Map<String, List<BusRealtimeUpdate>>> getBusRealtimeUpdates() async {
    final now = DateTime.now();
    final milliseconds = now.millisecondsSinceEpoch;
    final updates = <String, List<BusRealtimeUpdate>>{};
    final response = await get<List<Map<String, dynamic>>>(
      url: 'https://www.cdta.org/realtime/buses.json?$milliseconds',
    );
    if (response != null) {
      for (final element in response) {
        final update = BusRealtimeUpdate.fromJson(element);
        if (shortRouteIds.contains(update.routeId)) {
          if (updates[update.routeId] == null) {
            updates[update.routeId] = [];
          }
          updates[update.routeId]?.add(update);
        }
      }
    }

    return updates;
  }

  /// Returns a [Map] of <route_name,[BusTimetable]>
  Future<Map<String, BusTimetable>> getBusTimetable() async {
    var day = DateFormat('EEEE').format(DateTime.now());
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    if (weekdays.contains(day)) {
      day = 'weekday';
    }
    final response = await _firestore
        .collection('timetables')
        .where('route_id', whereIn: _defaultRoutes)
        .get();
    final timetableMap = <String, BusTimetable>{};
    final realtimeTable = await getTimetableRealtime();

    // since timetables are nested in subcollection we have to retrieve those
    for (final route in response.docs) {
      var table =
          await route.reference.collection(day.toLowerCase()).doc('0').get();
      if (table.data() != null) {
        final entry = BusTimetable.fromJson(table.data()!);
        var id = route.get('route_id') as String;
        id = id.split('-')[0];
        entry.updateWithRealtime(realtimeTable[id]);
        // check if today is in exclusive dates
        final now = DateTime.now();
        final formatter = DateFormat.yMMMMd('en_US');
        final today = formatter.format(now);
        if (entry.excludeDates!.contains(today)) {
          // special case: today is excluded
          // search through other possible days
          // for inclusive dates that contains today
          final possibleDays = ['weekday', 'saturday', 'sunday'];
          for (final d in possibleDays) {
            if (d != day) {
              table = await route.reference
                  .collection(d.toLowerCase())
                  .doc('0')
                  .get();
              if (table.data() != null) {
                final temp = BusTimetable.fromJson(table.data()!);
                if (temp.includeDates!.contains(today) &&
                    !temp.excludeDates!.contains(today)) {
                  // check for exclusive just in case
                  // replace today's schedule with another day's
                  // (e.g: today is a weekday, but uses sunday schedule)
                  timetableMap[routeMapping[route.get('route_id')]!] = temp;
                  break;
                }
              }
            }
          }
        } else {
          // normal case: today not in exclude dates
          timetableMap[routeMapping[route.get('route_id')]!] = entry;
        }

        // TO-DO update the timetable with cdta api
      }
    }

    return timetableMap;
  }
}
