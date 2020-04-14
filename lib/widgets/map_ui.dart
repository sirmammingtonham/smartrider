// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

// ui imports
import 'package:flutter/material.dart';
import 'dart:convert';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

// data imports
import 'package:smartrider/util/data.dart';

final LatLngBounds rpiBounds = LatLngBounds(
  // southwest: const LatLng(42.720779, -73.698129),
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
  // northeast: const LatLng(42.739179, -73.659123),
);


class ShuttleMap extends StatefulWidget {
  ShuttleMap({Key key}) : super(key: key);
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
  bool _compassEnabled = false;
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
  bool _myLocationButtonEnabled = false;
  GoogleMapController _controller;           
  String _lightMapStyle;
  String _darkMapStyle;

  Set<Marker> markers = {};
  List<LatLng> westPoints = [];
  List<LatLng> southPoints = [];
  List<LatLng> northPoints = [];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  BitmapDescriptor shuttleIcon, busIcon;
  PolylineId selectedPolyline;

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/marker_shuttle.png').then((onValue) {
        shuttleIcon = onValue;
        rootBundle.loadString('assets/shuttle_jsons/stops.json').then((string) {
        var data = json.decode(string);
        data.forEach( (stop) {
          var position = LatLng(stop['latitude'], stop['longitude']);
          markers.add(Marker(
            icon: shuttleIcon,
            markerId: MarkerId(stop['id'].toString()),
            position: position,
            onTap: () {
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 18,
                    tilt: 50)  
                ),
              );
            }
          ));
        });
      });
    });

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/marker_bus.png').then((onValue) {
        busIcon = onValue;
        busStopLists.forEach((List<List<String>> stopList) {
        stopList.forEach((stopData) {
          var position = LatLng(double.parse(stopData[1]), double.parse(stopData[2]));
          markers.add(Marker(
            icon: busIcon,
            markerId: MarkerId(stopData[3]),
            position: position,
            onTap: () {
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 18,
                    tilt: 50)  
                ),
              );
            }
          ));
        });
      });
    });

    rootBundle.loadString('assets/map_styles/aubergine.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
      _lightMapStyle = string;
    });

    rootBundle.loadString('assets/shuttle_jsons/west.json').then((string) {
      var data = json.decode(string);
      data.forEach( (point) {
        westPoints.add(LatLng(point['latitude'], point['longitude']));
      });
    });

    rootBundle.loadString('assets/shuttle_jsons/south.json').then((string) {
      var data = json.decode(string);
      data.forEach( (point) {
        southPoints.add(LatLng(point['latitude'], point['longitude']));
      });
    });

    rootBundle.loadString('assets/shuttle_jsons/north.json').then((string) {
      var data = json.decode(string);
      data.forEach( (point) {
        northPoints.add(LatLng(point['latitude'], point['longitude']));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (_controller != null ) {
      if (isDark) {
          _controller.setMapStyle(_darkMapStyle);
      }
      else {
          _controller.setMapStyle(_lightMapStyle);
      }
    }


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
                color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : null,
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : null,
              onPressed: _scrollToCurrentLocation,
            ),
          ),
      ]
    );
  }

  void _scrollToCurrentLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var loc = LatLng(currentLocation.latitude, currentLocation.longitude);

    if (rpiBounds.contains(loc)) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: loc,
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
            zoom: 15.0,
          ),
        ),
      );
    }
  }
  void scrollToLocation(LatLng loc) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: loc,
          zoom: 18,
          tilt: 50)  
      ),
    );
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

      setPolylines();
    });
  }

  void setPolylines() {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    final busLineColors = [
      Colors.cyan,
      Colors.pink,
      Colors.lightGreen,
    ];

    busPolylines.asMap().forEach((int idx, List<List<double>> rawLine) {
      PolylineId buslineId = PolylineId('polyline_id_$_polylineIdCounter');
      _polylineIdCounter++;
      List<LatLng> linePoints = List<LatLng>();
      rawLine.forEach((pair) {
        linePoints.add(LatLng(pair[0],pair[1]));
      });
      Polyline busLine = Polyline(
        polylineId: buslineId,
        patterns: <PatternItem>[PatternItem.dash(50), PatternItem.gap(50)],
        color: busLineColors[idx],
        width: 5,
        points: linePoints,
      );
      polylines[buslineId] = busLine;
    });

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polylineWest = Polyline(
      polylineId: polylineId,
      color: Colors.orange,
      width: 5,
      points: westPoints,
    );

    final String polylineIdVal1 = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId1 = PolylineId(polylineIdVal1);

    final Polyline polylineSouth = Polyline(
      polylineId: polylineId1,
      color: Colors.blue,
      width: 5,
      points: southPoints,
    );

    final String polylineIdVal2 = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId2 = PolylineId(polylineIdVal2);

    final Polyline polylineNorth = Polyline(
      polylineId: polylineId2,
      color: Colors.purple,
      width: 5,
      points: northPoints,
    );

    // still need to add weekend polyline

    setState(() {
      polylines[polylineId] = polylineWest;
      polylines[polylineId1] = polylineSouth;
      polylines[polylineId2] = polylineNorth;
    });
  }
}