import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  String address;
  LatLng latLng;
  String display;

  LocationData({this.address, this.latLng, this.display});

  LocationData.fromDocument(data) {
    this.address = data['address'];
    final GeoPoint geopoint = data['lat_lng'];
    this.latLng = LatLng(geopoint.latitude, geopoint.longitude);
    this.display = data['display'];
  }
}
