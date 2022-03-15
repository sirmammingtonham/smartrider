import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleRoute {
  ShuttleRoute({this.coordinates, this.id});

  ShuttleRoute.fromJson(Map<String, dynamic> json, List<String?> stops) {
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      (json['coordinates'] as List<dynamic>).map((dynamic e) =>
      coordinates?.add
      (Coordinates.fromJson(e as Map<String, dynamic>)),);
    }

    stopIds = stops;
    // Hard coded because there is only one route, and ShuttleTracker API
    // no longer carries route names
    id = 'Main Route'; 
    // id = json['id'] as String?;
  }

  List<Coordinates>? coordinates;
  String? id;
  List<String?> stopIds = [];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }

  Color color = const Color(0xff000000);
  bool active = true;
  bool enabled = true;

  Polyline get getPolyline => Polyline(
        polylineId: PolylineId(id.toString()),
        color: color,
        width: 4,
        points: coordinates!.map((coord) => coord.getLatLng).toList(),
      );
}

class Coordinates {
  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
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


// Test code below

// void main() async {
//   final r = await http.get(Uri.parse("https://shuttletracker.app/routes"));
//   final response = json.decode(r.body);
//   final routeMap = response != null
//       ? <String, ShuttleRoute>{
//           for (final json in response)
//             (json as Map<String, dynamic>)['id'] as String:
//                 ShuttleRoute.fromJson(json)
//         }
//       : <String, ShuttleRoute>{};
//   print(routeMap);
// }
