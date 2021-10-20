part of 'saferide_bloc.dart';

abstract class SaferideEvent extends Equatable {
  const SaferideEvent();
}

class SaferideNoEvent extends SaferideEvent {
  const SaferideNoEvent();
  @override
  List<Object> get props => [];
}

class SaferideSelectingEvent extends SaferideEvent {
  const SaferideSelectingEvent({
    this.pickupPrediction,
    this.dropoffPrediction,
  });

  final Prediction? pickupPrediction;
  final Prediction? dropoffPrediction;

  @override
  List<Object?> get props => [pickupPrediction, dropoffPrediction];
}

class SaferideConfirmedEvent extends SaferideEvent {
  const SaferideConfirmedEvent();

  @override
  List<Object> get props => [];
}

class SaferideWaitingEvent extends SaferideEvent {
  const SaferideWaitingEvent({
    required this.queuePosition,
    required this.estimatedPickup,
  });

  final int queuePosition;
  final int estimatedPickup;

  @override
  List<Object> get props => [queuePosition, estimatedPickup];
}

class SaferidePickingUpEvent extends SaferideEvent {
  const SaferidePickingUpEvent({
    required this.vehicleId,
    required this.driverName,
    required this.driverPhone,
    required this.licensePlate,
    required this.queuePosition,
    required this.estimatedPickup,
  });

  final String vehicleId;
  final String driverName;
  final String driverPhone;
  final String licensePlate;
  final int queuePosition;
  final int estimatedPickup;

  @override
  List<Object> get props => [
        vehicleId,
        driverName,
        driverPhone,
        licensePlate,
        queuePosition,
        estimatedPickup
      ];
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
  const SaferideDriverCancelledEvent({
    required this.reason,
  });

  final String reason;

  @override
  List<Object> get props => [];
}
