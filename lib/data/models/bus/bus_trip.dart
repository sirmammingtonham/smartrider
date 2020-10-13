class BusTrip {
  String tripId;
  String routeId;
  String serviceId;
  String tripHeadsign;
  Null tripShortName;
  int directionId;
  Null blockId;
  String shapeId;
  int wheelchairAccessible;
  int bikesAllowed;

  BusTrip(
      {this.tripId,
      this.routeId,
      this.serviceId,
      this.tripHeadsign,
      this.tripShortName,
      this.directionId,
      this.blockId,
      this.shapeId,
      this.wheelchairAccessible,
      this.bikesAllowed});

  BusTrip.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    routeId = json['route_id'];
    serviceId = json['service_id'];
    tripHeadsign = json['trip_headsign'];
    tripShortName = json['trip_short_name'];
    directionId = json['direction_id'];
    blockId = json['block_id'];
    shapeId = json['shape_id'];
    wheelchairAccessible = json['wheelchair_accessible'];
    bikesAllowed = json['bikes_allowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['route_id'] = this.routeId;
    data['service_id'] = this.serviceId;
    data['trip_headsign'] = this.tripHeadsign;
    data['trip_short_name'] = this.tripShortName;
    data['direction_id'] = this.directionId;
    data['block_id'] = this.blockId;
    data['shape_id'] = this.shapeId;
    data['wheelchair_accessible'] = this.wheelchairAccessible;
    data['bikes_allowed'] = this.bikesAllowed;
    return data;
  }
}