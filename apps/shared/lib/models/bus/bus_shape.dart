import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

const busColors = {
  '87': Colors.purple,
  '286': Colors.deepOrange,
  '289': Colors.lightBlue,
  '288': Colors.green,
};

const busWidths = {
  '87': 6,
  '286': 5,
  '289': 4,
  '288': 3,
};
const busIndices = {
  '87': 0,
  '286': 1,
  '289': 2,
  '288': 3,
};

class BusShape {
  BusShape({this.routeId, this.coordinates});

  BusShape.fromJson(Map<String, dynamic> json) {
    routeId = (json['properties'] as Map<String, dynamic>)['route_id'];
    routeShortName = routeId!.substring(0, routeId!.indexOf('-'));
    coordinates = [];

    /// check if single linestring or multi-linestring and handle differently
    if (json['type'] == 'LineString') {
      final linestring = <LatLng>[];
      for (final point in json['coordinates'] as List) {
        linestring.add(LatLng((point as List)[1], point[0]));
      }
      coordinates!.add(linestring);
    } else {
      for (final line in json['coordinates'] as List) {
        final linestring = <LatLng>[];
        for (final point in line) {
          linestring.add(LatLng((point as List)[1], point[0]));
        }
        coordinates!.add(linestring);
      }
    }
  }

  String? routeId;
  String? routeShortName;
  List<List<LatLng>>? coordinates;

  List<Polyline> get getPolylines {
    var i = 0;
    return coordinates!
        .map((linestring) => Polyline(
            polylineId: PolylineId('$routeId${i++}'),
            color: busColors[routeShortName!]!.withAlpha(255),
            width: busWidths[routeShortName!]!,
            zIndex: busIndices[routeShortName!]!,
            // patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
            points: linestring))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['properties'] = {'route_id': routeId};
    data['coordinates'] = coordinates;
    return data;
  }
}
