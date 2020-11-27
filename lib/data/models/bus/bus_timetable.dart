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
  List<String> formatted;
  List<int> timestamps;

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
      this.formatted});

  int get numColumns => stops.length;
  int get numRows => (formatted.length / stops.length).truncate();

  String getTime(int i, int j) => formatted[j * stops.length + i];
  int getTimestamp(int i, int j) => timestamps[j * stops.length + i];

  String getClosestTime(int i) {
    int now = DateTime.now().hour * 3600 +
        DateTime.now().minute * 60 +
        DateTime.now().second;

    List<int> min = [0, 0];

    for (int j = 0; j < numColumns; ++j) {
      int diff = (getTimestamp(i, j) - now).abs();
      if (diff < getTimestamp(min[0], min[1])) {
        min = [i, j];
      }
    }
    return getTime(min[0], min[1]);
  }

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

    formatted = json['formatted'].cast<String>();
    timestamps = json['timestamps'].cast<int>();
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

    data['formatted'] = formatted;
    data['timestamps'] = timestamps;

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
