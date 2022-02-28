import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShuttleUpdate {
  ShuttleUpdate({this.id, this.location});

  ShuttleUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    location = json['location'] != null
        ? Location.fromJson(json['location'] as Map<String, dynamic>)
        : null;
  }

  int? id;
  Location? location;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }

}

class Location {
  Location({this.date, this.id, this.type, this.coordinate});

  Location.fromJson(Map<String, dynamic> json) {
    date = json['date'] as String?;
    id = json['id'] as String?;
    type = json['type'] as String?;
    coordinate = json['coordinate'] != null
        ? Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>)
        : null;
  }

  String? date;
  String? id;   // location id, can be ignored
  String? type; // "user" indicate crowd source, "system" indicates gps.
  Coordinate? coordinate;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['id'] = id;
    data['type'] = type;
    if (coordinate != null) {
      data['coordinate'] = coordinate!.toJson();
    }
    return data;
  }
}

class Coordinate {
  Coordinate({this.latitude, this.longitude});

  Coordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] as double?;
    longitude = json['longitude'] as double?;
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
//   final r = await http.get(Uri.parse("https://shuttletracker.app/buses"));
//   final response = json.decode(r.body);
//   final updatesList = response != null
//         ? response
//             .map<ShuttleUpdate>(
//               (dynamic json) =>
//                   ShuttleUpdate.fromJson(json as Map<String, dynamic>),
//             )
//             .toList()
//         : <ShuttleUpdate>[];
//   updatesList.forEach((element) => print(element.id)); 
// }
