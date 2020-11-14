/// Bus Stoptime model:
/// Contains data related to stop times
class BusStoptime {
  int id;
  String tripId;
  String arrivalTime;
  int arrivalTimestamp;
  String departureTime;
  int departureTimestamp;
  String stopId;
  int stopSequence;
  Null stopHeadsign;
  int pickupType;
  int dropOffType;
  Null continuousPickup;
  Null continuousDropOff;
  Null shapeDistTraveled;
  int timepoint;

  BusStoptime(
      {this.id,
      this.tripId,
      this.arrivalTime,
      this.arrivalTimestamp,
      this.departureTime,
      this.departureTimestamp,
      this.stopId,
      this.stopSequence,
      this.stopHeadsign,
      this.pickupType,
      this.dropOffType,
      this.continuousPickup,
      this.continuousDropOff,
      this.shapeDistTraveled,
      this.timepoint});

  BusStoptime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    arrivalTime = json['arrival_time'];
    arrivalTimestamp = json['arrival_timestamp'];
    departureTime = json['departure_time'];
    departureTimestamp = json['departure_timestamp'];
    stopId = json['stop_id'];
    stopSequence = json['stop_sequence'];
    stopHeadsign = json['stop_headsign'];
    pickupType = json['pickup_type'];
    dropOffType = json['drop_off_type'];
    continuousPickup = json['continuous_pickup'];
    continuousDropOff = json['continuous_drop_off'];
    shapeDistTraveled = json['shape_dist_traveled'];
    timepoint = json['timepoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['trip_id'] = this.tripId;
    data['arrival_time'] = this.arrivalTime;
    data['arrival_timestamp'] = this.arrivalTimestamp;
    data['departure_time'] = this.departureTime;
    data['departure_timestamp'] = this.departureTimestamp;
    data['stop_id'] = this.stopId;
    data['stop_sequence'] = this.stopSequence;
    data['stop_headsign'] = this.stopHeadsign;
    data['pickup_type'] = this.pickupType;
    data['drop_off_type'] = this.dropOffType;
    data['continuous_pickup'] = this.continuousPickup;
    data['continuous_drop_off'] = this.continuousDropOff;
    data['shape_dist_traveled'] = this.shapeDistTraveled;
    data['timepoint'] = this.timepoint;
    return data;
  }
}