// implementation imports
import 'dart:async';
import 'dart:math' as math;

// bloc imports
import 'package:equatable/equatable.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
// map imports
// import 'package:hypertrack_views_flutter/hypertrack_views_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/models/bus/bus_realtime_update.dart';
// import 'package:shared/models/saferide/driver.dart';

import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
//import 'package:shared/models/bus/bus_vehicle_update.dart';
import 'package:shared/models/saferide/position_data.dart';
// model imports
import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:shared/models/shuttle/shuttle_update.dart';
import 'package:shared/util/bitmap_helpers.dart';
import 'package:shared/util/errors.dart';
// import 'package:shared/util/math_util.dart';
import 'package:shared/util/spherical_utils.dart';
// repository imports
import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:smartrider/blocs/map/data/shuttle_repository.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/data/saferide_repository.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';

part 'map_event.dart';
part 'map_state.dart';

/// Enum representing different map views (layers)
enum MapView {
  /// view that represents bus view
  kBusView,

  /// view that represents
  kShuttleView,

  ///
  kSaferideView
}

// TODO: Document this absolute fucking unit

///
final LatLngBounds rpiBounds = LatLngBounds(
  southwest: const LatLng(42.691255, -73.698129),
  northeast: const LatLng(42.751583, -73.616713),
);

