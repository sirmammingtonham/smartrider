// implementation imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// bloc imports
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

// repository imports
import 'package:smartrider/data/repository/bus_repository.dart';
import 'package:smartrider/data/repository/shuttle_repository.dart';

// model imports
import 'package:smartrider/data/models/shuttle/shuttle_route.dart';
import 'package:smartrider/data/models/shuttle/shuttle_stop.dart';
import 'package:smartrider/data/models/shuttle/shuttle_update.dart';

import 'package:smartrider/data/models/bus/bus_route.dart';
import 'package:smartrider/data/models/bus/bus_shape.dart';
import 'package:smartrider/data/models/bus/bus_stop.dart';
import 'package:smartrider/data/models/bus/bus_vehicle_update.dart';

part 'map_event.dart';
part 'map_state.dart';

final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

class MapBloc extends Bloc<MapEvent, MapState> {
  final ShuttleRepository shuttleRepo;
  final BusRepository busRepo;

  final PrefsBloc prefsBloc;
  StreamSubscription prefsStream;
  Map<String, bool> _enabledShuttles = {};

  GoogleMapController _controller;

  Map<String, BusRoute> busRoutes = {};
  List<BusShape> shapes = [];
  List<BusStop> busStops = [];
  List<BusVehicleUpdate> busUpdates = [];

  Map<String, ShuttleRoute> shuttleRoutes = {};
  List<ShuttleStop> shuttleStops = [];
  List<ShuttleUpdate> shuttleUpdates = [];

  BitmapDescriptor shuttleStopIcon, busStopIcon;
  Map<int, BitmapDescriptor> shuttleUpdateIcons = new Map(); // maps id to image

  bool isLoading = true;

  String _lightMapStyle;
  String _darkMapStyle;

  /// MapBloc named constructor
  MapBloc(
      {@required this.shuttleRepo,
      @required this.busRepo,
      @required this.prefsBloc})
      : super(MapLoadingState()) {
    rootBundle.loadString('assets/map_styles/aubergine.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
      _lightMapStyle = string;
    });

    prefsStream = prefsBloc.listen((prefsState) {
      if (prefsState is PrefsLoadedState) {
        _enabledShuttles = prefsState.shuttles;
        if (_controller != null) {
          _controller.setMapStyle(prefsState.theme.brightness == Brightness.dark
              ? _darkMapStyle
              : _lightMapStyle);
        }
      }
    });
  }

  @override
  Future<void> close() {
    prefsStream.cancel();
    return super.close();
  }

  updateController(BuildContext context, GoogleMapController controller) {
    _controller = controller;
    _controller.setMapStyle(Theme.of(context).brightness == Brightness.dark
        ? _darkMapStyle
        : _lightMapStyle);
  }

  /// bloc functions
  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is MapInitEvent) {
      await _initMapElements();
      yield* _mapDataRequestedToState();
    } else if (event is MapUpdateEvent) {
      yield* _mapUpdateRequestedToState();
    } else {
      yield MapErrorState();
    }
  }

  Stream<MapState> _mapDataRequestedToState() async* {
    if (isLoading) {
      yield MapLoadingState();
      isLoading = false;
    } else {
      /// Poll every 3ish seconds
      await Future.delayed(const Duration(seconds: 2));
    }

    shuttleRoutes = await shuttleRepo.getRoutes;
    shuttleStops = await shuttleRepo.getStops;
    shuttleUpdates = await shuttleRepo.getUpdates;

    busRoutes = await busRepo.getRoutes;
    // shapes = await busRepo.getShapes;
    // busStops = await busRepo.getStops;
    // busUpdates = await busRepo.getUpdates;

    prefsBloc.add(InitActiveRoutesEvent(shuttleRoutes.values.toList()));

    if (shuttleRepo.isConnected || busRepo.isConnected) {
      yield MapLoadedState(
          polylines: _getEnabledPolylines(), markers: _getEnabledMarkers());
    } else {
      isLoading = true;
      yield MapErrorState(message: 'NETWORK ISSUE');
    }
  }

  Stream<MapState> _mapUpdateRequestedToState() async* {
    shuttleUpdates = await shuttleRepo.getUpdates;
    // busUpdates = await busRepo.getUpdates;

    if (shuttleRepo.isConnected || busRepo.isConnected) {
      yield MapLoadedState(
          polylines: _getEnabledPolylines(), markers: _getEnabledMarkers());
    } else {
      isLoading = true;
      yield MapErrorState(message: 'NETWORK ISSUE');
    }
  }


  /// non-state related functions
  void scrollToCurrentLocation() async {
    var currentLocation;
    try {
      currentLocation =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } on PermissionDeniedException catch (_) {
      return;
    }

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


  /// helper functions
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

  Marker _shuttleStopToMarker(ShuttleStop stop) {
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

  Marker _busStopToMarker(BusStop stop) {
    return Marker(
        icon: busStopIcon,
        infoWindow: InfoWindow(title: stop.stopName),
        markerId: MarkerId(stop.stopId.toString()),
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

  Set<Polyline> _getEnabledPolylines() {
    Set<Polyline> _currentPolylines = <Polyline>{};

    _enabledShuttles.forEach((id, enabled) {
      if (enabled) {
        _currentPolylines.add(shuttleRoutes[id].getPolyline);
      }
    });
    return _currentPolylines;
  }

  Set<Marker> _getEnabledMarkers() {
    Set<Marker> _currentMarkers = <Marker>{};
    var markerMap = {
      for (var stop in shuttleStops) stop.id: _shuttleStopToMarker(stop)
    };
    for (var update in shuttleUpdates) {
      _currentMarkers.add(_updateToMarker(update));
    }

    _enabledShuttles.forEach((name, enabled) {
      if (enabled) {
        shuttleRoutes[name].stopIds.forEach((id) {
          _currentMarkers.add(markerMap[id]);
        });
      }
    });

    busStops.forEach((stop) {
      _currentMarkers.add(_busStopToMarker(stop));
    });
    return _currentMarkers;
  }
}
