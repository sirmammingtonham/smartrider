// implementation imports
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smartrider/util/bitmap_helpers.dart';

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
// import 'package:smartrider/data/models/bus/bus_stop.dart';
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

  bool _isBus;
  StreamSubscription prefsStream;
  double zoomLevel = 14.0;

  Map<String, bool> _enabledShuttles = {};
  Map<String, bool> _enabledBuses = {};

  GoogleMapController _controller;

  Map<String, BusRoute> busRoutes = {};
  Map<String, BusShape> busShapes = {};
  List<BusVehicleUpdate> busUpdates = [];

  Map<String, ShuttleRoute> shuttleRoutes = {};
  List<ShuttleStop> shuttleStops = [];
  List<ShuttleUpdate> shuttleUpdates = [];
  List<MapMarker> _mapMarkers = [];

  Set<Marker> _currentMarkers = <Marker>{};
  Set<Polyline> _currentPolylines = <Polyline>{};

  BitmapDescriptor shuttleStopIcon, busStopIcon;
  Map<int, BitmapDescriptor> _updateIcons = {}; // maps id to image

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
    _isBus = true;

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
      zoomLevel = event.zoomLevel;
      yield* _mapUpdateRequestedToState();
    } else if (event is MapTypeChangeEvent) {
      _isBus = !_isBus;
      if (event.zoomLevel != null) {
        zoomLevel = event.zoomLevel;
      }
      yield* _mapUpdateRequestedToState();
    } else if (event is MapMoveEvent) {
      yield* _mapMoveToState(event.zoomLevel);
    } else {
      yield MapErrorState();
    }
  }

  Stream<MapState> _mapDataRequestedToState() async* {
    yield MapLoadingState();

    Stopwatch stopwatch = new Stopwatch()..start();

    if (_isBus) {
      busRoutes = await busRepo.getRoutes;
      busShapes = await busRepo.getPolylines;
      busUpdates = await busRepo.getUpdates;
      prefsBloc.add(PrefsUpdateEvent()); // just to get enabled bus routes
    } else {
      shuttleRoutes = await shuttleRepo.getRoutes;
      shuttleStops = await shuttleRepo.getStops;
      shuttleUpdates = await shuttleRepo.getUpdates;
      prefsBloc.add(InitActiveRoutesEvent(shuttleRoutes.values
          .toList())); // update preferences with currently active routes
    }

    print('got the stuff in ${stopwatch.elapsed} seconds');

    // bus repo should always be connected now because firestore
    if (!_isBus && !shuttleRepo.isConnected) {
      isLoading = true;
      yield MapErrorState(message: 'NETWORK ISSUE');
      return;
    }

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(zoomLevel)).toSet(),
        isBus: _isBus);
  }

  Stream<MapState> _mapUpdateRequestedToState() async* {
    if (_isBus) {
      busUpdates = await busRepo.getUpdates;
    } else {
      if (shuttleRoutes.isEmpty) {
        print('getting shuttle stuff now');
        yield* _mapDataRequestedToState();
        return;
      }
      shuttleUpdates = await shuttleRepo.getUpdates;
    }

    if (!_isBus && !shuttleRepo.isConnected) {
      isLoading = true;
      yield MapErrorState(message: 'NETWORK ISSUE');
      return;
    }

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(zoomLevel)).toSet(),
        isBus: _isBus);
  }

  Stream<MapState> _mapMoveToState(double zoomLevel) async* {
    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _getMarkerClusters(zoomLevel).followedBy(_currentMarkers).toSet(),
        isBus: _isBus);
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
    final stopMarkerSize = Size(80, 80);
    final vehicleUpdateSize = Size(100, 100);
    shuttleStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/shuttle_icons/marker_shuttle.svg',
        size: stopMarkerSize);
    busStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/bus_icons/marker_bus.svg',
        size: stopMarkerSize);

    final shuttleColors = {
      22: Colors.red,
      21: Colors.yellow,
      24: Colors.blue,
      28: Colors.orange
    };

    [22, 21, 24, 28].forEach((id) async {
      _updateIcons[id] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
          'assets/bus_icons/update_marker.svg',
          color: shuttleColors[id].lighten(0.15),
          size: vehicleUpdateSize);
    });

    [87, 286, 289, 288].forEach((id) async {
      _updateIcons[id] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
          'assets/bus_icons/update_marker.svg',
          color: BUS_COLORS['$id-185'].lighten(0.15),
          size: vehicleUpdateSize);
    });

    // default white
    _updateIcons[-1] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/bus_icons/update_marker.svg',
        size: vehicleUpdateSize);
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

  // Marker _busStopToMarker(BusStop stop) {
  //   return Marker(
  //       icon: busStopIcon,
  //       infoWindow: InfoWindow(title: stop.stopName),
  //       markerId: MarkerId(stop.stopId.toString()),
  //       position: stop.getLatLng,
  //       onTap: () {
  //         _controller.animateCamera(
  //           CameraUpdate.newCameraPosition(
  //               CameraPosition(target: stop.getLatLng, zoom: 18, tilt: 50)),
  //         );
  //       });
  // }

  MapMarker _busStopToMapMarker(BusStopSimplified stop) {
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
        icon: _updateIcons[
            _updateIcons.containsKey(update.routeId) ? update.routeId : -1],
        infoWindow:
            InfoWindow(title: "Shuttle ID: ${update.vehicleId.toString()}"),
        flat: true,
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
    int routeId = int.parse(update.routeId);
    // real time update shuttles
    return Marker(
        icon: _updateIcons[_updateIcons.containsKey(routeId) ? routeId : -1],
        infoWindow: InfoWindow(title: "Bus ID: ${update.id.toString()}"),
        flat: true,
        markerId: MarkerId(update.id.toString()),
        position: update.getLatLng,
        rotation: _calculateBusHeading(update),
        anchor: Offset(0.5, 0.5),
        onTap: () {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: update.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  double _calculateBusHeading(BusVehicleUpdate update) {
    BusStopSimplified stop;
    //TODO: get bus direction id
    try {
      stop = busRoutes[update.routeId + '-185']
          .forwardStops[update.currentStopSequence];
    } catch (error) {
      stop = busRoutes[update.routeId + '-185']
          .reverseStops[update.currentStopSequence];
    }

    double lat1 = stop.stopLat;
    double lat2 = update.latitude;
    double lon1 = stop.stopLon;
    double lon2 = update.longitude;

    double dL = lon2 - lon1;

    // https://towardsdatascience.com/calculating-the-bearing-between-two-geospatial-coordinates-66203f57e4b4
    double x = cos(lat2) * sin(dL);
    double y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dL);
    double bearing = atan2(x, y); // in radians
    double heading = (bearing * 180 / pi + 360) % 360; // convert to degrees

    return heading;
  }

  Set<Polyline> _getEnabledPolylines() {
    _currentPolylines.clear();
    if (_isBus) {
      _enabledBuses.forEach((id, enabled) {
        if (enabled) {
          _currentPolylines.addAll(busShapes[id].getPolylines);
        }
      });
    } else {
      _enabledShuttles.forEach((id, enabled) {
        if (enabled) {
          _currentPolylines.add(shuttleRoutes[id].getPolyline);
        }
      });
    }

    return _currentPolylines;
  }

  Set<Marker> _getEnabledMarkers() {
    _currentMarkers.clear();
    _mapMarkers.clear();

    if (_isBus) {
      for (var update in busUpdates) {
        _currentMarkers.add(_busUpdateToMarker(update));
      }

      _enabledBuses.forEach((route, enabled) {
        if (enabled) {
          busRoutes[route]
              .stops
              .forEach((stop) => _mapMarkers.add(_busStopToMapMarker(stop)));
        }
      });
    } else {
      for (var update in shuttleUpdates) {
        _currentMarkers.add(_shuttleUpdateToMarker(update));
      }

      var shuttleMarkerMap = {
        for (var stop in shuttleStops) stop.id: _shuttleStopToMarker(stop)
      };

      _enabledShuttles.forEach((route, enabled) {
        if (enabled) {
          shuttleRoutes[route].stopIds.forEach((id) {
            _currentMarkers.add(shuttleMarkerMap[id]);
          });
        }
      });
    }

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
