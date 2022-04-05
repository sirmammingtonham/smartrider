import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  BusShape({
    required this.routeId,
    required this.routeShortName,
    required this.coordinates,
  });

  factory BusShape.fromJson(Map<String, dynamic> json) {
    final routeId =
        (json['properties'] as Map<String, dynamic>)['route_id'] as String;
    final routeShortName = routeId.substring(0, routeId.indexOf('-'));
    final coordinates = <List<LatLng>>[];

    /// check if single linestring or multi-linestring and handle differently
    if (json['type'] == 'LineString') {
      final linestring = <LatLng>[];
      for (final p in json['coordinates'] as List) {
          final point = (p as List).cast<double>();
        linestring.add(LatLng(point[1], point[0]));
      }
      coordinates.add(linestring);
    } else {
      for (final line in json['coordinates'] as List) {
        final linestring = <LatLng>[];
        for (final p in line) {
          final point = (p as List).cast<double>();
          linestring.add(LatLng(point[1], point[0]));
        }
        coordinates.add(linestring);
      }
    }

    return BusShape(
      routeId: routeId,
      routeShortName: routeShortName,
      coordinates: coordinates,
    );
  }

  String routeId;
  String routeShortName;
  List<List<LatLng>> coordinates;

  List<Polyline> get getPolylines {
    var i = 0;
    return coordinates
        .map(
          (linestring) => Polyline(
            polylineId: PolylineId('$routeId${i++}'),
            color: busColors[routeShortName]!.withAlpha(255),
            width: busWidths[routeShortName]!,
            zIndex: busIndices[routeShortName]!,
            // patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
            points: linestring,
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['properties'] = {'route_id': routeId};
    data['coordinates'] = coordinates;
    return data;
  }
}
