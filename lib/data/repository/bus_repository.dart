import '../models/bus/bus_advisory.dart';
import '../models/bus/bus_agency.dart';
import '../models/bus/bus_calendar_dates.dart';
import '../models/bus/bus_calendar.dart';
import '../models/bus/bus_fare_attributes.dart';
import '../models/bus/bus_fare_rules.dart';
import '../models/bus/bus_feed_info.dart';
import '../models/bus/bus_gtfs.dart';
import '../models/bus/bus_routes.dart';
import '../models/bus/bus_shapes.dart';
import '../models/bus/bus_stop_times.dart';
import '../models/bus/bus_stops.dart';
import '../models/bus/bus_trips.dart';
import '../models/bus/bus_updates.dart';
import '../models/bus/bus_vehicles.dart';

import '../providers/bus_provider.dart';

/// Repo class that retrieves data from provider class methods and
/// distributes the data to BLoC pattern
class BusRepository {
  final _busProvider = BusProvider();

  bool get getIsDownloaded => _busProvider.getIsDownloaded;
}
