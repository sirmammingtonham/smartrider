part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapLoadingState extends MapState {
  const MapLoadingState();

  @override
  List<Object> get props => [];
}

class MapLoadedState extends MapState {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  const MapLoadedState({@required this.polylines, @required this.markers});

  @override
  List<Object> get props => [polylines, markers];
}

class MapErrorState extends MapState {
  final String message;
  const MapErrorState({this.message});

  @override
  List<Object> get props => [];
}
