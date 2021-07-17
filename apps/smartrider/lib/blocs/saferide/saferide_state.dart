part of 'saferide_bloc.dart';

abstract class SaferideState extends Equatable {
  const SaferideState();

  @override
  List<Object?> get props => [];
}

/// State for when no safe ride display is needed
class SaferideNoState extends SaferideState {}

class SaferideLoadingState extends SaferideState {}

class SaferideSelectingState extends SaferideState {
  final GeoPoint pickupPoint;
  final GeoPoint dropPoint;
  final String pickupDescription;
  final String dropDescription;
  final int queuePosition;

  const SaferideSelectingState(
      {required this.pickupPoint,
      required this.dropPoint,
      required this.pickupDescription,
      required this.dropDescription,
      required this.queuePosition});

  LatLng get pickupLatLng =>
      LatLng(pickupPoint.latitude, pickupPoint.longitude);
  LatLng get dropLatLng => LatLng(dropPoint.latitude, dropPoint.longitude);

  @override
  List<Object?> get props => [
        pickupPoint,
        dropPoint,
        pickupDescription,
        dropDescription,
        dropDescription
      ];
}

class SaferideWaitingState extends SaferideState {
  final int queuePosition;
  final Timestamp? estimatedPickup;

  const SaferideWaitingState(
      {required this.queuePosition, this.estimatedPickup});

  @override
  List<Object?> get props => [queuePosition, estimatedPickup];
}

class SaferidePickingUpState extends SaferideState {
  final String vehicleId;
  final String driverName;
  final String phoneNumber;
  final String licensePlate;
  final int queuePosition;
  final Timestamp? estimatedPickup;

  const SaferidePickingUpState(
      {required this.vehicleId,
      required this.driverName,
      required this.phoneNumber,
      required this.licensePlate,
      required this.queuePosition,
      required this.estimatedPickup});

  @override
  List<Object?> get props => [
        vehicleId,
        driverName,
        phoneNumber,
        licensePlate,
        queuePosition,
        estimatedPickup
      ];
}

class SaferideDroppingOffState extends SaferideState {
  const SaferideDroppingOffState();

  @override
  List<Object?> get props => [];
}

class SaferideCancelledState extends SaferideState {
  final String reason;

  const SaferideCancelledState({required this.reason});

  @override
  List<Object?> get props => [reason];
}

class SaferideErrorState extends SaferideState {
  final String status;
  final String? message;

  const SaferideErrorState({required this.status, required this.message});

  @override
  List<Object?> get props => [status, message];
}
