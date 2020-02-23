// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

// ui imports
import 'package:flutter/material.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;


final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.720779, -73.698129),
  northeast: const LatLng(42.739179, -73.659123),
);

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

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
    _mapStyle = string;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String> _getFileData(String path) async {
  //   return await rootBundle.loadString(path);
  // }

  // void _setMapStyle(String mapStyle) {
  //   setState(() {
  //     _nightMode = true;
  //     _controller.setMapStyle(mapStyle);
  //   });
  // }

  // Widget _nightModeToggler() {
  //   if (!_isMapCreated) {
  //     return null;
  //   }
  //   return FlatButton(
  //     child: Text('${_nightMode ? 'disable' : 'enable'} night mode'),
  //     onPressed: () {
  //       if (_nightMode) {
  //         setState(() {
  //           _nightMode = false;
  //           _controller.setMapStyle(null);
  //         });
  //       } else {
  //         _getFileData('assets/night_mode.json').then(_setMapStyle);
  //       }
  //     },
  //   );
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
    });
  }
}