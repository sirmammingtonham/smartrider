// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

// ui imports
import 'package:flutter/material.dart';
// import 'package:flutter_load_local_json/stops.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'dart:convert';

// map imports
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;



final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.720779, -73.698129),
  northeast: const LatLng(42.739179, -73.659123),
);
const LatLng SOURCE_LOCATION = LatLng(42.73029109316892, -73.67655873298646);
const LatLng DEST_LOCATION = LatLng(42.73154808884768, -73.68611276149751);

//var json =

class ShuttleMap extends StatefulWidget {
  const ShuttleMap();

  @override
  State<StatefulWidget> createState() => ShuttleMapState();
}

class ShuttleMapState extends State<ShuttleMap> {
  ShuttleMapState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(42.729280, -73.679056),
    zoom: 15.0,
  );

  CameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  bool _isMoving = false;
  bool _compassEnabled = true;
  bool _mapToolbarEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds(rpiBounds);
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference(14.0, 18.0);
  MapType _mapType = MapType.normal;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _indoorViewEnabled = true;
  bool _myLocationEnabled = true;
  bool _myTrafficEnabled = false;
  bool _myLocationButtonEnabled = true;
  GoogleMapController _controller;
  bool _nightMode = false;
  String _mapStyle;

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;
  String googleAPIKey = "AIzaSyDYWcuecs539zm-vuUBxKhR7rEqoFPa_Eg";

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
    _mapStyle = string;
    });
    rootBundle.loadString('assets/shuttle_jsons/stops.json').then((string) {
      var data = json.decode(string);
      data.forEach( (stop) {
        markers.add(Marker(
          markerId: MarkerId(stop['id'].toString()),
          position: LatLng(stop['latitude'], stop['longitude'])
        ));
      });
    });
    print(markers);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String> _getFileData(String path) async {
  //   return await rootBundle.loadString(path);
  // }


  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: _compassEnabled,
      mapToolbarEnabled: _mapToolbarEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      mapType: _mapType,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      indoorViewEnabled: _indoorViewEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      trafficEnabled: _myTrafficEnabled,
      onCameraMove: _updateCameraPosition,

      polylines: Set<Polyline>.of(polylines.values),
      markers: markers,
    );

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        // Actual map
        googleMap,

        // Location Button
        Positioned(
            right: 20.0,
            bottom: 120.0,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _scrollToLocation,
              backgroundColor: Colors.white,
            ),
          ),
      ]
    );
  }

  void _scrollToLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var loc = LatLng(currentLocation.latitude, currentLocation.longitude);

    if (rpiBounds.contains(loc)) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: loc,
            // tilt: 30.0,
            zoom: 17.0,
          ),
        ),
      );
    }
    else {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: LatLng(42.729280, -73.679056),
            // tilt: 30.0,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
      print(_mapStyle);
      _controller.setMapStyle(_mapStyle);

      setMapPins();
      setPolylines();
    });
  }


  void setMapPins() {
    setState(() {
      // source pin
      // markers.add(Marker(
      //     markerId: MarkerId('sourcePin'),
      //     position: SOURCE_LOCATION));
      // // destination pin
      // markers.add(Marker(
      //     markerId: MarkerId('destPin'),
      //     position: DEST_LOCATION));
    });
  }

  void setPolylines() {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.73029109316892, -73.67655873298646));
    points.add(_createLatLng(42.73154808884768, -73.68611276149751));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}