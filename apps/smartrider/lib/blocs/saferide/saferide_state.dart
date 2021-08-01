part of 'saferide_bloc.dart';

abstract class SaferideState extends Equatable {
  const SaferideState();

  @override
  List<Object?> get props => [];
}

/// State for when no safe ride display is needed
class SaferideNoState extends SaferideState {
  const SaferideNoState({this.serverTimeStamp});
  final DateTime? serverTimeStamp;
  @override
  List<Object?> get props => [serverTimeStamp];
}

class SaferideLoadingState extends SaferideState {}

class SaferideSelectingState extends SaferideState {
  const SaferideSelectingState(
      {required this.pickupPoint,
      required this.dropPoint,
      required this.pickupDescription,
      required this.dropDescription,
      required this.queuePosition});
  final GeoPoint pickupPoint;
  final GeoPoint dropPoint;
  final String pickupDescription;
  final String dropDescription;
  final int queuePosition;

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
  const SaferideWaitingState(
      {required this.queuePosition, this.estimatedPickup});
  final int queuePosition;
  final int? estimatedPickup;

  @override
  List<Object?> get props => [queuePosition, estimatedPickup];
}

class SaferidePickingUpState extends SaferideState {
  const SaferidePickingUpState(
      {required this.vehicleId,
      required this.driverName,
      required this.phoneNumber,
      required this.licensePlate,
      required this.queuePosition,
      required this.estimatedPickup});
  final String vehicleId;
  final String driverName;
  final String phoneNumber;
  final String licensePlate;
  final int queuePosition;
  final int? estimatedPickup;

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
  const SaferideCancelledState({required this.reason});
  final String reason;

  @override
  List<Object?> get props => [reason];
}

class SaferideErrorState extends SaferideState {
  const SaferideErrorState({required this.status, required this.message});
  final String status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
