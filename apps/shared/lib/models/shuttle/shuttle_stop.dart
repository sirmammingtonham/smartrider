import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShuttleStop {
  int? id;
  double? latitude;
  double? longitude;
  String? created;
  String? updated;
  String? name;
  String? description;

  ShuttleStop(
      {this.id,
      this.latitude,
      this.longitude,
      this.created,
      this.updated,
      this.name,
      this.description});

  LatLng get getLatLng => LatLng(latitude!, longitude!);

  ShuttleStop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    created = json['created'];
    updated = json['updated'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created'] = created;
    data['updated'] = updated;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
