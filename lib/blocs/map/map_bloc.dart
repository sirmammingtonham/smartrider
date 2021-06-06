// implementation imports
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smartrider/util/bitmap_helpers.dart';
import 'package:smartrider/util/messages.dart';

// map imports
import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluster/fluster.dart';

// bloc imports
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';

// repository imports
import 'package:smartrider/data/repositories/bus_repository.dart';
import 'package:smartrider/data/repositories/shuttle_repository.dart';
import 'package:smartrider/data/repositories/saferide_repository.dart';

// model imports
import 'package:smartrider/data/models/shuttle/shuttle_route.dart';
import 'package:smartrider/data/models/shuttle/shuttle_stop.dart';
import 'package:smartrider/data/models/shuttle/shuttle_update.dart';

import 'package:smartrider/data/models/saferide/driver.dart';

import 'package:smartrider/data/models/bus/bus_route.dart';
import 'package:smartrider/data/models/bus/bus_shape.dart';
import 'package:smartrider/data/models/bus/bus_vehicle_update.dart';

part 'map_event.dart';
part 'map_state.dart';

// TODO: Document this absolute fucking unit
class MapMarker extends Clusterable {
  String? id;
  late LatLng position;
  BitmapDescriptor? icon;
  String? info;
  GoogleMapController? controller;
  MapMarker({
    required this.id,
    required this.position,
    required this.icon,
    required this.info,
    required this.controller,
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
      markerId: MarkerId(id!),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      infoWindow: InfoWindow(title: this.info),
      icon: icon!,
      onTap: () {
        controller!.animateCamera(
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
  final SaferideRepository saferideRepo;
  final PrefsBloc prefsBloc;
  final SaferideBloc saferideBloc;

  late StreamSubscription _prefsBlocSub;
  late StreamSubscription _saferideBlocSub;
  double? _zoomLevel = 14.0;
  bool? _isBus;

  Map<String?, bool?>? _enabledShuttles = {};
  Map<String, bool>? _enabledBuses = {};

  GoogleMapController? _controller;

  Map<String?, BusRoute> _busRoutes = {};
  Map<String?, BusShape> _busShapes = {};
  List<BusVehicleUpdate> _busUpdates = [];

  Map<String?, ShuttleRoute> _shuttleRoutes = {};
  List<ShuttleStop>? _shuttleStops = [];
  List<ShuttleUpdate>? _shuttleUpdates = [];

  List<MapMarker> _mapMarkers = [];

  Map<String?, Driver>? _saferideDrivers = {};
  Map<String?, MovementStatus> _saferideUpdates = {};
  Map<String?, StreamSubscription<MovementStatus>> _saferideUpdateSubs = {};
  LatLng? _saferideDest;

  Set<Marker?> _currentMarkers = <Marker?>{};
  Set<Polyline> _currentPolylines = <Polyline>{};

  BitmapDescriptor? _shuttleStopIcon, _busStopIcon;
  Map<int, BitmapDescriptor> _updateIcons = {}; // maps id to image

  late Fluster<MapMarker> fluster;
  String? _lightMapStyle;
  String? _darkMapStyle;

  final _updateRefreshDelay = const Duration(seconds: 3); // update every 3 sec
  late Timer _updateTimer;

  /// MapBloc named constructor
  MapBloc(
      {required this.shuttleRepo,
      required this.busRepo,
      required this.saferideRepo,
      required this.saferideBloc,
      required this.prefsBloc})
      : super(MapLoadingState()) {
    _isBus = true;

    rootBundle.loadString('assets/map_styles/aubergine.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
      _lightMapStyle = string;
    });

    _prefsBlocSub = prefsBloc.listen((prefsState) {
      if (prefsState is PrefsLoadedState) {
        _enabledShuttles = prefsState.shuttles;
        _enabledBuses = prefsState.buses;
        if (_controller != null) {
          _controller!.setMapStyle(prefsState.theme.brightness == Brightness.dark
              ? _darkMapStyle
              : _lightMapStyle);
        }
      }
    });

    _saferideBlocSub = saferideBloc.listen((saferideState) {
      switch (saferideState.runtimeType) {
        case SaferideSelectionState:
          add(MapSaferideSelectionEvent(
              coord: (saferideState as SaferideSelectionState).dropLatLng));
          break;
        case SaferideNoState:
          {
            scrollToCurrentLocation();
            add(MapUpdateEvent(zoomLevel: _zoomLevel));

            // i think the previous timer keeps going so this is redundant
            // but need to make sure
            // _updateTimer = Timer.periodic(_updateRefreshDelay,
            //     (Timer t) => add(MapUpdateEvent(zoomLevel: _zoomLevel)));
          }
      }
    });
  }

  @override
  Future<void> close() {
    _updateTimer.cancel();
    _prefsBlocSub.cancel();
    _saferideBlocSub.cancel();
    _saferideUpdateSubs.values.forEach((sub) => sub.cancel());
    return super.close();
  }

  GoogleMapController? get controller => _controller;

  updateController(BuildContext context, GoogleMapController controller) {
    _controller = controller;
    _controller!.setMapStyle(Theme.of(context).brightness == Brightness.dark
        ? _darkMapStyle
        : _lightMapStyle);
  }

  /// bloc functions
  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    switch (event.runtimeType) {
      case MapInitEvent:
        {
          await _initMapElements();
          _updateTimer = Timer.periodic(_updateRefreshDelay,
              (Timer t) => add(MapUpdateEvent(zoomLevel: _zoomLevel)));
          yield* _mapDataRequestedToState();
        }
        break;
      case MapUpdateEvent:
        {
          _zoomLevel = (event as MapUpdateEvent).zoomLevel;
          yield* _mapUpdateRequestedToState();
        }
        break;
      case MapTypeChangeEvent:
        {
          _isBus = !_isBus!;
          yield* _mapUpdateRequestedToState();
        }
        break;
      case MapSaferideSelectionEvent:
        {
          _saferideDest = (event as MapSaferideSelectionEvent).coord;
          scrollToLocation(_saferideDest!);
          yield* _mapSaferideSelectionToState(event);
        }
        break;
      case MapMoveEvent:
        {
          _zoomLevel = (event as MapMoveEvent).zoomLevel;
          yield* _mapMoveToState();
        }
        break;
      default:
        yield MapErrorState();
    }
  }

  Stream<MapState> _mapDataRequestedToState() async* {
    yield MapLoadingState();

    Stopwatch stopwatch = new Stopwatch()..start();

    if (_saferideUpdates.isEmpty) {
      _saferideDrivers = await saferideRepo.getDrivers;
      // _saferideUpdates = await saferideRepo.getDriverUpdates;

      saferideRepo.getDriverUpdateSubscriptions.forEach((id, status) {
        _saferideUpdateSubs[id] =
            status.listen((status) => _saferideUpdates[id] = status);
      });
    }

    if (_isBus!) {
      _busRoutes = await busRepo.getRoutes;
      _busShapes = await busRepo.getPolylines;
      _busUpdates = await busRepo.getUpdates;
      prefsBloc.add(PrefsUpdateEvent()); // just to get enabled bus routes
    } else {
      _shuttleRoutes = await shuttleRepo.getRoutes;
      _shuttleStops = await shuttleRepo.getStops;
      _shuttleUpdates = await shuttleRepo.getUpdates;

      if (!shuttleRepo.isConnected!) {
        _updateTimer.cancel();
        yield MapErrorState(message: NETWORK_ERROR_MESSAGE);
        return;
      }

      prefsBloc.add(InitActiveRoutesEvent(_shuttleRoutes.values
          .toList())); // update preferences with currently active routes
    }

    print('got the stuff in ${stopwatch.elapsed} seconds');

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(_zoomLevel!)).toSet(),
        isBus: _isBus);
  }

