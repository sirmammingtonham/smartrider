import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

const BUS_COLORS = {
  '87': Colors.purple,
  '286': Colors.deepOrange,
  '289': Colors.lightBlue,
  '288': Colors.green,
};

const BUS_WIDTHS = {
  '87': 6,
  '286': 5,
  '289': 4,
  '288': 3,
};
const BUS_INDICIES = {
  '87': 0,
  '286': 1,
  '289': 2,
  '288': 3,
};

class BusShape {
  String? routeId;
  String? routeShortName;
  List<List<LatLng>>? coordinates;

  BusShape({this.routeId, this.coordinates});

  List<Polyline> get getPolylines {
    int i = 0;
    return coordinates!
        .map((linestring) => Polyline(
            polylineId: PolylineId('$routeId${i++}'),
            color: BUS_COLORS[routeShortName!]!.withAlpha(255),
            width: BUS_WIDTHS[routeShortName!]!,
            zIndex: BUS_INDICIES[routeShortName!]!,
            // patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
            points: linestring))
        .toList();
  }

  BusShape.fromJson(Map<String, dynamic> json) {
    routeId = json['properties']['route_id'];
    routeShortName = routeId!.substring(0, routeId!.indexOf('-'));
    coordinates = [];

    // check if single linestring or multi-linestring and handle differently
    if (json['type'] == 'LineString') {
      List<LatLng> linestring = [];
      json['coordinates'].forEach((dynamic p) {
        linestring.add(LatLng(p[1], p[0]));
      });
      coordinates!.add(linestring);
    } else {
      json['coordinates'].forEach((dynamic l) {
        List<LatLng> linestring = [];
        l.forEach((dynamic p) {
          linestring.add(LatLng(p[1], p[0]));
        });
        coordinates!.add(linestring);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['properties'] = {'route_id': routeId};
    data['coordinates'] = coordinates;
    return data;
  }
}
