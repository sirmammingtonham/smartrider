import '../models/shuttle/shuttle_route.dart';
import '../models/shuttle/shuttle_stop.dart';
import '../models/shuttle/shuttle_vehicle.dart';
import '../models/shuttle/shuttle_update.dart';

import '../providers/shuttle_provider.dart';

//import '../provider/shuttle_local_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class ShuttleRepository {
  final _shuttleProvider = ShuttleProvider();

//  void get openSocket => _shuttleProvider.openSocket();
  Future<Map<String, ShuttleRoute>> get getRoutes async =>
      _shuttleProvider.getRoutes();
  Future<List<ShuttleStop>> get getStops async => _shuttleProvider.getStops();
  Future<List<ShuttleUpdate>> get getUpdates async =>
      _shuttleProvider.getUpdates();
  // Future<LatLng> get getLocation async => _shuttleProvider.getLocation();
  bool get getIsConnected => _shuttleProvider.getIsConnected;
}
