// ui imports
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/util/multi_bloc_builder.dart';

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

  Widget mapUI(
      {@required BuildContext context,
      @required SaferideState saferideState,
      @required MapState mapState}) {

    if (mapState is MapErrorState) {
      // TODO: make it so there is an option to switch views in case only one is broken
      // so basically just keep the viewbutton
      return Center(
        child: Text('${mapState.message}'),
      );
    }

    Widget viewButton;
    Widget locationButton = Positioned(
      right: 20.0,
      bottom: saferideState is SaferideSelectionState ? 160.0 : 120.0,
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
    GoogleMap map = GoogleMap(
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
        child: FloatingActionButton(
          child: Icon(
            mapState is MapLoadedState && mapState.isBus
                ? Icons.airport_shuttle
                : Icons.directions_bus,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : Theme.of(context).accentColor,
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.white70,
          onPressed: () {
            BlocProvider.of<MapBloc>(context).add(MapTypeChangeEvent());
            BlocProvider.of<ScheduleBloc>(context)
                .add(ScheduleTypeChangeEvent());
          },
          heroTag: "mapViewChangeButton",
        ),
      );
    }

    return Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[map, viewButton ?? Container(), locationButton]);
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
          return ModalProgressHUD(
            inAsyncCall: mapState is MapLoadingState,
            progressIndicator: CircularProgressIndicator(),
            color: Theme.of(context).backgroundColor,
            opacity: 0.7,
            child: mapUI(
                context: context,
                saferideState: saferideState,
                mapState: mapState),
          );
        });
  }
}
