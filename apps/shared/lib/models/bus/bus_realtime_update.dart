class BusRealtimeUpdate {
  BusRealtimeUpdate({
    required this.objName,
    required this.id,
    required this.lat,
    required this.lng,
    required this.bearing,
    required this.routeId,
    required this.stopId,
    required this.stopName,
    required this.tripId,
    required this.directionId,
    required this.tripHeadsign,
  });

  factory BusRealtimeUpdate.fromJson(Map<String, dynamic> json) {
    return BusRealtimeUpdate(
      objName: json['objName'] as String,
      id: json['id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      bearing: json['bearing'] as String,
      routeId: json['route_id'] as String,
      stopId: json['stop_id'] as String,
      stopName: json['stop_name'] as String,
      tripId: json['trip_id'] as String,
      directionId: json['direction_id'] as String,
      tripHeadsign: json['trip_headsign'] as String,
    );
  }

  String objName;
  String id;
  double lat;
  double lng;
  String bearing;
  String routeId;
  String stopId;
  String stopName;
  String tripId;
  String directionId;
  String tripHeadsign;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['objName'] = objName;
    data['id'] = id;
    data['lat'] = lat;
    data['lng'] = lng;
    data['bearing'] = bearing;
    data['route_id'] = routeId;
    data['stop_id'] = stopId;
    data['stop_name'] = stopName;
    data['trip_id'] = tripId;
    data['direction_id'] = directionId;
    data['trip_headsign'] = tripHeadsign;
    return data;
  }
}
