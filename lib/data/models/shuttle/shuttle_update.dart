class ShuttleUpdate {
  /// ID of the update
  int id;

  /// Not super sure what this is used for
  String trackerId;

  /// Heading in degrees for the shuttle
  num heading;

  /// Speed of the shuttle
  num speed;

  /// Timestamp of when this updated was sent
  String time;

  /// Timestamp of when shuttle was recieved
  String created;

  /// ID associated with the shuttle
  int vehicleId;

  /// The route ID that the shuttle runs on
  int routeId;

  /// Uses a super constructor to define lat/lng attributes
  ShuttleUpdate(
      {latitude,
      longitude,
      this.id,
      this.trackerId,
      this.heading,
      this.speed,
      this.time,
      this.created,
      this.vehicleId,
      this.routeId});

  factory ShuttleUpdate.fromJson(Map<String, dynamic> json) {
    return ShuttleUpdate(
      id: json['id'],
      trackerId: json['tracker_id'],
      heading: (json['heading'] as num).toDouble(),
      speed: json['speed'],
      time: json['time'],
      created: json['created'],
      vehicleId: json['vehicle_id'],
      routeId: json['route_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
