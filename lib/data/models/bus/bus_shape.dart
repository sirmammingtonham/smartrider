import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class BusShape {
  String routeId;
  List<LatLng> coordinates;

  BusShape({this.routeId, this.coordinates});

  BusShape.fromJson(Map<String, dynamic> json) {
    this.routeId = json['properties']['route_id'];
    this.coordinates = [];

    json['features'][0]['geometry']['coordinates'].forEach((l) {
      l.forEach((p) {
        coordinates.add(LatLng(p[1], p[0]));
      });
    });
  }

  Polyline get getPolyline => Polyline(
      polylineId: PolylineId(this.routeId),
      color: Colors.white.withAlpha(200),
      width: 4,
      patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
      points: this.coordinates);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = this.routeId;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
