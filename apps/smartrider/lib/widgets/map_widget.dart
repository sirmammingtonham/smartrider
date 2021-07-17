// ui imports
import 'package:flutter/material.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:shared/util/messages.dart';
import 'package:shared/util/multi_bloc_builder.dart';

import 'package:smartrider/pages/home.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/widgets/legend.dart';
import 'package:sizer/sizer.dart';
import 'custom_widgets/expandable_fab.dart';

final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

final CameraPosition kInitialPosition = const CameraPosition(
  target: LatLng(42.729280, -73.679056),
  zoom: 15.0,
);

class SmartriderMap extends StatelessWidget {
  const SmartriderMap();

  /// the google map (background of stack)
  Widget map(BuildContext context, MapState state) => GoogleMap(
        onMapCreated: (controller) {
          BlocProvider.of<MapBloc>(context)
              .updateController(context, controller);
        },
        initialCameraPosition: kInitialPosition,
        compassEnabled: false,
        mapToolbarEnabled: false,
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
        polylines: state is MapLoadedState ? state.polylines : {},
        markers: state is MapLoadedState ? state.markers : {},
        zoomControlsEnabled: false,
        onCameraMove: (position) {
          BlocProvider.of<MapBloc>(context)
              .add(MapMoveEvent(zoomLevel: position.zoom));
        },
        mapType: MapType.normal,
      );

  /// the expanding floating action button to switch views
  Widget viewFab(BuildContext context, IconData icon) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SizedBox(
      height: 16.h,
      width: 16.h,
      child: ExpandableFab(
        icon: icon,
        distance: 19.w,
        children: [
          ActionButton(
            tooltip: 'Bus View',
            onPressed: () =>
                mapBloc.add(MapViewChangeEvent(newView: MapView.kBusView)),
            isSelected: mapBloc.mapView == MapView.kBusView,
            icon: Icon(Icons.directions_bus),
          ),
          ActionButton(
            tooltip: 'Shuttle View',
            onPressed: () =>
                mapBloc.add(MapViewChangeEvent(newView: MapView.kShuttleView)),
            isSelected: mapBloc.mapView == MapView.kShuttleView,
            icon: Icon(Icons.airport_shuttle),
          ),
          ActionButton(
            tooltip: 'Saferide View',
            onPressed: () =>
                mapBloc.add(MapViewChangeEvent(newView: MapView.kSaferideView)),
            isSelected: mapBloc.mapView == MapView.kSaferideView,
            icon: Icon(Icons.local_taxi),
          ),
        ],
      ),
    );
  }

  /// the button that focuses map to your location
  Widget locationButton(BuildContext context, SaferideState state) => Showcase(
        key: showcaseLocation,
        description: LOCATION_BUTTON_SHOWCASE_MESSAGE,
        shapeBorder: CircleBorder(),
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
          heroTag: "scrollToLocButton",
        ),
      );

  /// the stack that places all the map components together
  Widget mapStack(
          {required SaferideState state,
          required Widget background,
          required Widget viewFab,
          required Widget locationButton}) =>
      Stack(alignment: Alignment.topCenter, children: <Widget>[
        background,
        Positioned(
          right: 180,
          bottom: 350,
          child: Showcase(
              key: showcaseMap,
              title: MAP_SHOWCASE_TITLE,
              description: MAP_SHOWCASE_MESSAGE,
              child: SizedBox(
                height: 400,
                width: 300,
              )),
        ),
        Positioned(left: 20.0, bottom: 120.0, child: Legend()),
        Positioned(
            right: 20.0,
            bottom: state is SaferideSelectingState ? 240.0 : 190.0,
            child: viewFab),
        Positioned(
            right: 20.0,
            bottom: state is SaferideSelectingState ? 160.0 : 120.0,
            child: locationButton)
      ]);

  @override
  Widget build(BuildContext context) {
    return MultiBlocBuilder(
        blocs: [
          BlocProvider.of<SaferideBloc>(context),
          BlocProvider.of<MapBloc>(context)
        ],
        builder: (context, states) {
          final saferideState = states.get<SaferideState>();
          final mapState = states.get<MapState>();

          switch (mapState.runtimeType) {
            case MapLoadingState:
              return Center(
                child: CircularProgressIndicator(),
              );
            case MapLoadedState:
              return mapStack(
                  state: saferideState,
                  background: map(context, mapState),
                  viewFab: viewFab(context, Icons.layers),
                  locationButton: locationButton(context, saferideState));
            case MapErrorState:
              // TODO: crashlytics
              return mapStack(
                  state: saferideState,
                  background: Container(
                    child: Center(
                      child: Text((mapState as MapErrorState).error.toString()),
                    ),
                  ),
                  viewFab: viewFab(context, Icons.layers),
                  locationButton: locationButton(context, saferideState));
            default:
              // TODO: crashlytics
              return Container(
                child: Center(
                  child: Text('ERROR IN MAP BLOC'),
                ),
              );
          }
        });
  }
}
