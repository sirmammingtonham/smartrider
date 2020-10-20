import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pbserver.dart';
import 'package:fixnum/fixnum.dart';

class BusTripUpdate {
  String id;
  bool isDeleted;

  // tripUpdate.trip
  String tripId;
  String startTime;
  String startDate;
  String routeId;

  // tripUpdate.stopTimeUpdate
  List<StopTimeUpdate> stopTimeUpdate;

  String vehicleId;

  BusTripUpdate(
      {this.id,
      this.isDeleted,
      this.tripId,
      this.startTime,
      this.startDate,
      this.routeId,
      this.stopTimeUpdate,
      this.vehicleId});

  BusTripUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['isDeleted'];

    tripId = json['tripUpdate']['trip']['tripId'];
    startTime = json['tripUpdate']['trip']['startTime'];
    startDate = json['tripUpdate']['trip']['startDate'];
    routeId = json['tripUpdate']['trip']['routeId'];

    json['tripUpdate']['stopTimeUpdate'].forEach(() {});

    vehicleId = json['tripUpdate']['vehicle']['id'];
  }

  BusTripUpdate.fromPBEntity(FeedEntity entity) {
    id = entity.id;
    isDeleted = entity.isDeleted;

    tripId = entity.tripUpdate.trip.tripId;
    startTime = entity.tripUpdate.trip.startTime;
    startDate = entity.tripUpdate.trip.startDate;
    routeId = entity.tripUpdate.trip.routeId;

    entity.tripUpdate.stopTimeUpdate.forEach((entity) {
      stopTimeUpdate.add(StopTimeUpdate.fromPBEntity(entity));
    });

    vehicleId = entity.tripUpdate.vehicle.id;
  }

  // TODO
  Map<String, dynamic> toJson() {
    return Map();
  }

  // TODO
  FeedEntity toPBEntity() {
    return FeedEntity();
  }
}

class StopTimeUpdate {
  int stopSequence;
  Int64 arrivalTime;
  Int64 departureTime;
  String stopId;
  dynamic scheduleRelationship;

  StopTimeUpdate(
      {this.stopSequence,
      this.arrivalTime,
      this.departureTime,
      this.stopId,
      this.scheduleRelationship});

  StopTimeUpdate.fromJson(Map<String, dynamic> json) {
    stopSequence = json['stopSequence'];
    arrivalTime = json['arrival']['time'];
    departureTime = json['departure']['time'];
    stopId = json['stopId'];
    scheduleRelationship = json['scheduleRelationship'];
  }

  StopTimeUpdate.fromPBEntity(TripUpdate_StopTimeUpdate entity) {
    stopSequence = entity.stopSequence;
    arrivalTime = entity.arrival.time;
    departureTime = entity.departure.time;
    stopId = entity.stopId;
    scheduleRelationship = entity.scheduleRelationship;
  }

  // TODO
  Map<String, dynamic> toJson() {
    return Map();
  }

  // TODO
  FeedEntity toPBEntity() {
    return FeedEntity();
  }
}
