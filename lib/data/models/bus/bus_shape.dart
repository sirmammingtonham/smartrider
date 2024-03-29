import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

const BUS_COLORS = {
  '87-185': Colors.purple,
  '286-185': Colors.deepOrange,
  '289-185': Colors.lightBlue,
  '288-185': Colors.green,
};

const BUS_WIDTHS = {
  '87-185': 6,
  '286-185': 5,
  '289-185': 4,
  '288-185': 3,
};
const BUS_INDICIES = {
  '87-185': 0,
  '286-185': 1,
  '289-185': 2,
  '288-185': 3,
};

class BusShape {
  String routeId;
  List<List<LatLng>> coordinates;

  BusShape({this.routeId, this.coordinates});

  List<Polyline> get getPolylines {
    int i = 0;
    return coordinates
        .map((linestring) => Polyline(
            polylineId: PolylineId('${this.routeId}${i++}'),
            color: BUS_COLORS[this.routeId].withAlpha(255),
            width: BUS_WIDTHS[this.routeId],
            zIndex: BUS_INDICIES[this.routeId],
            // patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
            points: linestring))
        .toList();
  }
  
  BusShape.fromJson(Map<String, dynamic> json) {
    this.routeId = json['properties']['route_id'];
    this.coordinates = [];

    // check if single linestring or multi-linestring and handle differently
    if (json['type'] == 'LineString') {
      List<LatLng> linestring = [];
      json['coordinates'].forEach((p) {
        linestring.add(LatLng(p[1], p[0]));
      });
      coordinates.add(linestring);
    } else {
      json['coordinates'].forEach((l) {
        List<LatLng> linestring = [];
        l.forEach((p) {
          linestring.add(LatLng(p[1], p[0]));
        });
        coordinates.add(linestring);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['properties'] = {'route_id': this.routeId};
    data['coordinates'] = this.coordinates;
    return data;
  }
}
