import 'package:shared/models/bus/bus_realtime_update.dart';
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_stop.dart';
import 'package:shared/models/bus/bus_timetable.dart';
import 'package:shared/models/bus/bus_trip_update.dart';
import 'package:shared/models/bus/bus_vehicle_update.dart';

import '../providers/bus_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class BusRepository {
  late BusProvider _busProvider;

  /// Private constructor
  BusRepository._create() {
    _busProvider = BusProvider();
  }

  /// Public factory
  static Future<BusRepository> create() async {
    BusRepository self = BusRepository._create();
    await self._busProvider.waitForLoad;
    return self;
  }

  Map<String?, String?>? get routeMap => _busProvider.routeMapping;

  Future<Map<String?, BusRoute>> get getRoutes async =>
      _busProvider.getRoutes();

  Future<Map<String?, BusShape>> get getPolylines async =>
      _busProvider.getPolylines();

  Future<Map<String?, BusStop>> get getStops async => _busProvider.getStops();

  Future<Map<String?, BusTimetable>> get getTimetables async =>
      _busProvider.getBusTimetable();

  Future<List<BusTripUpdate>> get getTripUpdates async =>
      _busProvider.getTripUpdates();

  Future<List<BusVehicleUpdate>> get getUpdates async =>
      _busProvider.getVehicleUpdates();

  Future<Map<String, List<BusRealtimeUpdate>>> get getRealtimeUpdate async =>
      _busProvider.getBusRealtimeUpdates();
      
  Future<Map<String,Map<String, String>>> get getRealtimeTimetable async =>
      _busProvider.getTimetableRealtime();

  List<String> get getDefaultRoutes => _busProvider.getShortRoutes();

  // bool get isConnected => _busProvider.getIsConnected;
}
