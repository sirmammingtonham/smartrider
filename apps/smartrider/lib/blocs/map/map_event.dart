part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class MapInitEvent extends MapEvent {
  const MapInitEvent();

  @override
  List<Object> get props => [];
}

class MapUpdateEvent extends MapEvent {
  final double? zoomLevel;
  const MapUpdateEvent({required this.zoomLevel});

  @override
  List<Object?> get props => [zoomLevel];
}

class MapViewChangeEvent extends MapEvent {
  final MapView newView;
  const MapViewChangeEvent({required this.newView});

  @override
  List<Object> get props => [newView];
}

class MapSaferideEvent extends MapEvent {
  const MapSaferideEvent();

  @override
  List<Object?> get props => [];
}

class MapMoveEvent extends MapEvent {
  final double zoomLevel;
  const MapMoveEvent({required this.zoomLevel});

  @override
  List<Object?> get props => [zoomLevel];
}

class MapErrorEvent extends MapEvent {
  final String? message;
  const MapErrorEvent({this.message});

  @override
  List<Object> get props => [];
}
