part of 'saferide_bloc.dart';

abstract class SaferideEvent extends Equatable {
  const SaferideEvent();
}

class SaferideNoEvent extends SaferideEvent {
  @override
  List<Object> get props => [];
}

class SaferideSelectionEvent extends SaferideEvent {
  final Prediction? pickupPrediction;
  final Prediction? dropoffPrediction;

  const SaferideSelectionEvent({this.pickupPrediction, this.dropoffPrediction});

  @override
  List<Object?> get props => [pickupPrediction, dropoffPrediction];
}

class SaferideSelectionTestEvent extends SaferideEvent {
  final testCoord = const LatLng(42.729280, -73.679056);
  final testAdr = "1761 15th St, Troy, NY 12180";
  final testDesc = "Rensselaer Union";
  const SaferideSelectionTestEvent();

  @override
  List<Object> get props => [];
}

class SaferideConfirmedEvent extends SaferideEvent {
  const SaferideConfirmedEvent();

  @override
  List<Object> get props => [];
}

class SaferideWaitUpdateEvent extends SaferideEvent {
  final int queuePosition;
  final Timestamp? estimatedPickup;

  const SaferideWaitUpdateEvent(
      {required this.queuePosition, required this.estimatedPickup});

  @override
  List<Object> get props => [queuePosition];
}

class SaferideAcceptedEvent extends SaferideEvent {
  final String? licensePlate;
  final String? driverName;
  final int? queuePosition;
  final int? waitEstimate;
  const SaferideAcceptedEvent(
      {this.licensePlate,
      this.driverName,
      this.queuePosition,
      this.waitEstimate});

  @override
  List<Object?> get props =>
      [licensePlate, driverName, queuePosition, waitEstimate];
}

class SaferideCancelEvent extends SaferideEvent {
  const SaferideCancelEvent();

  @override
  List<Object> get props => [];
}
