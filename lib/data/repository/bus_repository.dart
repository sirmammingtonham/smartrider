import '../models/bus/bus_advisory.dart';
import '../models/bus/bus_agency.dart';
import '../models/bus/bus_calendar_dates.dart';
import '../models/bus/bus_calendar.dart';
import '../models/bus/bus_fare_attribute.dart';
import '../models/bus/bus_fare_rule.dart';
import '../models/bus/bus_feed_info.dart';
import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
import '../models/bus/bus_stop_time.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip.dart';

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
