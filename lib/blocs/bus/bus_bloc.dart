import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// model imports
import 'package:smartrider/data/models/bus/bus_advisory.dart';
import 'package:smartrider/data/models/bus/bus_agency.dart';
import 'package:smartrider/data/models/bus/bus_calendar_dates.dart';
import 'package:smartrider/data/models/bus/bus_calendar.dart';
import 'package:smartrider/data/models/bus/bus_fare_attribute.dart';
import 'package:smartrider/data/models/bus/bus_fare_rule.dart';
import 'package:smartrider/data/models/bus/bus_feed_info.dart';
import 'package:smartrider/data/models/bus/bus_route.dart';
import 'package:smartrider/data/models/bus/bus_shape.dart';
import 'package:smartrider/data/models/bus/bus_stop_time.dart';
import 'package:smartrider/data/models/bus/bus_stop.dart';
import 'package:smartrider/data/models/bus/bus_trip.dart';

// repository imports
import 'package:smartrider/data/repository/bus_repository.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  /// Initialization of repository class
  final BusRepository repository;

  bool isLoading = true;

  /// BusBloc named constructor
  BusBloc({this.repository}) : super(BusInitial());

  @override
  Stream<BusState> mapEventToState(BusEvent event) async* {
    if (event is BusInitDataRequested) {
      if (isLoading) {
        yield BusLoading();
        isLoading = false;
      } else {
        /// Poll every 3ish seconds
        await Future.delayed(const Duration(seconds: 2));
      }

      // routes = await repository.getRoutes;
      // stops = await repository.getStops;
      // updates = await repository.getUpdates;

      if (repository.getIsDownloaded) {
        yield BusLoaded();
      } else {
        isLoading = true;
        yield BusError(message: 'NETWORK ISSUE');
      }
      // await Future.delayed(const Duration(seconds: 2));

    } else if (event is BusUpdateRequested) {
      // updates.clear();
      // updates = await repository.getUpdates;

      if (repository.getIsDownloaded) {
        yield BusLoaded();
      } else {
        isLoading = true;
        yield BusError(message: 'NETWORK ISSUE');
      }
    } else {
      yield BusError(
          message: "shuttle shit is borked (no event type found)");
    }
  }
}