/// Class that implements the bloc pattern for the map
class MapBloc extends Bloc<MapEvent, MapState> {
  /// MapBloc named constructor
  MapBloc({
    required this.shuttleRepo,
    required this.busRepo,
    required this.saferideRepo,
    required this.saferideBloc,
    required this.prefsBloc,
  }) : super(const MapLoadingState()) {
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
        // if (_controller != null) {
        //   _controller!.setMapStyle(
        //       prefsState.theme.brightness == Brightness.dark
        //           ? _darkMapStyle
        //           : _lightMapStyle);
        // }
      }
    });

    saferideBloc.stream.listen((saferideState) {
      if (saferideState is! SaferideNoState) {
        add(const MapSaferideEvent());
      }
    });
  }

  /// Shuttle data repository
  final ShuttleRepository shuttleRepo;

  /// Bus data repository
  final BusRepository busRepo;

  /// Saferide data repository
  final SaferideRepository saferideRepo;

  /// Preferences Bloc

  final PrefsBloc prefsBloc;

  /// Saferide Bloc
  final SaferideBloc saferideBloc;

  double _zoomLevel = 14;
  MapView _currentView = MapView.kBusView;

  Map<String, bool> _enabledShuttles = {};
  Map<String, bool> _enabledBuses = {};

  GoogleMapController? _controller;

  Map<String, BusRoute> _busRoutes = {}; // contains stops
  Map<String, BusShape> _busShapes = {}; // contains polylines
  Map<String, List<BusRealtimeUpdate>> _busUpdates = {}; // realtime updates

  Map<String, ShuttleRoute> _shuttleRoutes = {}; // contains polylines
  List<ShuttleStop> _shuttleStops = []; // contains stops
  List<ShuttleUpdate> _shuttleUpdates = []; // realtime updates

  final List<MarkerCluster> _markerClusters = [];

  final Map<String, PositionData> _saferideUpdates = {};
  final Set<Marker> _saferideMarkers = <Marker>{};
  final Set<Polyline> _saferidePolylines = <Polyline>{};
  String? _pickupVehicleId;

  final stopMarkerSize = const Size(82, 82);
  final vehicleUpdateSize = const Size(110, 110);

  late Fluster<MarkerCluster> _fluster;
  final Set<Marker> _currentMarkers = <Marker>{};
  final Set<Polyline> _currentPolylines = <Polyline>{};

  late final BitmapDescriptor _shuttleStopIcon,
      _busStopIcon,
      _saferideUpdateIcon, // generic saferide
      _saferidePickupUpdateIcon, // saferide that is assigned to your order
      _pickupIcon,
      _dropoffIcon;

  final Map<String, BitmapDescriptor> _updateIcons =
      {}; // maps route id to update marker

  static const _updateFrequency = Duration(seconds: 5); // update every 5 sec

  Timer? _updateTimer;
  late final String _lightMapStyle;
  late final String _darkMapStyle;

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }

  /// getter for map controller
  GoogleMapController? get controller => _controller;

  /// getter for the current mapview
  MapView get mapView => _currentView;

  ///
  Map<String, BusRoute> get busRoutes => _busRoutes;

  ///
  Map<String, ShuttleRoute> get shuttleRoutes => _shuttleRoutes;

  void updateController(BuildContext context, GoogleMapController controller) {
    _controller = controller;
    _controller!.setMapStyle(
      Theme.of(context).brightness == Brightness.dark
          ? _darkMapStyle
          : _lightMapStyle,
    );
  }

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

      case MapThemeChangeEvent:
        {
          if (_controller != null) {
            await _controller!.setMapStyle(
              (event as MapThemeChangeEvent).theme.brightness == Brightness.dark
                  ? _darkMapStyle
                  : _lightMapStyle,
            );
          }
          yield MapLoadedState(
            polylines: _currentPolylines,
            markers: _currentMarkers
                .followedBy(_getMarkerClusters(_zoomLevel))
                .toSet(),
            mapView: _currentView,
          );
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
          add(const MapViewChangeEvent(newView: MapView.kSaferideView));
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
            mapView: _currentView,
          );
        }
        break;
      default:
        yield const MapErrorState(error: SRError.blocErorr);
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
          prefsBloc
              .add(const PrefsUpdateEvent()); // just to get enabled bus routes
          await _initBusMarkers();
        }
        break;
      case MapView.kShuttleView:
        {
          _shuttleRoutes = await shuttleRepo.getRoutes;
          // try to fetch, then check if shuttle repo is connected
          if (!shuttleRepo.isConnected) {
            yield const MapErrorState(error: SRError.networkError);
            return;
          }
          _shuttleStops = await shuttleRepo.getStops;
          _shuttleUpdates = await shuttleRepo.getUpdates;

          // update preferences with currently active routes
          prefsBloc.add(
            InitActiveRoutesEvent(
              _shuttleRoutes.values.where((route) => route.active).toList(),
            ),
          );
          await _initShuttleMarkers();
        }
        break;
      case MapView.kSaferideView:
        {
          /// update vehicle positions in our cache
          saferideRepo.getSaferideLocationsStream().listen((positions) {
            for (final position in positions) {
              if (position.active) _saferideUpdates[position.id] = position;
            }
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
      mapView: _currentView,
    );
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
      mapView: _currentView,
    );
  }

  /// fills the appriate data structures with relevant saferide markers/polylines
  /// so they can be displayed through the mapUpdateToState
  Future<void> _mapSaferideStateToData() async {
    final saferideState = saferideBloc.state;
    switch (saferideState.runtimeType) {
      case SaferideNoState:
        {
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
                infoWindow: const InfoWindow(title: 'Pickup Point'),
                markerId: const MarkerId('saferide_pickup'),
                position:
                    (saferideState as SaferideSelectingState).pickupLatLng,
                onTap: () {
                  _controller!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: saferideState.pickupLatLng,
                        zoom: 18,
                        tilt: 50,
                      ),
                    ),
                  );
                },
              ),
            )
            ..add(
              Marker(
                icon: _dropoffIcon,
                infoWindow: const InfoWindow(title: 'Dropoff Point'),
                markerId: const MarkerId('saferide_dropoff'),
                position: saferideState.dropLatLng,
                onTap: () {
                  _controller!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: saferideState.dropLatLng,
                        zoom: 18,
                        tilt: 50,
                      ),
                    ),
                  );
                },
              ),
            );

          _saferidePolylines.add(Polyline(
              polylineId: const PolylineId('fancy_line'),
              width: 5,
              color: Colors.blueGrey,
              patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              points: _drawFancyLine(
                  saferideState.pickupLatLng, saferideState.dropLatLng,),),);

          scrollToCurrentLocation(zoom: 16);
        }
        break;
      case SaferidePickingUpState:
        {
          _pickupVehicleId =
              (saferideState as SaferidePickingUpState).vehicleId;
//TODO: we should do something like focus the map on the pickup vehicle
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
    final path = <LatLng>[];
    final angle = math.pi / 2;
    final se =
        SphericalUtils.computeDistanceBetween(pickupLocation, destLocation)
            as double;
    final me = se / 2.0;
    final r = me / math.sin(angle / 2);
    final mo = r * math.cos(angle / 2);

    final heading =
        SphericalUtils.computeHeading(pickupLocation, destLocation) as double;
    final mCoordinate =
        SphericalUtils.computeOffset(pickupLocation, me, heading);

    final direction =
        (pickupLocation.longitude - destLocation.longitude > 0) ? -1.0 : 1.0;
    final angleFromCenter = 90.0 * direction;
    final oCoordinate = SphericalUtils.computeOffset(
      mCoordinate,
      mo,
      heading + angleFromCenter,
    );

    path.add(destLocation);

    const num = 100;

    final initialHeading =
        SphericalUtils.computeHeading(oCoordinate, destLocation) as double;
    final degree = (180.0 * angle) / math.pi;

    for (var i = 1; i <= num; i++) {
      final step = i.toDouble() * (degree / num.toDouble());
      final heading = (-1.0) * direction;
      final pointOnCurvedLine = SphericalUtils.computeOffset(
        oCoordinate,
        r,
        initialHeading + heading * step,
      );
      path.add(pointOnCurvedLine);
    }

    path.add(pickupLocation);

    return path;
  }

  void scrollToCurrentLocation({double zoom = 17}) async {
    Position currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } on PermissionDeniedException catch (_) {
      return;
    }

    final loc = LatLng(currentLocation.latitude, currentLocation.longitude);

    if (rpiBounds.contains(loc)) {
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: loc,
            zoom: zoom,
          ),
        ),
      );
    } else {
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(42.729280, -73.679056),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void scrollToLatLng(LatLng loc, {double zoom = 18, double tilt = 50}) {
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: zoom, tilt: tilt,),),
    );
  }

  /// helper functions
  Future<void> _initMapElements() async {
    _updateTimer ??= Timer.periodic(
      _updateFrequency,
      (Timer t) => add(MapUpdateEvent(zoomLevel: _zoomLevel)),
    );

    _shuttleStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_stop_shuttle.svg',
        size: stopMarkerSize,);
    _busStopIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_stop_bus.svg',
        size: stopMarkerSize,);
    _pickupIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_pickup.svg',
        size: stopMarkerSize,);
    _dropoffIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_dropoff.svg',
        size: stopMarkerSize,);
    _saferideUpdateIcon = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_saferide.svg',
        size: vehicleUpdateSize,);
    _saferidePickupUpdateIcon =
        await BitmapHelper.getBitmapDescriptorFromSvgAsset(
            'assets/map_icons/marker_saferide_alt.svg',
            size: vehicleUpdateSize,);

    // default white
    _updateIcons['-1'] = await BitmapHelper.getBitmapDescriptorFromSvgAsset(
        'assets/map_icons/marker_vehicle.svg',
        size: vehicleUpdateSize,);
  }

  Future<void> _initBusMarkers() async {
    for (final key in _busRoutes.keys) {
      final busId = _busRoutes[key]!.routeShortName!;
      _updateIcons['bus_$busId'] =
          await BitmapHelper.getBitmapDescriptorFromSvgAsset(
              'assets/map_icons/marker_vehicle.svg',
              color: busColors[busId]!.lighten(0.15),
              size: vehicleUpdateSize,);
    }
  }

  Future<void> _initShuttleMarkers() async {
    for (final key in _shuttleRoutes.keys) {
      final shuttleId = _shuttleRoutes[key]!.id.toString();
      if (_shuttleRoutes[key]!.active == true) {
        _updateIcons[shuttleId] =
            await BitmapHelper.getBitmapDescriptorFromSvgAsset(
                'assets/map_icons/marker_vehicle.svg',
                color: _shuttleRoutes[key]!.color,
                size: vehicleUpdateSize,);
      }
    }
  }

  Marker _shuttleStopToMarker(ShuttleStop stop) => Marker(
      icon: _shuttleStopIcon,
      infoWindow: InfoWindow(title: stop.name),
      markerId: MarkerId(stop.id.toString()),
      position: stop.getLatLng,
      onTap: () {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: stop.getLatLng, zoom: 18, tilt: 50,),),
        );
      },);

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
              CameraPosition(target: position.latLng, zoom: 18, tilt: 50,),),
        );
      },);

  /// TODO: focusing bus stop marker shows name and stuff
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
          controller: _controller,);

  Marker _shuttleUpdateToMarker(ShuttleUpdate update) {
    return Marker(
        icon: _updateIcons[update.routeId.toString()] ?? _updateIcons['-1']!,
        infoWindow: InfoWindow(
            title: 'Shuttle #${update.vehicleId.toString()} '
                'on Route ${update.routeId}',),
        flat: true,
        markerId: MarkerId(update.id.toString()),
        position: update.getLatLng,
        rotation: update.heading as double,
        anchor: const Offset(0.5, 0.5),
        onTap: () {
          _controller!.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: update.getLatLng, zoom: 18, tilt: 50),),
          );
        },);
  }

  Marker _busUpdateToMarker(BusRealtimeUpdate update) {
    final busPosition = LatLng(update.lat, update.lng);
    // real time update shuttles
    return Marker(
      icon: _updateIcons['bus_${update.routeId}'] ?? _updateIcons['-1']!,
      infoWindow: InfoWindow(
          title: 'Bus #${update.id.toString()} '
              'on Route ${update.routeId}',),
      flat: true,
      markerId: MarkerId(update.id.toString()),
      position: busPosition,
      rotation: double.tryParse(update.bearing) ?? 0.0,
      anchor: const Offset(0.5, 0.5),
      onTap: () {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: busPosition, zoom: 18, tilt: 50),),
        );
      },
    );
  }

  Set<Polyline> _getEnabledPolylines() {
    _currentPolylines.clear();
    switch (_currentView) {
      case MapView.kBusView:
        {
          _enabledBuses.forEach((id, enabled) {
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
          _enabledShuttles.forEach((id, enabled) {
            if (enabled) {
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
          for (final routeId in busRepo.getDefaultRoutes) {
            if (_busUpdates[routeId] != null) {
              for (final update in _busUpdates[routeId]!) {
                _currentMarkers.add(_busUpdateToMarker(update));
              }
            }
          }

          /// add bus stop markers
          for (final route in _enabledBuses.keys) {
            if (_enabledBuses[route]!) {
              if (_busRoutes[route] != null) {
                for (final stop in _busRoutes[route]!.stops!) {
                  _markerClusters.add(_busStopToMarkerCluster(stop));
                }
              }
            }
          }
        }
        break;
      case MapView.kShuttleView:
        {
          /// add shuttle realtime update markers
          for (final update in _shuttleUpdates) {
            _currentMarkers.add(_shuttleUpdateToMarker(update));
          }

          /// add shuttle stop markers
          final shuttleMarkerMap = {
            for (final stop in _shuttleStops)
              stop.id: _shuttleStopToMarker(stop)
          };

          for (final route in _enabledShuttles.keys) {
            if (_enabledShuttles[route]!) {
              for (final id in _shuttleRoutes[route]!.stopIds) {
                if (shuttleMarkerMap[id] != null) {
                  _currentMarkers.add(shuttleMarkerMap[id]!);
                }
              }
            }
          }
        }
        break;
      case MapView.kSaferideView:
        {
          /// convert cache of saferide positions to markers
          /// and add extra markers (i.e. destination/pickup)
          _currentMarkers
            ..addAll(_saferideUpdates.values.map(_saferideVehicleToMarker))
            ..addAll(_saferideMarkers);
        }
        break;
    }

    return _currentMarkers;
  }

  Set<Marker> _getMarkerClusters(double zoomLevel) {
    _fluster = Fluster<MarkerCluster>(
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
              icon: _busStopIcon, // replace with cluster marker
              info: _fluster.children(cluster?.id)!.length.toString(),
              isCluster: cluster?.isCluster,
              clusterId: cluster?.id,
              pointsSize: cluster?.pointsSize,
              childMarkerId: cluster?.childMarkerId,
              controller: _controller,),
    );

    return _fluster
        .clusters([
          rpiBounds.southwest.longitude,
          rpiBounds.southwest.latitude,
          rpiBounds.northeast.longitude,
          rpiBounds.northeast.latitude
        ], zoomLevel.round(),)
        .map((cluster) => cluster.toMarker())
        .toSet();
  }
}

class MarkerCluster extends Clusterable {
  MarkerCluster({
    required this.id,
    required this.position,
    required this.icon,
    this.info,
    this.controller,
    bool? isCluster = false,
    int? clusterId,
    int? pointsSize,
    String? childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  factory MarkerCluster.fromMarker(Marker m) => MarkerCluster(
        id: m.markerId.toString(),
        position: m.position,
        icon: m.icon,
        isCluster: false,
      );

  final String? id;
  final LatLng position;
  final BitmapDescriptor icon;
  final String? info;
  final GoogleMapController? controller;

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
              tilt: 50,),),
        );
      },);
}
