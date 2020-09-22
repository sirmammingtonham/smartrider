part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitializingState extends MapState {

  const MapInitializingState();

  @override
  List<Object> get props => [];
}

/// This class allows us to pass the map controller around
class MapControllerState extends MapState {
  final GoogleMapController controller;

  const MapControllerState({this.controller});

  @override
  List<Object> get props => [controller];

  GoogleMapController get getMapController => controller;
}

class MapErrorState extends MapState {

  const MapErrorState();

  @override
  List<Object> get props => [];

}
