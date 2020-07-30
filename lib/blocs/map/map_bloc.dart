import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

part 'map_event.dart';
part 'map_state.dart';

final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController _controller;
  // final PrefsBloc prefsBloc;
  // StreamSubscription prefsBlocSubscription;

  /// MapBloc named constructor
  MapBloc() : super(MapInitializingState());
  // {
  //   prefsBlocSubscription = prefsBloc.listen((state) {
  //     if (state is PrefsSavedState) {

  //     }
  //   });
  // }

  @override
  Future<void> close() {
    // prefsBlocSubscription.cancel();
    return super.close();
  }

  /// non-state related functions
  GoogleMapController get getMapController => _controller;

  void scrollToCurrentLocation() async {
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
    } else {
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
          CameraPosition(target: loc, zoom: 18, tilt: 50)),
    );
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is MapInitialized) {
      this._controller = event.controller;
      yield MapControllerState(controller: this._controller);
    } else {
      yield MapErrorState();
    }
  }
}
