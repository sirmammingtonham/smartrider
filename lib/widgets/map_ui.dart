// implementation imports
import 'dart:async';

// ui imports
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

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
  double currentZoom = 14.0;
  MapBloc mapBloc;
  GoogleMap googleMap;
  
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _isBus = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.add(MapInitEvent());
    const pollRefreshDelay = const Duration(seconds: 3); // update every 3 sec
    new Timer.periodic(
        pollRefreshDelay,
        (Timer t) => BlocProvider.of<MapBloc>(context)
            .add(MapUpdateEvent(zoomLevel: currentZoom)));
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
        _isLoading = true;
      } else if (state is MapLoadedState) {
        _polylines = state.polylines;
        _markers = state.markers;
        _isBus = state.isBus;
        _isLoading = false;
      } else {
        return Center(child: Text("error bruh"));
      }
      return ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CircularProgressIndicator(),
        color: Theme.of(context).backgroundColor,
        opacity: 0.7,
        child: MapUI(
          googleMap: GoogleMap(
            onMapCreated: (controller) {
              mapBloc.updateController(context, controller);
            },
            initialCameraPosition: kInitialPosition,
            compassEnabled: false,
            mapToolbarEnabled: true,
            cameraTargetBounds: CameraTargetBounds(rpiBounds),
            minMaxZoomPreference: MinMaxZoomPreference(14.0, 18.0),
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            indoorViewEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            trafficEnabled: false,
            polylines: _polylines,
            markers: _markers,
            zoomControlsEnabled: true,
            onCameraMove: (position) {
              currentZoom = position.zoom;
              mapBloc.add(MapMoveEvent(zoomLevel: currentZoom));
            },
            mapType: MapType.normal,
          ),
          isBus: _isBus,
          currentZoom: currentZoom,
        ),
      );
    });
  }
}

class MapUI extends StatelessWidget {
  const MapUI(
      {Key key,
      @required this.googleMap,
      @required this.isBus,
      @required this.currentZoom})
      : super(key: key);

  final GoogleMap googleMap;
  final bool isBus;
  final double currentZoom;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      // Actual map
      googleMap,

      Positioned(
        right: 20.0,
        bottom: 190.0,
        child: FloatingActionButton(
          child: Icon(
            isBus ? Icons.airport_shuttle : Icons.directions_bus,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : Theme.of(context).accentColor,
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.white70,
          onPressed: () {
            BlocProvider.of<MapBloc>(context)
                .add(MapTypeChangeEvent(zoomLevel: currentZoom));
            BlocProvider.of<ScheduleBloc>(context)
                .add(ScheduleTypeChangeEvent());
          },
          heroTag: "mapViewChangeButton",
        ),
      ),

      // Location Button
      Positioned(
        right: 10.0,
        bottom: 110.0,
        child: FloatingActionButton(
          splashColor: Theme.of(context).primaryColorDark,
          backgroundColor: Theme.of(context).accentColor,
          // hoverColor: Theme.of(context).primaryColorLight,
          // foregroundColor: Theme.of(context).errorColor,
          // focusColor: Theme.of(context).accentColor,
          child: Icon(
            Icons.near_me,
            size: 25.0,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            BlocProvider.of<MapBloc>(context).scrollToCurrentLocation();
          },
          heroTag: "scrollToLocButton",
        ),
      ),
    ]);
  }
}
