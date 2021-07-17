import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleRoute {
  ShuttleRoute(
      {this.id,
      this.name,
      this.description,
      this.enabled,
      this.color,
      this.width,
      this.stopIds,
      this.created,
      this.updated,
      this.points,
      this.active,
      this.schedule});

  ShuttleRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    enabled = json['enabled'];
    color = Color(int.parse(json['color'].toString().replaceAll('#', '0xff')));
    width = json['width'];
    stopIds = (json['stop_ids'] as List).cast<int>();
    created = json['created'];
    updated = json['updated'];
    if (json['points'] != null) {
      points = [];
      for (final v in json['points'] as List) {
        points!.add(Point.fromJson(v));
      }
    }
    active = json['active'];
    if (json['schedule'] != null) {
      schedule = [];
      for (final v in json['schedule'] as List) {
        schedule!.add(Schedule.fromJson(v));
      }
    }
  }

  int? id;
  String? name;
  String? description;
  bool? enabled;
  Color? color;
  int? width;
  List<int>? stopIds;
  String? created;
  String? updated;
  List<Point>? points;
  bool? active;
  List<Schedule>? schedule;

  Polyline get getPolyline => Polyline(
        polylineId: PolylineId(name!),
        color: color!,
        width: 4,
        points: points!.map((points) => points.getLatLng).toList(),
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['enabled'] = enabled;
    data['color'] = color;
    data['width'] = width;
    data['stop_ids'] = stopIds;
    data['created'] = created;
    data['updated'] = updated;
    if (points != null) {
      data['points'] = points!.map((v) => v.toJson()).toList();
    }
    data['active'] = active;
    if (schedule != null) {
      data['schedule'] = schedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Point {
  Point({this.latitude, this.longitude});

  Point.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  double? latitude;
  double? longitude;

  LatLng get getLatLng => LatLng(latitude!, longitude!);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Schedule {
  Schedule(
      {this.id,
      this.routeId,
      this.startDay,
      this.startTime,
      this.endDay,
      this.endTime});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeId = json['route_id'];
    startDay = json['start_day'];
    startTime = json['start_time'];
    endDay = json['end_day'];
    endTime = json['end_time'];
  }

  int? id;
  int? routeId;
  int? startDay;
  String? startTime;
  int? endDay;
  String? endTime;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['route_id'] = routeId;
    data['start_day'] = startDay;
    data['start_time'] = startTime;
    data['end_day'] = endDay;
    data['end_time'] = endTime;
    return data;
  }
}
