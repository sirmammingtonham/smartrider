import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleRoute {
  ShuttleRoute(
      {required this.id,
      required this.name,
      required this.description,
      required this.enabled,
      required this.color,
      required this.width,
      required this.stopIds,
      required this.created,
      required this.updated,
      required this.points,
      required this.active,
      required this.schedule});

  factory ShuttleRoute.fromJson(Map<String, dynamic> json) {
    final points = <Point>[];
    for (final v in json['points'] as List) {
      points.add(Point.fromJson(v));
    }
    final schedule = <Schedule>[];
    for (final v in json['schedule'] as List) {
      schedule.add(Schedule.fromJson(v));
    }
    return ShuttleRoute(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        enabled: json['enabled'],
        color:
            Color(int.parse(json['color'].toString().replaceAll('#', '0xff'))),
        width: json['width'],
        stopIds: (json['stop_ids'] as List).cast<int>(),
        created: json['created'],
        updated: json['updated'],
        points: points,
        active: json['active'],
        schedule: schedule);
  }

  final int id;
  final String name;
  final String description;
  final bool enabled;
  final Color color;
  final int width;
  final List<int> stopIds;
  final String created;
  final String updated;
  final List<Point> points;
  final bool active;
  final List<Schedule> schedule;

  Polyline get getPolyline => Polyline(
        polylineId: PolylineId(name),
        color: color,
        width: 4,
        points: points.map((points) => points.getLatLng).toList(),
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

    data['points'] = points.map((v) => v.toJson()).toList();

    data['active'] = active;

    data['schedule'] = schedule.map((v) => v.toJson()).toList();

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
