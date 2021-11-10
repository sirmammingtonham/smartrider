import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// import 'package:shared/models/saferide/driver.dart';
import 'package:smartrider/blocs/authentication/data/authentication_repository.dart';
import 'package:smartrider/blocs/saferide/data/saferide_repository.dart';
import 'package:shared/util/strings.dart';
import 'package:shared/models/saferide/order.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:ntp/ntp.dart';
import 'dart:math';
part 'saferide_event.dart';
part 'saferide_state.dart';

// BIG TODO: use shared prefs or look up in the database if the user has called
// a ride so they dont reset when they leave and reopen the app
class SaferideBloc extends Bloc<SaferideEvent, SaferideState> {
  SaferideBloc(
      {required this.prefsBloc,
      required this.saferideRepo,
      required this.authRepo})
      : super(const SaferideNoState()) {
    prefsBloc.stream.listen((state) async {
      switch (state.runtimeType) {
        case PrefsLoadedState:
          {
            final orderId = prefsBloc.getCurrentOrderId();
            if (orderId != null) {
              final snap = await saferideRepo.getOrder(orderId);
              if (snap.exists) {
                currentOrder = snap.reference;
                currentOrder!.snapshots().listen(orderListener);
              }
              // TODO: retrieve polylines and stuff so we can display them again
            }
          }
          break;
        default:
          break;
      }
    });
  }

  final places = GoogleMapsPlaces(apiKey: google_api_key);
  final PrefsBloc prefsBloc;
  final SaferideRepository saferideRepo;
  final AuthenticationRepository authRepo;

  DocumentReference? currentOrder;
  PlacesDetailsResponse? dropoffDetails, pickupDetails;
  String? dropoffAddress, pickupAddress;
  String? dropoffDescription, pickupDescription;
  GeoPoint? dropoffPoint, pickupPoint;
  double distance = 0.0;
  StreamSubscription? orderSubscription;

