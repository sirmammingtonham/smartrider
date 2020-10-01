// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
//
import 'dart:async';
// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';

// parsing imports
import 'package:flutter/services.dart' show rootBundle;

// bloc imports
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/shuttle/shuttle_bloc.dart';
import 'package:smartrider/data/models/shuttle/shuttle_stop.dart';
import 'package:smartrider/data/models/shuttle/shuttle_update.dart';

final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

final CameraPosition kInitialPosition = const CameraPosition(
  target: LatLng(42.729280, -73.679056),
  zoom: 15.0,
);

final GlobalKey<ShuttleMapState> mapState = GlobalKey<ShuttleMapState>();

class ShuttleMap extends StatefulWidget {
  ShuttleMap({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ShuttleMapState();
}

class ShuttleMapState extends State<ShuttleMap> {
  ShuttleMapState();

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

  BitmapDescriptor shuttleStopIcon, busStopIcon;
  Map<int, BitmapDescriptor> shuttleUpdateIcons = new Map(); // maps id to image

  Future<void> _initMapElements() async {
    var config = ImageConfiguration();
    await BitmapDescriptor.fromAssetImage(
            config, 'assets/stop_markers/marker_shuttle.png')
        .then((onValue) {
      shuttleStopIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/stop_markers/marker_bus.png')
        .then((onValue) {
      busStopIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_red.png')
        .then((onValue) {
      shuttleUpdateIcons[22] = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_yellow.png')
        .then((onValue) {
      shuttleUpdateIcons[21] = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_blue.png')
        .then((onValue) {
      shuttleUpdateIcons[24] = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_orange.png')
        .then((onValue) {
      shuttleUpdateIcons[28] = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_white.png')
        .then((onValue) {
      shuttleUpdateIcons[-1] = onValue;
    });

    return;
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_styles/aubergine.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
      _lightMapStyle = string;
    });

    _initMapElements().then((_) {
      BlocProvider.of<ShuttleBloc>(context).add(ShuttleInitDataRequested());
    });
    const refreshDelay = const Duration(seconds: 3); // update every 3 sec
    new Timer.periodic(
        refreshDelay,
        (Timer t) => BlocProvider.of<ShuttleBloc>(context)
            .add(ShuttleUpdateRequested()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Marker _stopToMarker(ShuttleStop stop) {
    return Marker(
        icon: shuttleStopIcon,
        infoWindow: InfoWindow(title: stop.name),
        markerId: MarkerId(stop.id.toString()),
        position: stop.getLatLng,
        onTap: () {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: stop.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  Marker _updateToMarker(ShuttleUpdate update) {
    // real time update shuttles
    //  print(update.routeId);
    return Marker(
        icon: shuttleUpdateIcons[shuttleUpdateIcons.containsKey(update.routeId)
            ? update.routeId
            : -1],
        infoWindow:
            InfoWindow(title: "Shuttle ID: ${update.vehicleId.toString()}"),
        markerId: MarkerId(update.id.toString()),
        position: update.getLatLng,
        rotation: update.heading,
        anchor: Offset(0.5, 0.5),
        onTap: () {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: update.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (_controller != null) {
      _controller.setMapStyle(isDark ? _darkMapStyle : _lightMapStyle);
    }
    return BlocBuilder<ShuttleBloc, ShuttleState>(
      builder: (context, state) {
        if (state is ShuttleInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ShuttleLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ShuttleLoaded) {
          return BlocBuilder<PrefsBloc, PrefsState>(
            builder: (prefContext, prefState) {
              if (prefState is PrefsLoadedState) {
                Set<Polyline> _currentPolylines = <Polyline>{};
                Set<Marker> _currentMarkers = <Marker>{};
                var polylineMap = {
                  for (var route in state.routes) route.name: route
                };
                var markerMap = {
                  for (var stop in state.stops) stop.id: _stopToMarker(stop)
                };
                for (var update in state.updates) {
                  Marker m = _updateToMarker(update);
                  _currentMarkers.add(m);
                }

                prefState.prefs.getEnabledShuttles.forEach((key) {
                  var curRoute = polylineMap[key];
                  _currentPolylines.add(curRoute.getPolyline);
                  curRoute.stopIds.forEach((id) {
                    _currentMarkers.add(markerMap[id]);
                  });
                });
                final GoogleMap googleMap = GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: kInitialPosition,
                  compassEnabled: _compassEnabled,
                  mapToolbarEnabled: _mapToolbarEnabled,
                  cameraTargetBounds: _cameraTargetBounds,
                  minMaxZoomPreference: _minMaxZoomPreference,
                  rotateGesturesEnabled: _rotateGesturesEnabled,
                  scrollGesturesEnabled: _scrollGesturesEnabled,
                  tiltGesturesEnabled: _tiltGesturesEnabled,
                  zoomGesturesEnabled: _zoomGesturesEnabled,
                  indoorViewEnabled: _indoorViewEnabled,
                  myLocationEnabled: _myLocationEnabled,
                  myLocationButtonEnabled: _myLocationButtonEnabled,
                  trafficEnabled: _myTrafficEnabled,
                  polylines: _currentPolylines,
                  markers: _currentMarkers,
                  mapType: _mapType,
                );
                return MapUI(googleMap: googleMap);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Center(child: Text("error bruh"));
        }
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      BlocProvider.of<MapBloc>(context)
          .add(MapInitialized(controller: _controller));
    });
  }
}

class MapUI extends StatelessWidget {
  const MapUI({
    Key key,
    @required this.googleMap,
  }) : super(key: key);

  final GoogleMap googleMap;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      // Actual map
      googleMap,

      // Location Button
      Positioned(
        right: 20.0,
        bottom: 120.0,
        child: FloatingActionButton(
          child: Icon(
            Icons.gps_fixed,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : null,
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : null,
          onPressed: () {
            BlocProvider.of<MapBloc>(context).scrollToCurrentLocation();
          },
        ),
      ),
    ]);
  }
}
