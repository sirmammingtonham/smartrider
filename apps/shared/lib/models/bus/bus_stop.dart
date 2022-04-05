/// package used for LatLng object
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Bus Stop model:
/// Contains data related to Bus Stops
class BusStop {
  BusStop({
    this.stopId,
    this.stopCode,
    this.stopName,
    this.ttsStopName,
    this.stopDesc,
    this.stopLat,
    this.stopLon,
    this.zoneId,
    this.stopUrl,
    this.locationType,
    this.parentStation,
    this.stopTimezone,
    this.wheelchairBoarding,
    this.levelId,
    this.platformCode,
    this.arrivalTimes,
    this.departureTimes,
    this.stopSequence,
    this.routeIds,
    this.shapeIds,
    this.tripIds,
  });

  BusStop.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'] as String?;
    stopCode = json['stop_code'] as String?;
    stopName = json['stop_name'] as String?;
    ttsStopName = json['tts_stop_name'] as int?;
    stopDesc = json['stop_desc'] as String?;
    stopLat = json['stop_lat'] as double?;
    stopLon = json['stop_lon'] as double?;
    zoneId = json['zone_id'] as String?;
    stopUrl = json['stop_url'] as String?;
    locationType = json['location_type'] as int?;
    parentStation = json['parent_station'] as int?;
    stopTimezone = json['stop_timezone'] as String?;
    wheelchairBoarding = json['wheelchair_boarding'] as int?;
    levelId = json['level_id'] as int?;
    platformCode = json['platform_code'] as int?;

    arrivalTimes = (json['arrival_times'] as List).cast<int>();
    departureTimes = (json['departure_times'] as List).cast<int>();
    stopSequence = (json['stop_sequence'] as List).cast<int>();

    routeIds = (json['route_ids'] as List).cast<String>();
    shapeIds = (json['shape_ids'] as List).cast<String>();
    tripIds = (json['trip_ids'] as List).cast<String>();
  }
  String? stopId;
  String? stopCode;
  String? stopName;
  int? ttsStopName;
  String? stopDesc;
  double? stopLat;
  double? stopLon;
  String? zoneId;
  String? stopUrl;
  int? locationType;
  int? parentStation;
  String? stopTimezone;
  int? wheelchairBoarding;
  int? levelId;
  int? platformCode;

  List<int>? arrivalTimes;
  List<int>? departureTimes;
  List<int>? stopSequence;

  List<String>? routeIds;
  List<String>? shapeIds;
  List<String>? tripIds;

  LatLng get getLatLng => LatLng(stopLat!, stopLon!);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stop_id'] = stopId;
    data['stop_code'] = stopCode;
    data['stop_name'] = stopName;
    data['tts_stop_name'] = ttsStopName;
    data['stop_desc'] = stopDesc;
    data['stop_lat'] = stopLat;
    data['stop_lon'] = stopLon;
    data['zone_id'] = zoneId;
    data['stop_url'] = stopUrl;
    data['location_type'] = locationType;
    data['parent_station'] = parentStation;
    data['stop_timezone'] = stopTimezone;
    data['wheelchair_boarding'] = wheelchairBoarding;
    data['level_id'] = levelId;
    data['platform_code'] = platformCode;
    data['arrival_times'] = arrivalTimes;
    data['departure_times'] = departureTimes;
    data['stop_sequence'] = stopSequence;

    data['route_ids'] = routeIds;
    data['shape_ids'] = shapeIds;
    data['trip_ids'] = tripIds;
    return data;
  }
}
