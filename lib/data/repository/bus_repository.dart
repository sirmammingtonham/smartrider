import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';

import '../providers/bus_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class BusRepository {
  final _busProvider = BusProvider();

  Future<Map<String, BusRoute>> get getRoutes async => _busProvider.getRoutes();

  Future<Map<String, BusShape>> get getPolylines async => _busProvider.getPolylines();

  Future<Map<String, List<BusStop>>> get getStops async => _busProvider.getStops();

  Future<List<BusTripUpdate>> get getTripUpdates async =>
      _busProvider.getTripUpdates();

  Future<List<BusVehicleUpdate>> get getUpdates async =>
      _busProvider.getVehicleUpdates();

  // bool get isConnected => _busProvider.getIsConnected;
}
