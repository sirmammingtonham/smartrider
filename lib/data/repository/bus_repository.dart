
import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_timetable.dart';
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';

import '../providers/bus_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class BusRepository {
  final _busProvider = BusProvider();
  List<String> get defaultRoutes => BusProvider.defaultRoutes;

  Future<Map<String, BusRoute>> get getRoutes async => _busProvider.getRoutes();

  Future<Map<String, BusShape>> get getPolylines async =>
      _busProvider.getPolylines();

  Future<Map<String, BusStop>> get getStops async => _busProvider.getStops();

  Future<Map<String, BusTimetable>> get getTimetables async =>
      _busProvider.getBusTimetable();

  Future<List<BusTripUpdate>> get getTripUpdates async =>
      _busProvider.getTripUpdates();

  Future<List<BusVehicleUpdate>> get getUpdates async =>
      _busProvider.getVehicleUpdates();

  // bool get isConnected => _busProvider.getIsConnected;
}
