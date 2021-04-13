part of 'saferide_bloc.dart';

abstract class SaferideState extends Equatable {
  const SaferideState();

  @override
  List<Object> get props => [];
}

class SaferideInitialState extends SaferideState {}

/// State for when no safe ride display is needed
class SaferideNoState extends SaferideState {}

class SaferideLoadingState extends SaferideState {}

class SaferideSelectionState extends SaferideState {
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String dropAddress;
  final String pickupDescription;
  final String dropDescription;
  final int queuePosition;
  final int waitEstimate;

  const SaferideSelectionState(
      {@required this.pickupLatLng,
      @required this.pickupDescription,
      @required this.dropLatLng,
      @required this.dropAddress,
      @required this.dropDescription,
      @required this.queuePosition,
      @required this.waitEstimate});

  @override
  List<Object> get props => [
        pickupLatLng,
        pickupDescription,
        dropLatLng,
        dropAddress,
        dropDescription
      ];
}

class SaferideWaitingState extends SaferideState {
  final int queuePosition;
  final int waitEstimate;

  const SaferideWaitingState(
      {@required this.queuePosition, @required this.waitEstimate});

  @override
  List<Object> get props => [queuePosition, waitEstimate];
}

class SaferideAcceptedState extends SaferideState {
  final String driverName;
  final String licensePlate;
  final int queuePosition;
  final int waitEstimate;
  // phone number too

  const SaferideAcceptedState(
      {@required this.driverName,
      @required this.licensePlate,
      @required this.queuePosition,
      @required this.waitEstimate});

  @override
  List<Object> get props => [driverName, licensePlate, queuePosition];
}

class SaferideErrorState extends SaferideState {
  final String status;
  final String message;

  const SaferideErrorState({@required this.status, @required this.message});

  @override
  List<Object> get props => [status, message];
}
