import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class BusShape {
  String routeId;
  List<List<LatLng>> coordinates;

  BusShape({this.routeId, this.coordinates});

  BusShape.fromJson(Map<String, dynamic> json) {
    this.routeId = json['properties']['route_id'];
    this.coordinates = [];

    json['features'][0]['geometry']['coordinates'].forEach((l) {
      List<LatLng> linestring = [];
      l.forEach((p) {
        linestring.add(LatLng(p[1], p[0]));
      });
      coordinates.add(linestring);
    });
  }

  List<Polyline> get getPolylines {
    int i = 0;
    return coordinates
        .map((linestring) => Polyline(
            polylineId: PolylineId('${this.routeId}${i++}'),
            color: Colors.white.withAlpha(200),
            width: 4,
            patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
            points: linestring))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = this.routeId;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
