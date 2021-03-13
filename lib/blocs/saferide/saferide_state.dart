part of 'saferide_bloc.dart';

abstract class SaferideState extends Equatable {
  const SaferideState();
  @override
  List<Object> get props => [];
}

class SaferideInitialState extends SaferideState {
  @override
  List<Object> get props => [];
}

/// State for when no safe ride display is needed
class SaferideNoState extends SaferideState {
  @override
  List<Object> get props => [];
}

class SaferideSelectionState extends SaferideState {
  final LatLng pickupLatLng;
  final LatLng destLatLng;
  final String destAddress;
  final String pickupDescription;
  final String destDescription;

  const SaferideSelectionState(
      {@required this.pickupLatLng,
      @required this.pickupDescription,
      @required this.destLatLng,
      @required this.destAddress,
      @required this.destDescription});

  @override
  List<Object> get props => [
        pickupLatLng,
        pickupDescription,
        destLatLng,
        destAddress,
        destDescription
      ];
}

class SaferideErrorState extends SaferideState {
  final String status;
  final String message;

  const SaferideErrorState({@required this.status, @required this.message});

  @override
  List<Object> get props => [status, message];
}

class SaferideConfirmedState extends SaferideState {
  final String driverName;
  final String licensePlate;
  final int queuePosition;
  final int timeEstimate;
  // phone number too

  const SaferideConfirmedState(
      {@required this.driverName,
      @required this.licensePlate,
      @required this.queuePosition, @required this.timeEstimate});

  @override
  List<Object> get props => [driverName, licensePlate, queuePosition];
}
