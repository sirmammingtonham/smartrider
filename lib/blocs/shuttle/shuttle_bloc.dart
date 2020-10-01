import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// model imports
import 'package:smartrider/data/models/shuttle/shuttle_route.dart';
import 'package:smartrider/data/models/shuttle/shuttle_stop.dart';
import 'package:smartrider/data/models/shuttle/shuttle_update.dart';
import 'package:smartrider/data/models/shuttle/shuttle_vehicle.dart';

// repository imports
import 'package:smartrider/data/repository/shuttle_repository.dart';

part 'shuttle_event.dart';
part 'shuttle_state.dart';

class ShuttleBloc extends Bloc<ShuttleEvent, ShuttleState> {
  /// Initialization of repository class
  final ShuttleRepository repository;
  List<ShuttleRoute> routes = [];
  List<ShuttleStop> stops = [];
  List<ShuttleUpdate> updates = [];
  List<ShuttleVehicle> vehicles = [];

  bool isLoading = true;

  /// ShuttleBloc named constructor
  ShuttleBloc({this.repository}) : super(ShuttleInitial());

  @override
  Stream<ShuttleState> mapEventToState(ShuttleEvent event) async* {
    if (event is ShuttleInitDataRequested) {
      if (isLoading) {
        yield ShuttleLoading();
        isLoading = false;
      } else {
        /// Poll every 3ish seconds
        await Future.delayed(const Duration(seconds: 2));
      }

      routes = await repository.getRoutes;
      stops = await repository.getStops;
      updates = await repository.getUpdates;

      if (repository.getIsConnected) {
        yield ShuttleLoaded(routes: routes, updates: updates, stops: stops);
      } else {
        isLoading = true;
        yield ShuttleError(message: 'NETWORK ISSUE');
      }
      // await Future.delayed(const Duration(seconds: 2));

    } else if (event is ShuttleUpdateRequested) {
      updates.clear();
      updates = await repository.getUpdates;

      if (repository.getIsConnected) {
        yield ShuttleLoaded(routes: routes, updates: updates, stops: stops);
      } else {
        isLoading = true;
        yield ShuttleError(message: 'NETWORK ISSUE');
      }
    } else {
      yield ShuttleError(
          message: "shuttle shit is borked (no event type found)");
    }
  }
}
