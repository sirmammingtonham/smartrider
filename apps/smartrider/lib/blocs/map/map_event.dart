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
  const MapUpdateEvent({required this.zoomLevel});

  final double? zoomLevel;

  @override
  List<Object?> get props => [zoomLevel];
}

class MapViewChangeEvent extends MapEvent {
  const MapViewChangeEvent({required this.newView});

  final MapView newView;

  @override
  List<Object> get props => [newView];
}

class MapSaferideEvent extends MapEvent {
  const MapSaferideEvent();

  @override
  List<Object?> get props => [];
}

class MapMoveEvent extends MapEvent {
  const MapMoveEvent({required this.zoomLevel});

  final double zoomLevel;

  @override
  List<Object?> get props => [zoomLevel];
}

class MapErrorEvent extends MapEvent {
  const MapErrorEvent({this.message});

  final String? message;

  @override
  List<Object> get props => [];
}

class MapThemeChangeEvent extends MapEvent {
  const MapThemeChangeEvent({required this.theme});
  final ThemeData theme;
  @override
  List<Object> get props => [theme];
}
