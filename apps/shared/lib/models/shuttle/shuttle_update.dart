import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleUpdate {
  /// Uses a super constructor to define lat/lng attributes
  ShuttleUpdate({
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.trackerId,
    required this.heading,
    required this.speed,
    required this.time,
    required this.created,
    required this.vehicleId,
    required this.routeId,
  });

  factory ShuttleUpdate.fromJson(Map<String, dynamic> json) {
    return ShuttleUpdate(
      id: json['id'] as int?,
      trackerId: json['tracker_id'] as String?,
      heading: (json['heading'] as num).toDouble(),
      speed: json['speed'] as num?,
      time: json['time'] as String?,
      created: json['created'] as String?,
      vehicleId: json['vehicle_id'] as int?,
      routeId: (json['route_id'] ?? -1) as int, // -1 instead of null
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  /// ID of the update
  int? id;

  /// Not super sure what this is used for
  String? trackerId;

  /// Heading in degrees for the shuttle
  num? heading;

  /// Speed of the shuttle
  num? speed;

  /// Timestamp of when this updated was sent
  String? time;

  /// Timestamp of when shuttle was recieved
  String? created;

  /// ID associated with the shuttle
  int? vehicleId;

  /// The route ID that the shuttle runs on
  int routeId;

  /// lng and lat
  double latitude;
  double longitude;

  LatLng get getLatLng => LatLng(latitude, longitude);
}
