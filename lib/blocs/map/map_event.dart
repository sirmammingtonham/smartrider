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
  const MapUpdateEvent();

  @override
  List<Object> get props => [];
}

class MapErrorEvent extends MapEvent {
  final String message;
  const MapErrorEvent({this.message});

  @override
  List<Object> get props => [];
}