  @override
  Future<void> close() {
    orderSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<SaferideState> mapEventToState(SaferideEvent event) async* {
    switch (event.runtimeType) {
      case SaferideNoEvent:
        {
          yield SaferideNoState(serverTimeStamp: await NTP.now());
        }
        break;
      case SaferideSelectingEvent:
        {
          yield* _mapSelectingToState(event as SaferideSelectingEvent);
        }
        break;
      case SaferideConfirmedEvent:
        {
          yield* _mapConfirmedToState(event as SaferideConfirmedEvent);
        }
        break;
      case SaferideWaitingEvent:
        {
          yield SaferideWaitingState(
              queuePosition: (event as SaferideWaitingEvent).queuePosition,
              estimatedPickup: event.estimatedPickup);
        }
        break;
      case SaferidePickingUpEvent:
        {
          yield SaferidePickingUpState(
              vehicleId: (event as SaferidePickingUpEvent).vehicleId,
              licensePlate: event.licensePlate,
              driverPhone: event.driverPhone,
              driverName: event.driverName,
              queuePosition: event.queuePosition,
              estimatedPickup: event.estimatedPickup);
        }
        break;
      case SaferideDroppingOffEvent:
        {
          yield const SaferideDroppingOffState();
        }
        break;
      case SaferideUserCancelledEvent:
        {
          yield* _mapCancelledToState(event as SaferideUserCancelledEvent);
        }
        break;
      case SaferideDriverCancelledEvent:
        {
          yield SaferideCancelledState(
              reason: (event as SaferideDriverCancelledEvent).reason);
        }
        break;
    }
  }

  /// attempts to cancel saferide true if successful, false if fail
  Stream<SaferideState> _mapCancelledToState(
      SaferideUserCancelledEvent event) async* {
    await saferideRepo.cancelOrder(currentOrder!);
    await endSubscription();
    yield SaferideNoState(serverTimeStamp: await NTP.now());
  }

  Future<void> endSubscription() async {
    prefsBloc.setCurrentOrderId(null);
    await orderSubscription?.cancel();
  }

  /// listens to the order status and creates events accordingly
  Future<void> orderListener(DocumentSnapshot update) async {
    if (!update.exists) {
      await endSubscription();
      return;
    }

    final order = Order.fromSnapshot(update);
    currentOrder = order.orderRef;
    switch (order.status) {
      case 'WAITING':
        {
          prefsBloc.setCurrentOrderId(order.orderRef.id);
          add(SaferideWaitingEvent(
              queuePosition: order.queuePosition,
              estimatedPickup: order.estimatedPickup));
        }
        break;
      case 'PICKING_UP':
        {
          // update pastorders once passengers are picked up
          await saferideRepo.updatePastOrders(distance, order.pickupTime);
          final vehicle = await order.vehicleRef!.get();
          final currentDriver =
              (vehicle.get('current_driver') as Map<String, dynamic>);
          add(SaferidePickingUpEvent(
              vehicleId: vehicle.id,
              driverName: currentDriver['name']! as String,
              driverPhone: currentDriver['phone_number']! as String,
              licensePlate: vehicle.get('license_plate') as String,
              queuePosition: order.queuePosition,
              estimatedPickup: order.estimatedPickup));
        }
        break;
      case 'DROPPING_OFF':
        {
          add(const SaferideDroppingOffEvent());
        }
        break;
      case 'CANCELLED':
        {
          await endSubscription();
          add(SaferideDriverCancelledEvent(reason: order.cancellationReason!));
        }
        break;
      case 'COMPLETED':
        {
          await endSubscription();
          add(SaferideNoEvent());
        }
        break;
      case 'ERROR':
        {
          await endSubscription();
          await FirebaseCrashlytics.instance.recordError(
            Exception('error in saferide bloc'),
            null,
            reason: 'error in saferide bloc',
          );
        }
        break;
      default:
        {
          // should never get here
          await FirebaseCrashlytics.instance.recordError(
            Exception('critical error in saferide bloc'),
            null,
            reason: 'critical error in saferide bloc',
          );
          assert(false);
        }
        break;
    }
  }

  Stream<SaferideState> _mapConfirmedToState(
      SaferideConfirmedEvent event) async* {
    // create order, listen to changes in snapshot, update display vars in state
    if (pickupPoint != null && dropoffPoint != null) {
      yield SaferideLoadingState();
      distance = Geolocator.bearingBetween(
          pickupPoint!.latitude,
          pickupPoint!.longitude,
          dropoffPoint!.latitude,
          dropoffPoint!.longitude);
      final order = await saferideRepo.createOrder(
        pickupAddress: pickupAddress!,
        pickupPoint: pickupPoint!,
        dropoffAddress: dropoffAddress!,
        dropoffPoint: dropoffPoint!,
        distance: distance,
      );

      orderSubscription = order.listen(orderListener);
    } else {
      yield const SaferideErrorState(message: 'bruh', status: 'bruh');
    }
  }

  Stream<SaferideState> _mapSelectingToState(
      SaferideSelectingEvent event) async* {
    if (event.dropoffPrediction != null) {
      dropoffDetails =
          await places.getDetailsByPlaceId(event.dropoffPrediction!.placeId!);
      dropoffAddress = dropoffDetails!.result.formattedAddress!;
      dropoffDescription = dropoffDetails!.result.name;
      dropoffPoint = GeoPoint(dropoffDetails!.result.geometry!.location.lat,
          dropoffDetails!.result.geometry!.location.lng);
    }
    if (event.pickupPrediction != null) {
      pickupDetails =
          await places.getDetailsByPlaceId(event.pickupPrediction!.placeId!);
      pickupAddress = pickupDetails!.result.formattedAddress!;
      pickupDescription = pickupDetails!.result.name;
      pickupPoint = GeoPoint(pickupDetails!.result.geometry!.location.lat,
          pickupDetails!.result.geometry!.location.lng);
    }

    /// if they didn't enter a pickup location, we just use their current
    /// location
    if (pickupDetails == null) {
      try {
        final currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        pickupPoint =
            GeoPoint(currentLocation.latitude, currentLocation.longitude);
        // try to get this in a way that google maps can use
        pickupAddress =
            '${currentLocation.latitude}, ${currentLocation.longitude}';
        pickupDescription = 'Current Location';
      } on PermissionDeniedException catch (_) {
        pickupDescription = 'Enter Pickup Location';
      }
    }

    yield SaferideSelectingState(
      pickupPoint: pickupPoint!,
      pickupDescription: pickupDescription!,
      dropPoint: dropoffPoint!,
      dropDescription: dropoffDescription!,
      queuePosition: await saferideRepo.getQueueSize(),
    );
  }
}
