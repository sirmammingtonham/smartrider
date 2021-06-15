class BusRealtimeUpdate {
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

  BusRealtimeUpdate(
      {required this.objName,
      required this.id,
      required this.lat,
      required this.lng,
      required this.bearing,
      required this.routeId,
      required this.stopId,
      required this.stopName,
      required this.tripId,
      required this.directionId,
      required this.tripHeadsign});

  factory BusRealtimeUpdate.fromJson(Map<String, dynamic> json) {
    return BusRealtimeUpdate(
        objName: json['objName'],
        id: json['id'],
        lat: json['lat'],
        lng: json['lng'],
        bearing: json['bearing'],
        routeId: json['route_id'],
        stopId: json['stop_id'],
        stopName: json['stop_name'],
        tripId: json['trip_id'],
        directionId: json['direction_id'],
        tripHeadsign: json['trip_headsign']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objName'] = this.objName;
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['bearing'] = this.bearing;
    data['route_id'] = this.routeId;
    data['stop_id'] = this.stopId;
    data['stop_name'] = this.stopName;
    data['trip_id'] = this.tripId;
    data['direction_id'] = this.directionId;
    data['trip_headsign'] = this.tripHeadsign;
    return data;
  }
}
