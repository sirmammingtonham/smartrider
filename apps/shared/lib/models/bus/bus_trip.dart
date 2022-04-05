/// Bus Trip model:
/// Contains data for individual trips
class BusTrip {
  BusTrip({
    this.tripId,
    this.routeId,
    this.serviceId,
    this.tripHeadsign,
    this.tripShortName,
    this.directionId,
    this.blockId,
    this.shapeId,
    this.wheelchairAccessible,
    this.bikesAllowed,
  });

  BusTrip.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'] as String?;
    routeId = json['route_id'] as String?;
    serviceId = json['service_id'] as String?;
    tripHeadsign = json['trip_headsign'] as String?;
    // tripShortName = json['trip_short_name']  as String?;
    directionId = json['direction_id'] as int?;
    // blockId = json['block_id']  as String?;
    shapeId = json['shape_id'] as String?;
    wheelchairAccessible = json['wheelchair_accessible'] as int?;
    bikesAllowed = json['bikes_allowed'] as int?;
  }

  String? tripId;
  String? routeId;
  String? serviceId;
  String? tripHeadsign;
  void tripShortName;
  int? directionId;
  void blockId;
  String? shapeId;
  int? wheelchairAccessible;
  int? bikesAllowed;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['route_id'] = routeId;
    data['service_id'] = serviceId;
    data['trip_headsign'] = tripHeadsign;
    // data['trip_short_name'] = tripShortName;
    data['direction_id'] = directionId;
    // data['block_id'] = blockId;
    data['shape_id'] = shapeId;
    data['wheelchair_accessible'] = wheelchairAccessible;
    data['bikes_allowed'] = bikesAllowed;
    return data;
  }
}
