import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleRoute {
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

  Polyline get getPolyline => Polyline(
        polylineId: PolylineId(this.name!),
        color: this.color!,
        width: 4,
        points: this.points!.map((points) => points.getLatLng).toList(),
      );

  ShuttleRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    enabled = json['enabled'];
    color = Color(int.parse(json['color'].toString().replaceAll('#', '0xff')));
    width = json['width'];
    stopIds = json['stop_ids'].cast<int>();
    created = json['created'];
    updated = json['updated'];
    if (json['points'] != null) {
      points = [];
      json['points'].forEach((dynamic v) {
        points!.add(new Point.fromJson(v));
      });
    }
    active = json['active'];
    if (json['schedule'] != null) {
      schedule = [];
      json['schedule'].forEach((dynamic v) {
        schedule!.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['enabled'] = this.enabled;
    data['color'] = this.color;
    data['width'] = this.width;
    data['stop_ids'] = this.stopIds;
    data['created'] = this.created;
    data['updated'] = this.updated;
    if (this.points != null) {
      data['points'] = this.points!.map((v) => v.toJson()).toList();
    }
    data['active'] = this.active;
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Point {
  double? latitude;
  double? longitude;

  Point({this.latitude, this.longitude});

  LatLng get getLatLng => LatLng(latitude!, longitude!);

  Point.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Schedule {
  int? id;
  int? routeId;
  int? startDay;
  String? startTime;
  int? endDay;
  String? endTime;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['route_id'] = this.routeId;
    data['start_day'] = this.startDay;
    data['start_time'] = this.startTime;
    data['end_day'] = this.endDay;
    data['end_time'] = this.endTime;
    return data;
  }
}
