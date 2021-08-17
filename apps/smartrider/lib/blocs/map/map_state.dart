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
  const MapLoadedState({
    required this.polylines,
    required this.markers,
    required this.mapView,
  });

  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final MapView mapView;

  @override
  List<Object> get props => [polylines, markers, mapView];
}

class MapErrorState extends MapState {
  const MapErrorState({required this.error});

  final SRError error;

  @override
  List<Object> get props => [error.toString()];
}
