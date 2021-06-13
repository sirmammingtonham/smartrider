part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LocationStartTrackingEvent extends LocationEvent {
  final DocumentReference vehicleRef;
  const LocationStartTrackingEvent({required this.vehicleRef});

  @override
  List<Object> get props => [vehicleRef];
}

class LocationStopTrackingEvent extends LocationEvent {
  const LocationStopTrackingEvent();

  @override
  List<Object> get props => [];
}
