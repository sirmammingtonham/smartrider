part of 'saferide_bloc.dart';

abstract class SaferideEvent extends Equatable {
  const SaferideEvent();
}

class SaferideNoEvent extends SaferideEvent {
  @override
  List<Object> get props => [];
}

class SaferideSelectingEvent extends SaferideEvent {
  final Prediction? pickupPrediction;
  final Prediction? dropoffPrediction;

  const SaferideSelectingEvent({this.pickupPrediction, this.dropoffPrediction});

  @override
  List<Object?> get props => [pickupPrediction, dropoffPrediction];
}

class SaferideConfirmedEvent extends SaferideEvent {
  const SaferideConfirmedEvent();

  @override
  List<Object> get props => [];
}

class SaferideWaitingEvent extends SaferideEvent {
  final int queuePosition;
  final Timestamp? estimatedPickup;

  const SaferideWaitingEvent(
      {required this.queuePosition, required this.estimatedPickup});

  @override
  List<Object> get props => [queuePosition];
}

class SaferidePickingUpEvent extends SaferideEvent {
  final String licensePlate;
  final String driverName;
  final String driverPhone;
  final int queuePosition;
  final Timestamp estimatedPickup;
  const SaferidePickingUpEvent(
      {required this.licensePlate,
      required this.driverName,
      required this.driverPhone,
      required this.queuePosition,
      required this.estimatedPickup});

  @override
  List<Object> get props =>
      [licensePlate, driverName, queuePosition, estimatedPickup];
}

class SaferideDroppingOffEvent extends SaferideEvent {
  const SaferideDroppingOffEvent();

  @override
  List<Object> get props => [];
}

class SaferideUserCancelledEvent extends SaferideEvent {
  const SaferideUserCancelledEvent();

  @override
  List<Object> get props => [];
}

class SaferideDriverCancelledEvent extends SaferideEvent {
  final String reason;
  const SaferideDriverCancelledEvent({required this.reason});

  @override
  List<Object> get props => [];
}