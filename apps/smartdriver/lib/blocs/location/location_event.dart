part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LocationStartTrackingEvent extends LocationEvent {
  const LocationStartTrackingEvent({required this.vehicleRef});
  final DocumentReference vehicleRef;

  @override
  List<Object> get props => [vehicleRef];
}

class LocationStopTrackingEvent extends LocationEvent {
  const LocationStopTrackingEvent();

  @override
  List<Object> get props => [];
}
