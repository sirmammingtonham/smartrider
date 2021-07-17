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

enum MapView { kBusView, kShuttleView, kSaferideView }

// TODO: Document this absolute fucking unit
final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

class MapBloc extends Bloc<MapEvent, MapState> {
  static const UPDATE_FREQUENCY =
      const Duration(seconds: 5); // update every 5 sec
  late final Timer _updateTimer;

  final ShuttleRepository shuttleRepo;
  final BusRepository busRepo;
  final SaferideRepository saferideRepo;
  final PrefsBloc prefsBloc;
  final SaferideBloc saferideBloc;

  double _zoomLevel = 14.0;
  MapView _currentView = MapView.kBusView;

  Map<String?, bool?>? _enabledShuttles = {};
  Map<String, bool>? _enabledBuses = {};

  GoogleMapController? _controller;

  Map<String?, BusRoute> _busRoutes = {}; // contains stops
  Map<String?, BusShape> _busShapes = {}; // contains polylines
  Map<String, List<BusRealtimeUpdate>> _busUpdates = {}; // realtime updates

  Map<String?, ShuttleRoute> _shuttleRoutes = {}; // contains polylines
  List<ShuttleStop>? _shuttleStops = []; // contains stops
  List<ShuttleUpdate>? _shuttleUpdates = []; // realtime updates

  final List<MarkerCluster> _markerClusters = [];

  final Map<String, PositionData> _saferideUpdates = {};
  final Set<Marker> _saferideMarkers = <Marker>{};
  final Set<Polyline> _saferidePolylines = <Polyline>{};
  String? _pickupVehicleId;

  final Set<Marker> _currentMarkers = <Marker>{};
  final Set<Polyline> _currentPolylines = <Polyline>{};

  late final BitmapDescriptor _shuttleStopIcon,
      _busStopIcon,
      _saferideUpdateIcon, // generic saferide
      _saferidePickupUpdateIcon, // saferide that is assigned to your order
      _pickupIcon,
      _dropoffIcon;

  final Map<int, BitmapDescriptor> _updateIcons =
      {}; // maps route id to update marker

  late Fluster<MarkerCluster> fluster;
  late final String _lightMapStyle;
  late final String _darkMapStyle;

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

