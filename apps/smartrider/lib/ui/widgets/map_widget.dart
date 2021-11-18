// ui imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/util/consts/messages.dart';
import 'package:shared/util/multi_bloc_builder.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:sizer/sizer.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/ui/home.dart';
import 'package:smartrider/ui/widgets/legend.dart';
import 'package:smartrider/ui/widgets/saferide_status_widgets.dart'
    as saferide_widgets;

import 'package:smartrider/ui/widgets/expandable_fab.dart';

final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

const CameraPosition kInitialPosition = CameraPosition(
  target: LatLng(42.729280, -73.679056),
  zoom: 15,
);

class SmartriderMap extends StatelessWidget {
  const SmartriderMap({Key? key}) : super(key: key);

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
        minMaxZoomPreference: const MinMaxZoomPreference(14, 18),
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
      );

  /// the expanding floating action button to switch views
  Widget viewFab(BuildContext context, IconData icon) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SizedBox(
      height: 143,
      width: 143,
      child: ExpandableFab(
        icon: icon,
        distance: 80,
        children: [
          ActionButton(
            tooltip: 'Bus View',
            onPressed: () => mapBloc
                .add(const MapViewChangeEvent(newView: MapView.kBusView)),
            isSelected: mapBloc.mapView == MapView.kBusView,
            icon: const Icon(Icons.directions_bus),
          ),
          ActionButton(
            tooltip: 'Shuttle View',
            onPressed: () => mapBloc
                .add(const MapViewChangeEvent(newView: MapView.kShuttleView)),
            isSelected: mapBloc.mapView == MapView.kShuttleView,
            icon: const Icon(Icons.airport_shuttle),
          ),
          ActionButton(
            tooltip: 'Saferide View',
            onPressed: () => mapBloc
                .add(const MapViewChangeEvent(newView: MapView.kSaferideView)),
            isSelected: mapBloc.mapView == MapView.kSaferideView,
            icon: const Icon(Icons.local_taxi),
          ),
        ],
      ),
    );
  }

  /// the button that focuses map to your location
  Widget locationButton(BuildContext context, SaferideState state) => Showcase(
        key: showcaseLocation,
        description: locationButtonShowcaseMessage,
        shapeBorder: const CircleBorder(),
        child: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<MapBloc>(context).scrollToCurrentLocation();
          },
          heroTag: 'scrollToLocButton',
          child: const Icon(
            Icons.gps_fixed,
          ),
        ),
      );

  /// the stack that places all the map components together
  Widget mapStack({
    required SaferideState saferideState,
    required Widget background,
    required Widget viewFab,
    required Widget locationButton,
  }) {
    late final double appBarHeight;

    switch (saferideState.runtimeType) {
      case SaferideSelectingState:
        appBarHeight = saferide_widgets.saferideSelectingHeight;
        break;
      case SaferideWaitingState:
        appBarHeight = saferide_widgets.saferideWaitingHeight;
        break;
      case SaferidePickingUpState:
        appBarHeight = saferide_widgets.saferidePickingUpHeight;
        break;
      case SaferideCancelledState:
        appBarHeight = saferide_widgets.saferideCancelledHeight;
        break;
      case SaferideNoState:
      case SaferideDroppingOffState:
      default:
        appBarHeight = saferide_widgets.saferideDefaultHeight;
        break;
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        background,
        Positioned(
          right: 180,
          bottom: 350,
          child: Showcase(
            key: showcaseMap,
            title: mapShowcaseTitle,
            description: mapShowcaseMessage,
            child: const SizedBox(
              height: 400,
              width: 300,
            ),
          ),
        ),
        Positioned(left: 12, bottom: appBarHeight + 20, child: const Legend()),
        Positioned(right: 12, bottom: appBarHeight + 90, child: viewFab),
        Positioned(right: 12, bottom: appBarHeight + 20, child: locationButton)
      ],
    );
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          case MapLoadedState:
            return mapStack(
              saferideState: saferideState,
              background: map(context, mapState),
              viewFab: viewFab(context, Icons.layers),
              locationButton: locationButton(context, saferideState),
            );
          case MapErrorState:
            FirebaseCrashlytics.instance.recordError(
              Exception('map_widget errored'),
              null,
              reason: 'map_widget errored',
            );
            return mapStack(
              saferideState: saferideState,
              background: Center(
                child: Text((mapState as MapErrorState).error.toString()),
              ),
              viewFab: viewFab(context, Icons.layers),
              locationButton: locationButton(context, saferideState),
            );
          default:
            FirebaseCrashlytics.instance.recordError(
              Exception('map_widget is broken'),
              null,
              reason: 'map_widget is broken (fatal)',
              fatal: true,
            );
            return const Center(
              child: Text('ERROR IN MAP BLOC'),
            );
        }
      },
    );
  }
}
