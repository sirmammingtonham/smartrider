// ui imports
import 'package:flutter/material.dart';

// map imports
import 'package:mapbox_gl/mapbox_gl.dart';

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

  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = true;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds(rpiBounds);
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference(14.0, 18.0);
  String _styleString = MapboxStyles.LIGHT;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  // bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.Tracking;

  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: _compassEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleString,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {
        print("${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        List features = await mapController.queryRenderedFeatures(point, [],null);
        if (features.length>0) {
          print(features[0]);
        }
      },
      onCameraTrackingDismissed: () {
        this.setState(() {
          _myLocationTrackingMode = MyLocationTrackingMode.None;
        });
      }
    );

    return mapboxMap;
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();
  }
}