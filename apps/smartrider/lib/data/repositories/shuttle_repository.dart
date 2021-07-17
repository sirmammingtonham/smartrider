import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:shared/models/shuttle/shuttle_update.dart';

import '../providers/shuttle_provider.dart';

//import '../provider/shuttle_local_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class ShuttleRepository {
  final _shuttleProvider = ShuttleProvider();

  ShuttleRepository.create();

//  void get openSocket => _shuttleProvider.openSocket();
  Future<Map<String?, ShuttleRoute>> get getRoutes async =>
      _shuttleProvider.getRoutes();
  Future<List<ShuttleStop>?> get getStops async => _shuttleProvider.getStops();
  Future<List<ShuttleUpdate>?> get getUpdates async =>
      _shuttleProvider.getUpdates();
  bool get isConnected => _shuttleProvider.isConnected;
}
