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
  final MapView mapView;
  const MapLoadedState(
      {required this.polylines, required this.markers, required this.mapView});

  @override
  List<Object> get props => [polylines, markers, mapView];
}

class MapErrorState extends MapState {
  final SRError error;
  const MapErrorState({required this.error});

  @override
  List<Object> get props => [error.toString()];
}
