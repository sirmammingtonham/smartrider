import 'package:shared/models/bus/bus_realtime_update.dart';
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_stop.dart';
import 'package:shared/models/bus/bus_timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bus_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class BusRepository {
  /// Private constructor
  BusRepository._create() {
    _busProvider = BusProvider();
  }

  BusRepository._testCreate(FirebaseFirestore? firestore) {
    _busProvider = BusProvider.withFirebase(firestore: firestore);
  }

  late final BusProvider _busProvider;

  /// Public factory
  static Future<BusRepository> create({
    bool isTest = false,
    FirebaseFirestore? firestore,
  }) async {
    final self =
        isTest ? BusRepository._testCreate(firestore) : BusRepository._create();
    await self._busProvider.waitForLoad;
    return self;
  }

  Map<String, String> get routeMap => _busProvider.routeMapping;

  Future<Map<String, BusRoute>> get getRoutes async => _busProvider.getRoutes();

  Future<Map<String, BusShape>> get getPolylines async =>
      _busProvider.getPolylines();

  Future<Map<String, BusStop>> get getStops async => _busProvider.getStops();

  Future<Map<String, BusTimetable>> get getTimetables async =>
      _busProvider.getBusTimetable();

  Future<Map<String, List<BusRealtimeUpdate>>> get getRealtimeUpdate async =>
      _busProvider.getBusRealtimeUpdates();

  Future<Map<String, Map<String, String>>> get getRealtimeTimetable async =>
      _busProvider.getTimetableRealtime();

  List<String> get getDefaultRoutes => _busProvider.getShortRoutes();

  Map<String, String> get getrouteMapping => _busProvider.getrouteMapping();

  // bool get isConnected => _busProvider.getIsConnected;
}
