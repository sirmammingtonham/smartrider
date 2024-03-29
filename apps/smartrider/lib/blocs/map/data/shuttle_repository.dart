import 'package:shared/models/shuttle/shuttle_announcement.dart';
import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:shared/models/shuttle/shuttle_update.dart';
import 'package:smartrider/ui/widgets/shuttle_schedules/shuttle_announcements.dart';

import 'shuttle_provider.dart';

//import '../provider/shuttle_local_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class ShuttleRepository {
  ShuttleRepository.create();
  final _shuttleProvider = ShuttleProvider();

//  void get openSocket => _shuttleProvider.openSocket();
  Future<Map<String, ShuttleRoute>> get getRoutes async =>
      _shuttleProvider.getRoutes();
  Future<List<ShuttleStop>> get getStops async => _shuttleProvider.getStops();
  Future<List<ShuttleUpdate>> get getUpdates async =>
      _shuttleProvider.getUpdates();
  Future<List<ShuttleAnnouncement>> get getAnnouncements async =>
      _shuttleProvider.getAnnouncements();
  bool get isConnected => _shuttleProvider.isConnected;
}
