part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationNotTrackingState extends LocationState {}

class LocationTrackingState extends LocationState {}
