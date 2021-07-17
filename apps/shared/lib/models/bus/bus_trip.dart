/// Bus Trip model:
/// Contains data for individual trips
class BusTrip {
  String? tripId;
  String? routeId;
  String? serviceId;
  String? tripHeadsign;
  Null tripShortName;
  int? directionId;
  Null blockId;
  String? shapeId;
  int? wheelchairAccessible;
  int? bikesAllowed;

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
    final data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['route_id'] = routeId;
    data['service_id'] = serviceId;
    data['trip_headsign'] = tripHeadsign;
    data['trip_short_name'] = tripShortName;
    data['direction_id'] = directionId;
    data['block_id'] = blockId;
    data['shape_id'] = shapeId;
    data['wheelchair_accessible'] = wheelchairAccessible;
    data['bikes_allowed'] = bikesAllowed;
    return data;
  }
}
