/// package used for LatLng object
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Bus Stop model:
/// Contains data related to Bus Stops
class BusStop {
  String stopId;
  String stopCode;
  String stopName;
  int ttsStopName;
  String stopDesc;
  double stopLat;
  double stopLon;
  String zoneId;
  String stopUrl;
  int locationType;
  int parentStation;
  String stopTimezone;
  int wheelchairBoarding;
  int levelId;
  int platformCode;

  List<int> arrivalTimes;
  List<int> departureTimes;
  List<int> stopSequence;

  List<String> routeIds;
  List<String> shapeIds;
  List<String> tripIds;

  BusStop(
      {this.stopId,
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
      this.tripIds});

  LatLng get getLatLng => LatLng(this.stopLat, this.stopLon);

  BusStop.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'];
    stopCode = json['stop_code'];
    stopName = json['stop_name'];
    ttsStopName = json['tts_stop_name'];
    stopDesc = json['stop_desc'];
    stopLat = json['stop_lat'];
    stopLon = json['stop_lon'];
    zoneId = json['zone_id'];
    stopUrl = json['stop_url'];
    locationType = json['location_type'];
    parentStation = json['parent_station'];
    stopTimezone = json['stop_timezone'];
    wheelchairBoarding = json['wheelchair_boarding'];
    levelId = json['level_id'];
    platformCode = json['platform_code'];

    arrivalTimes = json['arrival_times'].cast<int>();
    departureTimes = json['departure_times'].cast<int>();
    stopSequence = json['stop_sequence'].cast<int>();

    routeIds = json['route_ids'].cast<String>();
    shapeIds = json['shape_ids'].cast<String>();
    tripIds = json['trip_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_id'] = this.stopId;
    data['stop_code'] = this.stopCode;
    data['stop_name'] = this.stopName;
    data['tts_stop_name'] = this.ttsStopName;
    data['stop_desc'] = this.stopDesc;
    data['stop_lat'] = this.stopLat;
    data['stop_lon'] = this.stopLon;
    data['zone_id'] = this.zoneId;
    data['stop_url'] = this.stopUrl;
    data['location_type'] = this.locationType;
    data['parent_station'] = this.parentStation;
    data['stop_timezone'] = this.stopTimezone;
    data['wheelchair_boarding'] = this.wheelchairBoarding;
    data['level_id'] = this.levelId;
    data['platform_code'] = this.platformCode;
    data['arrival_times'] = this.arrivalTimes;
    data['departure_times'] = this.departureTimes;
    data['stop_sequence'] = this.stopSequence;

    data['route_ids'] = this.routeIds;
    data['shape_ids'] = this.shapeIds;
    data['trip_ids'] = this.tripIds;
    return data;
  }
}
