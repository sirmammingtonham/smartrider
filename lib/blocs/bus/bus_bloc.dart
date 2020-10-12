import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// model imports
import 'package:smartrider/data/models/bus/bus_route.dart';
import 'package:smartrider/data/models/bus/bus_shape.dart';
// import 'package:smartrider/data/models/bus/bus_stop_time.dart';
import 'package:smartrider/data/models/bus/bus_stop.dart';
import 'package:smartrider/data/models/bus/bus_vehicle_update.dart';

// repository imports
import 'package:smartrider/data/repository/bus_repository.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  /// Initialization of repository class
  final BusRepository repository;
  Map<String, BusRoute> routes;
  List<BusShape> shapes;
  List<BusStop> stops;
  List<BusVehicleUpdate> updates;

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

      routes = await repository.getRoutes;
      shapes = await repository.getShapes;
      stops = await repository.getStops;
      updates = await repository.getUpdates;

      if (repository.getIsConnected) {
        yield BusLoaded(routes, shapes, stops, updates);
      } else {
        isLoading = true;
        yield BusError(message: 'NETWORK ISSUE');
      }
      // await Future.delayed(const Duration(seconds: 2));

    } else if (event is BusUpdateRequested) {
      updates.clear();
      updates = await repository.getUpdates;

      if (repository.getIsConnected) {
        yield BusLoaded(routes, shapes, stops, updates);
      } else {
        isLoading = true;
        yield BusError(message: 'NETWORK ISSUE');
      }
    } else {
      yield BusError(message: "bus shit is borked (no event type found)");
    }
  }
}
