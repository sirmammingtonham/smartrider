/// packages used for protocol buffer implementation
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pbserver.dart';
import 'package:fixnum/fixnum.dart';

/// Bus Trip Update model:
/// Contains data related to realtime trip updates
class BusTripUpdate {
  String? id;
  bool? isDeleted;

  /// Representation of [tripUpdate.trip] attributes
  String? tripId;
  String? startTime;
  String? startDate;
  String? routeId;

  /// Representation of [tripUpdate.stopTimeUpdate] attribute
  List<StopTimeUpdate>? stopTimeUpdate;

  String? vehicleId;

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

    stopTimeUpdate = [];

    entity.tripUpdate.stopTimeUpdate.forEach((entity) {
      stopTimeUpdate!.add(StopTimeUpdate.fromPBEntity(entity));
    });

    vehicleId = entity.tripUpdate.vehicle.id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_deleted'] = this.isDeleted;
    data['trip_id'] = this.tripId;
    data['start_time'] = this.startTime;
    data['start_date'] = this.startDate;
    data['route_id'] = this.routeId;
    data['stop_time_update'] = this.stopTimeUpdate;
    data['vehicle_id'] = this.vehicleId;
    return data;
  }

  // TODO
  FeedEntity toPBEntity() {
    return FeedEntity();
  }
}

/// Modified [BusStoptime] class to account for realtime data
class StopTimeUpdate {
  int? stopSequence;
  Int64? arrivalTime;
  Int64? departureTime;
  String? stopId;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_sequence'] = this.stopSequence;
    data['arrival_time'] = this.arrivalTime;
    data['departure_time'] = this.departureTime;
    data['stop_id'] = this.stopId;

    return data;
  }

  // TODO
  FeedEntity toPBEntity() {
    return FeedEntity();
  }
}
