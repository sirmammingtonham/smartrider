import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'pb/gtfs-realtime.pb.dart';
import 'package:fixnum/fixnum.dart';

class BusVehicleUpdate {
  String id;
  bool isDeleted;

  // vehicle.trip
  String tripId;
  String startTime;
  String startDate;
  String routeId;

  // vehicle.position
  double latitude;
  double longitude;

  int currentStopSequence;
  dynamic currentStatus;
  Int64 timestamp;

  // vehicle.vehicle.id
  String vehicleId;

  BusVehicleUpdate(
      {this.id,
      this.isDeleted,
      this.tripId,
      this.startTime,
      this.startDate,
      this.routeId,
      this.latitude,
      this.longitude,
      this.currentStopSequence,
      this.currentStatus,
      this.timestamp,
      this.vehicleId});

  LatLng get getLatLng => LatLng(this.latitude, this.longitude);

  BusVehicleUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['isDeleted'];

    tripId = json['vehicle']['trip']['tripId'];
    startTime = json['vehicle']['trip']['startTime'];
    startDate = json['vehicle']['trip']['startDate'];
    routeId = json['vehicle']['trip']['routeId'];

    latitude = json['vehicle']['position']['latitude'];
    longitude = json['vehicle']['position']['longitude'];

    currentStopSequence = json['vehicle']['currentStopSequence'];
    currentStatus = json['vehicle']['currentStatus'];
    timestamp = json['vehicle']['timestamp'];

    vehicleId = json['vehicle']['vehicle']['id'];
  }

  BusVehicleUpdate.fromPBEntity(FeedEntity entity) {
    id = entity.id;
    isDeleted = entity.isDeleted;

    tripId = entity.vehicle.trip.tripId;
    startTime = entity.vehicle.trip.startTime;
    startDate = entity.vehicle.trip.startDate;
    routeId = entity.vehicle.trip.routeId;

    latitude = entity.vehicle.position.latitude;
    longitude = entity.vehicle.position.longitude;

    currentStopSequence = entity.vehicle.currentStopSequence;
    currentStatus = entity.vehicle.currentStatus;
    timestamp = entity.vehicle.timestamp;

    vehicleId = entity.vehicle.vehicle.id;
  }

  // TODO
  Map<String, dynamic> toJson() {
    return Map();
  }

  // TODO
  FeedEntity toFeedEntity() {
    return FeedEntity();
  }
}