// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// parsing imports
import 'package:flutter/services.dart' show rootBundle;

// bloc imports
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/shuttle/shuttle_bloc.dart';
import 'package:smartrider/data/models/shuttle/shuttle_stop.dart';

// data imports
import 'package:smartrider/util/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // maps of all possible elements we can draw (so ppl can toggle them through settings)
  Map<String, List<Marker>> _markerMap = <String, List<Marker>>{};
  Map<String, Polyline> _busPolylines = <String, Polyline>{};
  Map<String, Polyline> _shuttlePolylines = <String, Polyline>{};
  // the actual elements that we are drawing at a given time
  Set<Polyline> _currentPolylines = <Polyline>{};
  Set<Marker> _currentMarkers = <Marker>{};

  BitmapDescriptor shuttleIcon, busIcon;

  Future<void> _initMapElements() async {
    // Map<int, Marker> shuttleMarkers = {};
    // BitmapDescriptor shuttleIcon, busIcon;

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/markers/2.0x/marker_shuttle.png')
        .then((onValue) {
      shuttleIcon = onValue;
      // rootBundle.loadString('assets/shuttle_jsons/stops.json').then((string) {
      //   var data = json.decode(string);
      //   data.forEach((stop) {
      //     LatLng position = LatLng(stop['latitude'], stop['longitude']);
      //     shuttleMarkers[stop['id']] = Marker(
      //         icon: shuttleIcon,
      //         infoWindow: InfoWindow(title: stop['name']),
      //         markerId: MarkerId(stop['id'].toString()),
      //         position: position,
      //         onTap: () {
      //           _controller.animateCamera(
      //             CameraUpdate.newCameraPosition(
      //                 CameraPosition(target: position, zoom: 18, tilt: 50)),
      //           );
      //         });
      //   });
      // });
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/markers/2.0x/marker_bus.png')
        .then((onValue) {
      busIcon = onValue;
      // busStopMap.forEach((String routeName, List<List<String>> stopList) {
      //   List<Marker> m = [];
      //   stopList.forEach((stopData) {
      //     var position =
      //         LatLng(double.parse(stopData[1]), double.parse(stopData[2]));
      //     m.add(Marker(
      //         icon: busIcon,
      //         infoWindow: InfoWindow(title: stopData[0]),
      //         markerId: MarkerId(stopData[3]),
      //         position: position,
      //         onTap: () {
      //           _controller.animateCamera(
      //             CameraUpdate.newCameraPosition(
      //                 CameraPosition(target: position, zoom: 18, tilt: 50)),
      //           );
      //         }));
      //     _markerMap[routeName] = m;
      //   });
      // });
    });

    // String string =
    //     await rootBundle.loadString('assets/shuttle_jsons/routes.json');
    // var data = json.decode(string);
    // data.forEach((route) {
    //   print(route);
    //   String name = route['name'];
    //   PolylineId id = PolylineId(name);
    //   List<LatLng> points = [];
    //   route['points'].forEach((point) {
    //     points.add(LatLng(point['latitude'], point['longitude']));
    //   });
    //   Polyline line = Polyline(
    //     polylineId: id,
    //     color: Color(int.parse('ff' + route['color'], radix: 16)),
    //     width: route['width'],
    //     points: points,
    //   );
    //   _markerMap[name] = List<Marker>();
    //   print(route['stop_ids']);
    //   route['stop_ids'].forEach((var id) {
    //     _markerMap[name].add(shuttleMarkers[id]);
    //   });
    //   _shuttlePolylines[name] = line;
    // });

    // final busLineColors = [
    //   Colors.cyan,
    //   Colors.pink,
    //   Colors.lightGreen,
    // ];

    // final busIdentifiers = [
    //   "87Route",
    //   "286Route",
    //   "289Route",
    // ];

    // busPolylines.asMap().forEach((int idx, List<List<double>> rawLine) {
    //   PolylineId id = PolylineId(busIdentifiers[idx]);
    //   List<LatLng> linePoints = List<LatLng>();
    //   rawLine.forEach((pair) {
    //     linePoints.add(LatLng(pair[0], pair[1]));
    //   });
    //   Polyline busLine = Polyline(
    //     polylineId: id,
    //     patterns: <PatternItem>[PatternItem.dash(50), PatternItem.gap(50)],
    //     color: busLineColors[idx],
    //     width: 5,
    //     zIndex: 0,
    //     points: linePoints,
    //   );
    //   _busPolylines[busIdentifiers[idx]] = busLine;
    // });

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

    // BlocProvider.of<ShuttleBloc>(context).add(ShuttleInitDataRequested());

    _initMapElements().then((_) {
      // setPolylines();
      BlocProvider.of<ShuttleBloc>(context).add(ShuttleInitDataRequested());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Marker _stopToMarker(ShuttleStop stop) {
    return Marker(
      icon: shuttleIcon,
      infoWindow: InfoWindow(title: stop.name),
      markerId: MarkerId(stop.id.toString()),
      position: stop.getLatLng,
      onTap: () {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: stop.getLatLng, zoom: 18, tilt: 50)),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (_controller != null) {
      if (isDark) {
        _controller.setMapStyle(_darkMapStyle);
      } else {
        _controller.setMapStyle(_lightMapStyle);
      }
    }
    return BlocBuilder<ShuttleBloc, ShuttleState>(
      builder: (context, state) {
        if (state is ShuttleInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ShuttleLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ShuttleLoaded) {
          _currentPolylines =
              state.routes.map((route) => route.getPolyline).toSet();
          _currentMarkers = state.stops.map((stop) => _stopToMarker(stop)).toSet();

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
            // onCameraMove: _updateCameraPosition,
            polylines: _currentPolylines,
            markers: _currentMarkers,
            mapType: _mapType,
          );

          return MapUI(googleMap: googleMap);
        } else if (state is ShuttleUpdateRequested) {
          return Center();
        }
        else {
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

  // function called after settings to rebuild what elements we draw
  // ( might have to redo this to make use of the "visible"
  // property of the markers and polylines for performance reasons )
  void setPolylines() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    _currentPolylines.clear();
    _currentMarkers.clear();

    if (sharedPrefs.getBool('87Route') ?? true) {
      _currentPolylines.add(_busPolylines['87Route']);
      _currentMarkers.addAll(_markerMap['87Route']);
    }
    if (sharedPrefs.getBool('286Route') ?? true) {
      _currentPolylines.add(_busPolylines['286Route']);
      _currentMarkers.addAll(_markerMap['286Route']);
    }
    if (sharedPrefs.getBool('289Route') ?? true) {
      _currentPolylines.add(_busPolylines['289Route']);
      _currentMarkers.addAll(_markerMap['289Route']);
    }

    if (sharedPrefs.getBool('westRoute') ?? true) {
      _currentPolylines.add(_shuttlePolylines['NEW West Route']);
      _currentMarkers.addAll(_markerMap['NEW West Route']);
    }
    if (sharedPrefs.getBool('southRoute') ?? true) {
      _currentPolylines.add(_shuttlePolylines['NEW South Route']);
      _currentMarkers.addAll(_markerMap['NEW South Route']);
    }
    if (sharedPrefs.getBool('northRoute') ?? true) {
      _currentPolylines.add(_shuttlePolylines['NEW North Route']);
      _currentMarkers.addAll(_markerMap['NEW North Route']);
    }
    if (sharedPrefs.getBool('weekendExpress') ?? true) {
      _currentPolylines.add(_shuttlePolylines['Weekend Express']);
      _currentMarkers.addAll(_markerMap['Weekend Express']);
    }

    setState(() {});
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
