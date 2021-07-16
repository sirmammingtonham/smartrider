// implementation imports
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared/models/bus/bus_realtime_update.dart';
import 'package:shared/util/bitmap_helpers.dart';
import 'package:shared/util/errors.dart';

// map imports
// import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluster/fluster.dart';
import 'package:sizer/sizer.dart';

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
import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:shared/models/shuttle/shuttle_update.dart';

// import 'package:shared/models/saferide/driver.dart';

import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
//import 'package:shared/models/bus/bus_vehicle_update.dart';
import 'package:shared/models/saferide/position_data.dart';
// import 'package:shared/util/math_util.dart';
import 'package:shared/util/spherical_utils.dart';

part 'map_event.dart';
part 'map_state.dart';

// TODO: Document this absolute fucking unit

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

  double _zoomLevel = 14.0;
  bool _isBus = true;

  Map<String?, bool?>? _enabledShuttles = {};
  Map<String, bool>? _enabledBuses = {};

  GoogleMapController? _controller;

  Map<String?, BusRoute> _busRoutes = {};
  Map<String?, BusShape> _busShapes = {};
  Map<String, List<BusRealtimeUpdate>> _busUpdates = {};

  Map<String?, ShuttleRoute> _shuttleRoutes = {};
  List<ShuttleStop>? _shuttleStops = [];
  List<ShuttleUpdate>? _shuttleUpdates = [];

  final List<MarkerCluster> _mapMarkers = [];

  final Map<String, PositionData> _saferideUpdates = {};
  // SaferideSelectingState? _saferideSelectionState;
  String? _pickupVehicleId;

  final Set<Marker> _currentMarkers = <Marker>{};
  final Set<Polyline> _currentPolylines = <Polyline>{};

  late final BitmapDescriptor _shuttleStopIcon,
      _busStopIcon,
      _saferideUpdateIcon, // generic saferide
      _saferidePickingUpIcon, // saferide that is assigned to your order
      _pickupIcon,
      _dropoffIcon;

  final Map<int, BitmapDescriptor> _updateIcons =
      {}; // maps route id to update marker

  late Fluster<MarkerCluster> fluster;
  late final String _lightMapStyle;
  late final String _darkMapStyle;

  static const _updateRefreshDelay =
      const Duration(seconds: 3); // update every 3 sec
  late Timer _updateTimer;

  /// MapBloc named constructor
  MapBloc(
      {required this.shuttleRepo,
      required this.busRepo,
      required this.saferideRepo,
      required this.saferideBloc,
      required this.prefsBloc})
      : super(MapLoadingState()) {
    rootBundle.loadString('assets/map_styles/aubergine.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/map_styles/light.json').then((string) {
      _lightMapStyle = string;
    });

    // just noticing that it will be a problem if the async above completes
    // after this...
    prefsBloc.stream.listen((prefsState) {
      if (prefsState is PrefsLoadedState) {
        _enabledShuttles = prefsState.shuttles;
        _enabledBuses = prefsState.buses;
        if (_controller != null) {
          _controller!.setMapStyle(
              prefsState.theme.brightness == Brightness.dark
                  ? _darkMapStyle
                  : _lightMapStyle);
        }
      }
    });

    saferideBloc.stream.listen((saferideState) {
      switch (saferideState.runtimeType) {
        case SaferideSelectingState:
          {
            add(MapSaferideSelectionEvent(
                saferideState: saferideState as SaferideSelectingState));
          }
          break;
        case SaferidePickingUpState:
          {
            _pickupVehicleId = (state as SaferidePickingUpState).vehicleId;
          }
          break;
        case SaferideNoState:
          {
            scrollToCurrentLocation();
            add(MapUpdateEvent(zoomLevel: _zoomLevel));
          }
      }
    });

    /// update vehicle positions in our cache
    saferideRepo.getSaferideLocationsStream().listen((positions) {
      positions.forEach((position) {
        if (position.active) _saferideUpdates[position.id] = position;
      });
    });
  }

  @override
  Future<void> close() {
    _updateTimer.cancel();
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
          _zoomLevel = (event as MapUpdateEvent).zoomLevel ?? _zoomLevel;
          yield* _mapUpdateRequestedToState();
        }
        break;
      case MapTypeChangeEvent:
        {
          _isBus = !_isBus;
          yield* _mapUpdateRequestedToState();
        }
        break;
      case MapSaferideSelectionEvent:
        {
          yield* _mapSaferideSelectionToState(
              event as MapSaferideSelectionEvent);
        }
        break;
      case MapMoveEvent:
        {
          _zoomLevel = (event as MapMoveEvent).zoomLevel;
          yield* _mapMoveToState();
        }
        break;
      default:
        yield MapErrorState(error: SRError.BLOC_ERROR);
    }
  }

  Stream<MapState> _mapDataRequestedToState() async* {
    yield MapLoadingState();

    // Stopwatch stopwatch = new Stopwatch()..start();

    if (_isBus) {
      _busRoutes = await busRepo.getRoutes;
      _busShapes = await busRepo.getPolylines;
      _busUpdates = await busRepo.getRealtimeUpdate;
      prefsBloc.add(PrefsUpdateEvent()); // just to get enabled bus routes
    } else {
      _shuttleRoutes = await shuttleRepo.getRoutes;
      _shuttleStops = await shuttleRepo.getStops;
      _shuttleUpdates = await shuttleRepo.getUpdates;

      if (!shuttleRepo.isConnected!) {
        // needed or else we will continuously update the unavailable shuttle service
        _updateTimer.cancel();
        yield MapErrorState(error: SRError.NETWORK_ERROR);
        return;
      }

      prefsBloc.add(InitActiveRoutesEvent(_shuttleRoutes.values
          .toList())); // update preferences with currently active routes
    }

    // print('got the stuff in ${stopwatch.elapsed} seconds');

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(_zoomLevel)).toSet(),
        isBus: _isBus);
  }

  Stream<MapState> _mapSaferideSelectionToState(
      MapSaferideSelectionEvent event) async* {
    scrollToLocation(event.dropLatLng);

    _updateTimer.cancel(); //TODO:!! make sure this doesnt break anything
    _currentPolylines.clear();
    _currentMarkers.clear();
    _mapMarkers.clear();
    _currentMarkers
      ..add(
        Marker(
          icon: _pickupIcon,
          infoWindow: InfoWindow(title: "Pickup Point"),
          markerId: MarkerId("saferide_pickup"),
          position: event.pickupLatLng,
          onTap: () {
            _controller!.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  target: event.pickupLatLng, zoom: 18, tilt: 50)),
            );
          },
        ),
      )
      ..add(
        Marker(
          icon: _dropoffIcon,
          infoWindow: InfoWindow(title: "Dropoff Point"),
          markerId: MarkerId("saferide_dropoff"),
          position: event.dropLatLng,
          onTap: () {
            _controller!.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: event.dropLatLng, zoom: 18, tilt: 50)),
            );
          },
        ),
      );

    print(_currentMarkers);

    _currentPolylines.add(Polyline(
        polylineId: PolylineId("fancy_line"),
        width: 5,
        color: Colors.blueGrey,
        patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
        points: _drawFancyLine(event.pickupLatLng, event.dropLatLng)));

    _currentMarkers.addAll(_saferideUpdates.values
        .map((status) => _saferideVehicleToMarker(status)));

    scrollToCurrentLocation();

    yield MapLoadedState(
        polylines: _currentPolylines, markers: _currentMarkers, isBus: false);
  }

  Stream<MapState> _mapUpdateRequestedToState() async* {
    if (_isBus) {
      _busUpdates = await busRepo.getRealtimeUpdate;
    } else {
      if (_shuttleRoutes.isEmpty) {
        yield* _mapDataRequestedToState();
        return;
      }
      _shuttleUpdates = await shuttleRepo.getUpdates;
    }

    if (!_isBus && !shuttleRepo.isConnected!) {
      yield MapErrorState(error: SRError.NETWORK_ERROR);
      return;
    }

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(_zoomLevel)).toSet(),
        isBus: _isBus);
  }

  Stream<MapState> _mapMoveToState() async* {
    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _getMarkerClusters(_zoomLevel).followedBy(_currentMarkers).toSet(),
        isBus: _isBus);
  }

  /// non-state related functions

  /// returns list of points for curved line between two points
  List<LatLng> _drawFancyLine(
    LatLng pickupLocation,
    LatLng destLocation,
  ) {
    // https://gitlab.com/PraveenKishore/maps_curved_line
    List<LatLng> path = [];
    double angle = math.pi / 2;
    double SE =
        SphericalUtils.computeDistanceBetween(pickupLocation, destLocation)
            as double;
    double ME = SE / 2.0;
    double R = ME / math.sin(angle / 2);
    double MO = R * math.cos(angle / 2);

    double heading =
        SphericalUtils.computeHeading(pickupLocation, destLocation) as double;
    LatLng mCoordinate =
        SphericalUtils.computeOffset(pickupLocation, ME, heading);

    double direction =
        (pickupLocation.longitude - destLocation.longitude > 0) ? -1.0 : 1.0;
    double angleFromCenter = 90.0 * direction;
    LatLng oCoordinate = SphericalUtils.computeOffset(
        mCoordinate, MO, heading + angleFromCenter);

    path.add(destLocation);

    int num = 100;

    double initialHeading =
        SphericalUtils.computeHeading(oCoordinate, destLocation) as double;
    double degree = (180.0 * angle) / math.pi;

    for (int i = 1; i <= num; i++) {
      double step = i.toDouble() * (degree / num.toDouble());
      double heading = (-1.0) * direction;
      LatLng pointOnCurvedLine = SphericalUtils.computeOffset(
          oCoordinate, R, initialHeading + heading * step);
      path.add(pointOnCurvedLine);
    }

    path.add(pickupLocation);

    return path;
  }

  void scrollToCurrentLocation({double zoom = 17}) async {
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
            target: loc,
            zoom: zoom,
          ),
        ),
      );
    } else {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(42.729280, -73.679056),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void scrollToLocation(LatLng loc, {double zoom = 18, double tilt = 50}) {
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: zoom, tilt: tilt)),
    );
  }

  /// helper functions
  Future<void> _initMapElements() async {
    final stopMarkerSize = Size(60.sp, 60.sp);
    final vehicleUpdateSize = Size(80.sp, 80.sp);

    _shuttleStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_stop_shuttle.svg',
        size: stopMarkerSize);
    _busStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_stop_bus.svg',
        size: stopMarkerSize);
    _pickupIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_pickup.svg',
        size: stopMarkerSize);
    _dropoffIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_dropoff.svg',
        size: stopMarkerSize);
    _saferideUpdateIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_saferide.svg',
        color: Color(0xe7343f),
        size: vehicleUpdateSize);
    _saferidePickingUpIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_saferide.svg',
        color: Color(0xffbb24),
        size: vehicleUpdateSize);

    // TODO: can probably move this somewhere better
    final shuttleColors = {
      22: Colors.red,
      21: Colors.yellow,
      24: Colors.blue,
      28: Colors.orange
    };

    [22, 21, 24, 28].forEach((id) async {
      _updateIcons[id] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
          'assets/map_icons/marker_vehicle.svg',
          color: shuttleColors[id]!.lighten(0.15),
          size: vehicleUpdateSize);
    });

    [87, 286, 289, 288].forEach((id) async {
      _updateIcons[id] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
          'assets/map_icons/marker_vehicle.svg',
          color: BUS_COLORS[id.toString()]!.lighten(0.15),
          size: vehicleUpdateSize);
    });

    // default white
    _updateIcons[-1] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_vehicle.svg',
        size: vehicleUpdateSize);
  }

  Marker _shuttleStopToMarker(ShuttleStop stop) => Marker(
      icon: _shuttleStopIcon,
      infoWindow: InfoWindow(title: stop.name),
      markerId: MarkerId(stop.id.toString()),
      position: stop.getLatLng,
      onTap: () {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: stop.getLatLng, zoom: 18, tilt: 50)),
        );
      });

  Marker _saferideVehicleToMarker(PositionData position) => Marker(
      icon: position.id == _pickupVehicleId
          ? _saferidePickingUpIcon
          : _saferideUpdateIcon,
      infoWindow: InfoWindow(title: 'Safe Ride going ${position.mph} mph'),
      markerId: MarkerId(position.id),
      position: position.latLng,
      rotation: position.heading,
      onTap: () {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: position.latLng, zoom: 18, tilt: 50)),
        );
      });

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

  MarkerCluster _busStopToMarkerCluster(BusStopSimplified stop) =>
      MarkerCluster(
          id: stop.stopId,
          info: stop.stopName,
          position: stop.getLatLng,
          icon: _busStopIcon,
          controller: _controller);

  Marker _shuttleUpdateToMarker(ShuttleUpdate update) => Marker(
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

  Marker _busUpdateToMarker(BusRealtimeUpdate update) {
    int routeId = int.parse(update.routeId);
    LatLng busPosition = LatLng(update.lat, update.lng);
    // real time update shuttles
    return Marker(
      icon: _updateIcons[_updateIcons.containsKey(routeId) ? routeId : -1]!,
      infoWindow: InfoWindow(title: "Bus ID: ${update.id.toString()}"),
      flat: true,
      markerId: MarkerId(update.id.toString()),
      position: busPosition,
      rotation: double.tryParse(update.bearing) ?? 0.0,
      anchor: Offset(0.5, 0.5),
      onTap: () {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: busPosition, zoom: 18, tilt: 50)),
        );
      },
    );
  }

  Set<Polyline> _getEnabledPolylines() {
    _currentPolylines.clear();
    if (_isBus) {
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

    if (_isBus) {
      List<String> defaultRoutes = busRepo.getDefaultRoutes;
      defaultRoutes.forEach((routeId) {
        _busUpdates[routeId]?.forEach((update) {
          _currentMarkers.add(_busUpdateToMarker(update));
        });
      });

      _enabledBuses!.forEach((route, enabled) {
        if (enabled) {
          if (_busRoutes[route] != null) {
            _busRoutes[route]!.stops!.forEach(
                (stop) => _mapMarkers.add(_busStopToMarkerCluster(stop)));
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
            if (shuttleMarkerMap[id] != null) {
              _currentMarkers.add(shuttleMarkerMap[id]!);
            }
          });
        }
      });
    }

    /// convert cache of saferide positions to markers
    _currentMarkers.addAll(_saferideUpdates.values
        .map((status) => _saferideVehicleToMarker(status)));

    return _currentMarkers;
  }

  Set<Marker> _getMarkerClusters(double zoomLevel) {
    fluster = Fluster<MarkerCluster>(
      minZoom: 14, // The min zoom at clusters will show
      maxZoom: 18, // The max zoom at clusters will show
      radius: 450, // increase for more aggressive clustering vice versa
      extent: 2048, // Tile extent. Radius is calculated with it.
      nodeSize: 64, // Size of the KD-tree leaf node.
      points: _mapMarkers, // The list of markers created before
      createCluster: (
        // Create cluster marker
        BaseCluster? cluster,
        double? lng,
        double? lat,
      ) =>
          MarkerCluster(
              id: cluster?.id.toString(),
              position: LatLng(lat!, lng!),
              icon: this._busStopIcon, // replace with cluster marker
              info: fluster.children(cluster?.id)!.length.toString(),
              isCluster: cluster?.isCluster,
              clusterId: cluster?.id,
              pointsSize: cluster?.pointsSize,
              childMarkerId: cluster?.childMarkerId,
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

class MarkerCluster extends Clusterable {
  final String? id;
  final LatLng position;
  final BitmapDescriptor icon;
  final String? info;
  final GoogleMapController? controller;
  MarkerCluster({
    required this.id,
    required this.position,
    required this.icon,
    this.info,
    this.controller,
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
      markerId: MarkerId(id ?? ''),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      infoWindow: InfoWindow(title: info),
      icon: icon,
      onTap: () {
        controller?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 18,
              tilt: 50)),
        );
      });
  factory MarkerCluster.fromMarker(Marker m) => MarkerCluster(
        id: m.markerId.toString(),
        position: m.position,
        icon: m.icon,
        isCluster: false,
      );
}
