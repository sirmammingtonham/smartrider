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

  Widget viewFab(BuildContext context, IconData icon) => SizedBox(
        height: 16.h,
        width: 16.h,
        child: ExpandableFab(
          // TODO: color of selected one should be different
          icon: icon,
          distance: 19.w,
          children: [
            ActionButton(
              tooltip: 'Bus View',
              onPressed: () => BlocProvider.of<MapBloc>(context)
                  .add(MapViewChangeEvent(newView: MapView.kBusView)),
              icon: const Icon(Icons.directions_bus),
            ),
            ActionButton(
              tooltip: 'Shuttle View',
              onPressed: () => BlocProvider.of<MapBloc>(context)
                  .add(MapViewChangeEvent(newView: MapView.kShuttleView)),
              icon: const Icon(Icons.airport_shuttle),
            ),
            ActionButton(
              tooltip: 'Saferide View',
              onPressed: () => BlocProvider.of<MapBloc>(context)
                  .add(MapViewChangeEvent(newView: MapView.kSaferideView)),
              icon: const Icon(Icons.local_taxi),
            ),
          ],
        ),
      );

  Widget mapUI(
      {required BuildContext context,
      required SaferideState saferideState,
      required MapLoadedState mapState}) {
    Widget map;
    Widget? viewButton;
    Widget locationButton = Positioned(
      right: 20.0,
      bottom: saferideState is SaferideSelectingState ? 160.0 : 120.0,
      child: Showcase(
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
          )),
    );

    map = GoogleMap(
      onMapCreated: (controller) {
        BlocProvider.of<MapBloc>(context).updateController(context, controller);
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
      polylines: mapState is MapLoadedState ? mapState.polylines : {},
      markers: mapState is MapLoadedState ? mapState.markers : {},
      zoomControlsEnabled: false,
      onCameraMove: (position) {
        BlocProvider.of<MapBloc>(context)
            .add(MapMoveEvent(zoomLevel: position.zoom));
      },
      mapType: MapType.normal,
    );

    if (saferideState is SaferideInitialState ||
        saferideState is SaferideNoState) {
      viewButton = Positioned(
        right: 20.0,
        bottom: 190.0,
        child: Showcase(
          key: showcaseViewChange,
          description: VIEW_CHANGE_BUTTON_SHOWCASE_MESSAGE,
          shapeBorder: CircleBorder(),
          child: viewFab(context, Icons.layers),
        ),
      );
    }

    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      map,
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
      Legend(),
      viewButton ?? Container(),
      locationButton
    ]);
  }

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
              return mapUI(
                  context: context,
                  saferideState: saferideState,
                  mapState: mapState as MapLoadedState);
            case MapErrorState:
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
