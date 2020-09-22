part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class MapInitialized extends MapEvent {
  final GoogleMapController controller;

  const MapInitialized({this.controller});

  @override
  List<Object> get props => [controller];
}