    saferideBloc.stream.listen((saferideState) => add(MapSaferideEvent()));
  }

  @override
  Future<void> close() {
    _updateTimer.cancel();
    return super.close();
  }

  GoogleMapController? get controller => _controller;
  MapView get mapView => _currentView;

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
          yield* _mapDataRequestedToState();
        }
        break;
      case MapUpdateEvent:
        {
          _zoomLevel = (event as MapUpdateEvent).zoomLevel ?? _zoomLevel;
          yield* _mapUpdateRequestedToState();
        }
        break;
      case MapViewChangeEvent:
        {
          if ((event as MapViewChangeEvent).newView != _currentView) {
            _currentView = event.newView;
            yield* _mapUpdateRequestedToState();
          }
        }
        break;
      case MapSaferideEvent:
        {
          // switch map to saferide view
          // which also calls _mapUpdateRequestedToState
          // which then fills in the data for the saferide view
          add(MapViewChangeEvent(newView: MapView.kSaferideView));
        }
        break;
      case MapMoveEvent:
        {
          _zoomLevel = (event as MapMoveEvent).zoomLevel;
          yield MapLoadedState(
              polylines: _currentPolylines,
              markers: _getMarkerClusters(_zoomLevel)
                  .followedBy(_currentMarkers)
                  .toSet(),
              mapView: _currentView);
        }
        break;
      default:
        yield MapErrorState(error: SRError.BLOC_ERROR);
    }
  }

  Stream<MapState> _mapDataRequestedToState() async* {
    // yield MapLoadingState();

    // Stopwatch stopwatch = new Stopwatch()..start();
    switch (_currentView) {
      case MapView.kBusView:
        {
          _busRoutes = await busRepo.getRoutes;
          _busShapes = await busRepo.getPolylines;
          _busUpdates = await busRepo.getRealtimeUpdate;
          prefsBloc.add(PrefsUpdateEvent()); // just to get enabled bus routes
        }
        break;
      case MapView.kShuttleView:
        {
          _shuttleRoutes = await shuttleRepo.getRoutes;
          // try to fetch, then check if shuttle repo is connected
          if (!shuttleRepo.isConnected) {
            yield MapErrorState(error: SRError.NETWORK_ERROR);
            return;
          }
          _shuttleStops = await shuttleRepo.getStops;
          _shuttleUpdates = await shuttleRepo.getUpdates;

          // update preferences with currently active routes
          prefsBloc.add(InitActiveRoutesEvent(_shuttleRoutes.values.toList()));
        }
        break;
      case MapView.kSaferideView:
        {
          /// update vehicle positions in our cache
          saferideRepo.getSaferideLocationsStream().listen((positions) {
            positions.forEach((position) {
              if (position.active) _saferideUpdates[position.id] = position;
            });
          });
        }
        break;
    }
    // print('got the stuff in ${stopwatch.elapsed} seconds');

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(_zoomLevel)).toSet(),
        mapView: _currentView);
  }

  Stream<MapState> _mapUpdateRequestedToState() async* {
    switch (_currentView) {
      case MapView.kBusView:
        {
          _busUpdates = await busRepo.getRealtimeUpdate;
        }
        break;
      case MapView.kShuttleView:
        {
          if (_shuttleRoutes.isEmpty) {
            yield* _mapDataRequestedToState();
            return;
          }
          _shuttleUpdates = await shuttleRepo.getUpdates;
        }
        break;
      case MapView.kSaferideView:
        {
          await _mapSaferideStateToData();
        }
        break;
    }

    _getEnabledMarkers();
    _getEnabledPolylines();

    yield MapLoadedState(
        polylines: _currentPolylines,
        markers:
            _currentMarkers.followedBy(_getMarkerClusters(_zoomLevel)).toSet(),
        mapView: _currentView);
  }

  /// fills the appriate data structures with relevant saferide markers/polylines
  /// so they can be displayed through the mapUpdateToState
  Future<void> _mapSaferideStateToData() async {
    final saferideState = saferideBloc.state;
    switch (saferideState.runtimeType) {
      case SaferideNoState:
        {
          scrollToCurrentLocation();
          _saferideMarkers.clear();
          _saferidePolylines.clear();
        }
        break;
      case SaferideSelectingState:
        {
          _saferideMarkers
            ..add(
              Marker(
                icon: _pickupIcon,
                infoWindow: InfoWindow(title: "Pickup Point"),
                markerId: MarkerId("saferide_pickup"),
                position:
                    (saferideState as SaferideSelectingState).pickupLatLng,
                onTap: () {
                  _controller!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: saferideState.pickupLatLng,
                        zoom: 18,
                        tilt: 50)),
                  );
                },
              ),
            )
            ..add(
              Marker(
                icon: _dropoffIcon,
                infoWindow: InfoWindow(title: "Dropoff Point"),
                markerId: MarkerId("saferide_dropoff"),
                position: saferideState.dropLatLng,
                onTap: () {
                  _controller!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: saferideState.dropLatLng, zoom: 18, tilt: 50)),
                  );
                },
              ),
            );

          _saferidePolylines
            ..add(Polyline(
                polylineId: PolylineId("fancy_line"),
                width: 5,
                color: Colors.blueGrey,
                patterns: [PatternItem.dash(20.0), PatternItem.gap(10)],
                points: _drawFancyLine(
                    saferideState.pickupLatLng, saferideState.dropLatLng)));

          scrollToCurrentLocation(zoom: 16);
        }
        break;
      case SaferidePickingUpState:
        {
          _pickupVehicleId =
              (saferideState as SaferidePickingUpState).vehicleId;
//TODO: we should do something like focus the map on the pickup vehicle as it drives to you
        }
        break;
      case SaferideDroppingOffState:
        {}
        break;
      default:
        {}
        break;
    }
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

  void scrollToLatLng(LatLng loc, {double zoom = 18, double tilt = 50}) {
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: zoom, tilt: tilt)),
    );
  }

  /// helper functions
  Future<void> _initMapElements() async {
    _updateTimer = Timer.periodic(UPDATE_FREQUENCY,
        (Timer t) => add(MapUpdateEvent(zoomLevel: _zoomLevel)));

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
    _saferidePickupUpdateIcon =
        await BitmapHelper.getBitmapDescriptorFromSvgAsset(
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
          ? _saferidePickupUpdateIcon
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
    switch (_currentView) {
      case MapView.kBusView:
        {
          _enabledBuses!.forEach((id, enabled) {
            if (enabled) {
              if (_busShapes[id] != null) {
                _currentPolylines.addAll(_busShapes[id]!.getPolylines);
              }
            }
          });
        }
        break;
      case MapView.kShuttleView:
        {
          _enabledShuttles!.forEach((id, enabled) {
            if (enabled!) {
              _currentPolylines.add(_shuttleRoutes[id]!.getPolyline);
            }
          });
        }
        break;
      case MapView.kSaferideView:
        {
          _currentPolylines.addAll(_saferidePolylines);
        }
        break;
    }
    return _currentPolylines;
  }

  Set<Marker?> _getEnabledMarkers() {
    _currentMarkers.clear();
    _markerClusters.clear();

    switch (_currentView) {
      case MapView.kBusView:
        {
          /// add bus realtime update markers
          busRepo.getDefaultRoutes.forEach((routeId) {
            _busUpdates[routeId]?.forEach((update) {
              _currentMarkers.add(_busUpdateToMarker(update));
            });
          });

          /// add bus stop markers
          _enabledBuses!.forEach((route, enabled) {
            if (enabled) {
              if (_busRoutes[route] != null) {
                _busRoutes[route]!.stops!.forEach((stop) =>
                    _markerClusters.add(_busStopToMarkerCluster(stop)));
              }
            }
          });
        }
        break;
      case MapView.kShuttleView:
        {
          /// add shuttle realtime update markers
          for (final update in _shuttleUpdates!) {
            _currentMarkers.add(_shuttleUpdateToMarker(update));
          }

          /// add shuttle stop markers
          final shuttleMarkerMap = {
            for (final stop in _shuttleStops!)
              stop.id: _shuttleStopToMarker(stop)
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
        break;
      case MapView.kSaferideView:
        {
          /// convert cache of saferide positions to markers
          _currentMarkers.addAll(_saferideUpdates.values
              .map((status) => _saferideVehicleToMarker(status)));

          /// add extra markers (i.e. destination/pickup)
          _currentMarkers.addAll(_saferideMarkers);
        }
        break;
    }

    return _currentMarkers;
  }

  Set<Marker> _getMarkerClusters(double zoomLevel) {
    fluster = Fluster<MarkerCluster>(
      minZoom: 14, // The min zoom at clusters will show
      maxZoom: 18, // The max zoom at clusters will show
      radius: 450, // increase for more aggressive clustering vice versa
      extent: 2048, // Tile extent. Radius is calculated with it.
      nodeSize: 64, // Size of the KD-tree leaf node.
      points: _markerClusters, // The list of markers created before
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
