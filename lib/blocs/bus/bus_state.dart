part of 'bus_bloc.dart';

abstract class BusState extends Equatable {
  const BusState();
}

/// This class represents what user will see intially
class BusInitial extends BusState {
  const BusInitial();
  @override
  List<Object> get props => [];
}

/// This class represents what user will see when fetching data
class BusLoading extends BusState {
  const BusLoading();
  @override
  List<Object> get props => [];
}

/// This class represents what user will see when data is fetched
class BusLoaded extends BusState {
  final Map<String, BusRoute> routes;
  final List<BusShape> shapes;
  final List<BusStop> stops;
  final List<BusVehicleUpdate> updates;

  const BusLoaded(this.routes, this.shapes, this.stops, this.updates);
  @override
  List<Object> get props => [routes, shapes, stops, updates];
}

// This class represents what user will see when there is an error
class BusError extends BusState {
  final String message;
  const BusError({this.message});
  @override
  List<Object> get props => [message];
}