  Stream<MapState> _mapSaferideSelectionToState(
      MapSaferideSelectionEvent event) async* {
    _updateTimer.cancel();
    _currentPolylines.clear();
    _currentMarkers.clear();
    _mapMarkers.clear();
    _currentMarkers.add(Marker(
        icon: _shuttleStopIcon!,
        infoWindow: InfoWindow(title: "saferide dest test marker"),
        markerId: MarkerId("saferide_dest"),
        position: _saferideDest!,
        onTap: () {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: _saferideDest!, zoom: 18, tilt: 50)),
          );
        }));
    await _drawToCurrentLocation(event.coord);

    _currentMarkers.addAll(_saferideUpdates.values
        .map((status) => _saferideVehicleToMarker(status)));

    yield MapLoadedState(
        polylines: _currentPolylines, markers: _currentMarkers, isBus: false);
  }

  Stream<MapState> _mapUpdateRequestedToState() async* {
    if (_isBus!) {
      _busUpdates = await busRepo.getUpdates;
    } else {
      if (_shuttleRoutes.isEmpty) {
        yield* _mapDataRequestedToState();
        return;
      }
      _shuttleUpdates = await shuttleRepo.getUpdates;
    }

    if (!_isBus! && !shuttleRepo.isConnected!) {
      yield MapErrorState(message: NETWORK_ERROR_MESSAGE);
      return;
    }

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(_zoomLevel!)).toSet(),
        isBus: _isBus);
  }

  Stream<MapState> _mapMoveToState() async* {
    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _getMarkerClusters(_zoomLevel!).followedBy(_currentMarkers).toSet(),
        isBus: _isBus);
  }

  /// non-state related functions
  Future<void> _drawToCurrentLocation(LatLng? destLocation,
      {LatLng? pickupLocation}) async {
    // draw line between saferide pickup and driver location
    if (pickupLocation == null) {
      try {
        Position loc = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        pickupLocation = LatLng(loc.latitude, loc.longitude);
      } on PermissionDeniedException catch (_) {
        return;
      }
    }
    List<LatLng?> twoPoints = [pickupLocation, destLocation];
    Polyline p = Polyline(
        polylineId: PolylineId("saferide_to_dest"),
        points: twoPoints as List<LatLng>,
        color: Colors.amber);

    _currentPolylines.add(p);
  }

  void scrollToCurrentLocation() async {
    Position currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PermissionDeniedException catch (_) {
      return;
    }

    LatLng loc = LatLng(currentLocation.latitude, currentLocation.longitude);

    if (rpiBounds.contains(loc)) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: loc,
            zoom: 17.0,
          ),
        ),
      );
    } else {
      _controller!.animateCamera(
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
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 18, tilt: 50)),
    );
  }

  /// helper functions
  Future<void> _initMapElements() async {
    final stopMarkerSize = Size(80, 80);
    final vehicleUpdateSize = Size(100, 100);
    _shuttleStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/shuttle_icons/marker_shuttle.svg',
        size: stopMarkerSize);
    _busStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
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
          color: shuttleColors[id]!.lighten(0.15),
          size: vehicleUpdateSize);
    });

    [87, 286, 289, 288].forEach((id) async {
      _updateIcons[id] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
          'assets/bus_icons/update_marker.svg',
          color: BUS_COLORS[id.toString()]!.lighten(0.15),
          size: vehicleUpdateSize);
    });

    // default white
    _updateIcons[-1] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/bus_icons/update_marker.svg',
        size: vehicleUpdateSize);
  }

  Marker _shuttleStopToMarker(ShuttleStop stop) {
    return Marker(
        icon: _shuttleStopIcon!,
        infoWindow: InfoWindow(title: stop.name),
        markerId: MarkerId(stop.id.toString()),
        position: stop.getLatLng,
        onTap: () {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: stop.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  Marker _saferideVehicleToMarker(MovementStatus status) {
    LatLng position =
        LatLng(status.location.latitude, status.location.longitude);
    return Marker(
        icon: _shuttleStopIcon!, //TODO: get icon for drivers
        infoWindow: InfoWindow(title: 'Safe Ride'),
        markerId: MarkerId(status.deviceId),
        position: position,
        onTap: () {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: position, zoom: 18, tilt: 50)),
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
        icon: _busStopIcon,
        controller: _controller);
  }

  Marker _shuttleUpdateToMarker(ShuttleUpdate update) {
    // real time update shuttles
    return Marker(
        icon: _updateIcons[
            _updateIcons.containsKey(update.routeId) ? update.routeId! : -1]!,
        infoWindow:
            InfoWindow(title: "Shuttle ID: ${update.vehicleId.toString()}"),
        flat: true,
        markerId: MarkerId(update.id.toString()),
        position: update.getLatLng,
        rotation: update.heading as double,
        anchor: Offset(0.5, 0.5),
        onTap: () {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: update.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  Marker _busUpdateToMarker(BusVehicleUpdate update) {
    int routeId = int.parse(update.routeId!);
    // real time update shuttles
    return Marker(
        icon: _updateIcons[_updateIcons.containsKey(routeId) ? routeId : -1]!,
        infoWindow: InfoWindow(title: "Bus ID: ${update.id.toString()}"),
        flat: true,
        markerId: MarkerId(update.id.toString()),
        position: update.getLatLng,
        rotation: _calculateBusHeading(update),
        anchor: Offset(0.5, 0.5),
        onTap: () {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: update.getLatLng, zoom: 18, tilt: 50)),
          );
        });
  }

  double _calculateBusHeading(BusVehicleUpdate update) {
    late BusStopSimplified stop;

    //TODO: get bus direction id
    try {
      try {
        stop =
            _busRoutes[update.routeId]!.forwardStops[update.currentStopSequence!];
      } catch (error) {
        stop =
            _busRoutes[update.routeId]!.reverseStops[update.currentStopSequence!];
      } // we should really handle this better
    } catch (error) {
      print(error);
      print(update.routeId);
    }

    double lat1 = stop.stopLat!;
    double lat2 = update.latitude!;
    double lon1 = stop.stopLon!;
    double lon2 = update.longitude!;

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
    if (_isBus!) {
      _enabledBuses!.forEach((id, enabled) {
        if (enabled) {
          if (_busShapes[id] != null) {
            _currentPolylines.addAll(_busShapes[id]!.getPolylines);
          }
        }
      });
    } else {
      _enabledShuttles!.forEach((id, enabled) {
        if (enabled!) {
          _currentPolylines.add(_shuttleRoutes[id]!.getPolyline);
        }
      });
    }

    return _currentPolylines;
  }

  Set<Marker?> _getEnabledMarkers() {
    _currentMarkers.clear();
    _mapMarkers.clear();

    if (_isBus!) {
      for (var update in _busUpdates) {
        _currentMarkers.add(_busUpdateToMarker(update));
      }

      _enabledBuses!.forEach((route, enabled) {
        if (enabled) {
          if (_busRoutes[route] != null) {
            _busRoutes[route]!
                .stops!
                .forEach((stop) => _mapMarkers.add(_busStopToMapMarker(stop)));
          }
        }
      });
    } else {
      for (var update in _shuttleUpdates!) {
        _currentMarkers.add(_shuttleUpdateToMarker(update));
      }

      var shuttleMarkerMap = {
        for (var stop in _shuttleStops!) stop.id: _shuttleStopToMarker(stop)
      };

      _enabledShuttles!.forEach((route, enabled) {
        if (enabled!) {
          _shuttleRoutes[route]!.stopIds!.forEach((id) {
            _currentMarkers.add(shuttleMarkerMap[id]);
          });
        }
      });
    }

    // idk if we want saferides to only be visible when calling a saferide
    // map is already hella cluttered, but i think ppl will want to know the relative positions of saferides
    _currentMarkers.addAll(_saferideUpdates.values
        .map((status) => _saferideVehicleToMarker(status)));

    return _currentMarkers;
  }

  Set<Marker?> _getMarkerClusters(double zoomLevel) {
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
              icon: this._busStopIcon, // replace with cluster marker
              info: fluster.children(cluster.id)!.length.toString(),
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
