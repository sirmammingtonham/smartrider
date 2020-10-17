// implementation imports
import 'dart:async';

// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluster/fluster.dart';
import 'package:meta/meta.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';

// bloc imports
import 'package:smartrider/blocs/map/map_bloc.dart';

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
  double currentzoom; 
  MapBloc mapBloc;

  @override
  void initState() {
    super.initState();

    mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.add(MapInitEvent());
    const refreshDelay = const Duration(seconds: 2); // update every 3 sec
    new Timer.periodic(refreshDelay,
        (Timer t) => BlocProvider.of<MapBloc>(context).add(MapUpdateEvent(zoomlevel: currentzoom)));
  }

  @override
  void dispose() {
    mapBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (state is MapLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is MapLoadedState) {
        final GoogleMap googleMap = GoogleMap(
          onMapCreated: (controller){
              mapBloc.updateController(context, controller);
              },
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
          polylines: state.polylines,
          markers: state.markers,
          zoomControlsEnabled: true,
          onCameraMove: (position){
             currentzoom = position.zoom;
          },
          mapType: _mapType,
        );
        return MapUI(googleMap: googleMap);
      } else {
        return Center(child: Text("error bruh"));
      }
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
                : Colors.white70,
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
