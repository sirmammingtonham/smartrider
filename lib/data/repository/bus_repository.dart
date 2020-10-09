import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
import '../models/bus/bus_stop_time.dart';
import '../models/bus/bus_stop.dart';

import '../providers/bus_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class BusRepository {
  final _busProvider = BusProvider();

  // Future<Map<String, BusRoute>> get getRoutes async =>
  //     _busProvider.getRoutes();

  // Future<List<BusStop>> get getStops async => _busProvider.getStops();

  // Future<List<


  // Future<List<BusUpdate>> get getUpdates async =>
  //     _busProvider.getUpdates();

  bool get getIsDownloaded => _busProvider.getIsDownloaded;
}
