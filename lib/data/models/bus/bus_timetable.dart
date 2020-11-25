import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusTimetable {
  String routeId;
  int directionId;
  String directionName;
  String label;
  String startDate;
  String endDate;
  String serviceId;

  List<String> includeDates;
  List<String> excludeDates;
  List<TimetableStop> stops;
  List<String> timetable;

  BusTimetable(
      {this.routeId,
      this.directionId,
      this.directionName,
      this.label,
      this.startDate,
      this.endDate,
      this.serviceId,
      this.includeDates,
      this.excludeDates,
      this.stops,
      this.timetable});

  int get numColumns => stops.length;
  int get numRows => (timetable.length / stops.length).truncate();

  String getTime(int i, int j) => timetable[j * stops.length + i];

  BusTimetable.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'];
    directionId = json['direction_id'];
    directionName = json['direction_name'];
    label = json['label'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    serviceId = json['service_id'];

    includeDates = json['include_dates'].cast<String>();
    excludeDates = json['exclude_dates'].cast<String>();

    stops = json['stops'].map<TimetableStop>((table) {
      return TimetableStop.fromJson(table);
    }).toList();

    timetable = json['timetable'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = routeId;
    data['direction_id'] = directionId;
    data['direction_name'] = directionName;
    data['label'] = label;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['service_id'] = serviceId;

    data['include_dates'] = includeDates;
    data['exclude_dates'] = excludeDates;

    data['stops'] = stops;

    data['timetable'] = timetable;

    return data;
  }
}

class TimetableStop {
  String stopId;
  double stopLat;
  double stopLon;
  String stopName;

  TimetableStop({this.stopId, this.stopLat, this.stopLon, this.stopName});

  LatLng get latLng => LatLng(stopLat, stopLon);

  TimetableStop.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'];
    stopLat = json['stop_lat'];
    stopLon = json['stop_lon'];
    stopName = json['stop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_id'] = stopId;
    data['stop_lat'] = stopLat;
    data['stop_lon'] = stopLon;
    data['stop_name'] = stopName;
    return data;
  }
}
