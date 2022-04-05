import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleStop {
  ShuttleStop({this.coordinate, this.name, this.id});

  ShuttleStop.fromJson(Map<String, dynamic> json) {
    coordinate = json['coordinate'] != null
        ? Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>)
        : null;
    name = json['name'] as String;
    id = json['name'] as String;
  }

  Coordinate? coordinate;
  String? name;
  String? id;

  LatLng get getLatLng => 
  LatLng((coordinate?.latitude)!, (coordinate?.longitude)!);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coordinate != null) {
      data['coordinate'] = coordinate!.toJson();
    }
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class Coordinate {
  Coordinate({this.longitude, this.latitude});

  Coordinate.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'] as double;
    latitude = json['latitude'] as double;
  }

  double? longitude;
  double? latitude;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
