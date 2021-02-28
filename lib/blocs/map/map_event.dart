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
  final double zoomLevel;
  const MapUpdateEvent({@required this.zoomLevel});

  @override
  List<Object> get props => [zoomLevel];
}

class MapTypeChangeEvent extends MapEvent {
  final double zoomLevel;
  const MapTypeChangeEvent({@required this.zoomLevel});

  @override
  List<Object> get props => [zoomLevel];
}

class MapSaferideCalledEvent extends MapEvent {
  final LatLng coord;
  const MapSaferideCalledEvent({@required this.coord});

  @override
  List<Object> get props => [coord];
}

class MapMoveEvent extends MapEvent {
  final double zoomLevel;
  const MapMoveEvent({this.zoomLevel});

  @override
  List<Object> get props => [zoomLevel];
}

class MapErrorEvent extends MapEvent {
  final String message;
  const MapErrorEvent({this.message});

  @override
  List<Object> get props => [];
}
