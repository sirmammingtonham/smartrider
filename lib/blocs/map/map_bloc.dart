// implementation imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;

// map imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluster/fluster.dart';
import 'package:meta/meta.dart';

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

class MapMarker extends Clusterable {
  String id;
  LatLng position;
  BitmapDescriptor icon;
  String info;
  GoogleMapController controller;
  MapMarker({
    @required this.id,
    @required this.position,
    @required this.icon,
    @required this.info,
    @required this.controller,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );
  Marker toMarker() => Marker(
      markerId: MarkerId(id),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      infoWindow: InfoWindow(title: this.info),
      icon: icon,
      onTap: () {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 18,
              tilt: 50)),
        );
      });
  MapMarker.fromMarker(Marker m) {
    this.id = m.markerId.toString();
    this.position = m.position;
    this.icon = m.icon;
    isCluster = false;
  }
}

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
  Map<String, bool> _enabledBuses = {};

  GoogleMapController _controller;

  Map<String, BusRoute> busRoutes = {};
  Map<String, BusShape> busShapes = {};
  //Map<String, List<BusStop>> busStops = {};
  List<BusStop> busStops = [];
  List<BusVehicleUpdate> busUpdates = [];

  Map<String, ShuttleRoute> shuttleRoutes = {};
  List<ShuttleStop> shuttleStops = [];
  List<ShuttleUpdate> shuttleUpdates = [];
  List<MapMarker> _mapMarkers = [];

  Set<Marker> _currentMarkers = <Marker>{};
  Set<Polyline> _currentPolylines = <Polyline>{};

  BitmapDescriptor shuttleStopIcon, busStopIcon;
  Map<int, BitmapDescriptor> shuttleUpdateIcons = {}; // maps id to image

  bool isLoading = true;
  Fluster<MapMarker> fluster;
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
        _enabledBuses = prefsState.buses;
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
      yield* _mapUpdateRequestedToState(event.zoomLevel);
    } else if (event is MapMoveEvent) {
      yield* _mapMoveToState(event.zoomLevel);
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

    // busRoutes = await busRepo.getRoutes;
    busShapes = await busRepo.getShapes;
    busStops = await busRepo.getStops;
    busUpdates = await busRepo.getUpdates;

    prefsBloc.add(InitActiveRoutesEvent(shuttleRoutes.values
        .toList())); // update preferences with currently active routes

    if (shuttleRepo.isConnected || busRepo.isConnected) {
      _getEnabledMarkers();
      _getEnabledPolylines();

      yield MapLoadedState(
          polylines: _currentPolylines,
          markers:
              _currentMarkers.followedBy(_getMarkerClusters(14.0)).toSet());
    } else {
      isLoading = true;
      yield MapErrorState(message: 'NETWORK ISSUE');
    }
  }

  Stream<MapState> _mapUpdateRequestedToState(double zoomLevel) async* {
    shuttleUpdates = await shuttleRepo.getUpdates;
    busUpdates = await busRepo.getUpdates;

    if (shuttleRepo.isConnected || busRepo.isConnected) {
      _getEnabledMarkers();
      _getEnabledPolylines();
      yield MapLoadedState(
          polylines: _currentPolylines,
          markers: _currentMarkers
              .followedBy(_getMarkerClusters(zoomLevel))
              .toSet());
    } else {
      isLoading = true;
      yield MapErrorState(message: 'NETWORK ISSUE');
    }
  }

  Stream<MapState> _mapMoveToState(double zoomLevel) async* {
    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _getMarkerClusters(zoomLevel).followedBy(_currentMarkers).toSet());
  }

  /// non-state related functions
  void scrollToCurrentLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
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

      // temporary until we finalize map marker icons
      shuttleUpdateIcons[289] = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_blue.png')
        .then((onValue) {
      shuttleUpdateIcons[24] = onValue;

      // temporary until we finalize map marker icons
      shuttleUpdateIcons[87] = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            config, 'assets/bus_markers/bus_orange.png')
        .then((onValue) {
      shuttleUpdateIcons[28] = onValue;

      // temporary until we finalize map marker icons
      shuttleUpdateIcons[286] = onValue;
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

  MapMarker _busStopToMapMarker(BusStop stop) {
    return MapMarker(
        id: stop.stopId,
        info: stop.stopName,
        position: stop.getLatLng,
        icon: busStopIcon,
        controller: _controller);
  }

  Marker _shuttleUpdateToMarker(ShuttleUpdate update) {
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

  Marker _busUpdateToMarker(BusVehicleUpdate update) {
    // real time update shuttles
    return Marker(
        icon: shuttleUpdateIcons[shuttleUpdateIcons.containsKey(update.routeId)
            ? update.routeId
            : -1],
        infoWindow: InfoWindow(title: "Shuttle ID: ${update.id.toString()}"),
        markerId: MarkerId(update.id.toString()),
        position: update.getLatLng,
        // rotation: update.heading,   figure out some way to calculate heading? cdta website does somehow
        anchor: Offset(0.5, 0.5),
        onTap: () {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: update.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  Set<Polyline> _getEnabledPolylines() {
    _currentPolylines.clear();
    _enabledShuttles.forEach((id, enabled) {
      if (enabled) {
        _currentPolylines.add(shuttleRoutes[id].getPolyline);
      }
    });
    _enabledBuses.forEach((id, enabled) {
      if (enabled) {
        _currentPolylines.addAll(busShapes[id].getPolylines);
      }
    });

    return _currentPolylines;
  }

  Set<Marker> _getEnabledMarkers() {
    _currentMarkers.clear();
    _mapMarkers.clear();

    for (var update in shuttleUpdates) {
      _currentMarkers.add(_shuttleUpdateToMarker(update));
    }

    for (var update in busUpdates) {
      _currentMarkers.add(_busUpdateToMarker(update));
    }

    var shuttleMarkerMap = {
      for (var stop in shuttleStops) stop.id: _shuttleStopToMarker(stop)
    };

    _enabledShuttles.forEach((name, enabled) {
      if (enabled) {
        shuttleRoutes[name].stopIds.forEach((id) {
          _currentMarkers.add(shuttleMarkerMap[id]);
        });
      }
    });

    // hardcoding these for now, should be handled in backend
    var busMarkerMap = {
      '87-184': busStops
          .sublist(0, 60)
          .map((stop) => _busStopToMapMarker(stop))
          .toList(),
      '286-184': busStops
          .sublist(60, 135)
          .map((stop) => _busStopToMapMarker(stop))
          .toList(),
      '289-184': busStops
          .sublist(135)
          .map((stop) => _busStopToMapMarker(stop))
          .toList(),
    };

    _enabledBuses.forEach((name, enabled) {
      if (enabled) {
        busMarkerMap[name].forEach((marker) => _mapMarkers.add(marker));
      }
    });

    return _currentMarkers;
  }

  Set<Marker> _getMarkerClusters(double zoomLevel) {
    fluster = Fluster<MapMarker>(
      minZoom: 14, // The min zoom at clusters will show
      maxZoom: 18, // The max zoom at clusters will show
      radius: 450, // increase for more aggressive clustering vice versa
      extent: 2048, // Tile extent. Radius is calculated with it.
      nodeSize: 64, // Size of the KD-tree leaf node.
      points: _mapMarkers, // The list of markers created before
      createCluster: (
        // Create cluster marker
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
              id: cluster.id.toString(),
              position: LatLng(lat, lng),
              icon: this.busStopIcon, // replace with cluster marker
              info: fluster.children(cluster.id).length.toString(),
              isCluster: cluster.isCluster,
              clusterId: cluster.id,
              pointsSize: cluster.pointsSize,
              childMarkerId: cluster.childMarkerId,
              controller: this._controller),
    );

    return fluster
        .clusters([
          rpiBounds.southwest.longitude,
          rpiBounds.southwest.latitude,
          rpiBounds.northeast.longitude,
          rpiBounds.northeast.latitude
        ], zoomLevel.round())
        .map((cluster) => cluster.toMarker())
        .toSet();
  }
}
