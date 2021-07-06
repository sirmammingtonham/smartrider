import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// import 'package:shared/models/saferide/driver.dart';
import 'package:smartrider/data/repositories/authentication_repository.dart';
import 'package:smartrider/data/repositories/saferide_repository.dart';
import 'package:shared/util/strings.dart';
import 'package:shared/models/saferide/order.dart';

part 'saferide_event.dart';
part 'saferide_state.dart';

// BIG TODO: use shared prefs or look up in the database if the user has called a ride
// so they dont reset when they leave and reopen the app
class SaferideBloc extends Bloc<SaferideEvent, SaferideState> {
  final places = new GoogleMapsPlaces(apiKey: google_api_key);
  final PrefsBloc prefsBloc;
  final SaferideRepository saferideRepo;
  final AuthRepository authRepo;

  DocumentReference? currentOrder;
  PlacesDetailsResponse? dropoffDetails, pickupDetails;
  String? dropoffAddress, pickupAddress;
  String? dropoffDescription, pickupDescription;
  GeoPoint? dropoffPoint, pickupPoint;

  SaferideBloc(
      {required this.prefsBloc,
      required this.saferideRepo,
      required this.authRepo})
      : super(SaferideNoState()) {
    prefsBloc.stream.listen((state) async {
      switch (state.runtimeType) {
        case PrefsLoadedState:
          {
            String? orderId = prefsBloc.getCurrentOrderId();
            if (orderId != null) {
              final snap = await saferideRepo.getOrder(orderId);
              if (snap.exists) {
                currentOrder = snap.reference;
                currentOrder!.snapshots().listen(orderListener);
              }
            }
          }
          break;
        default:
          break;
      }
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<SaferideState> mapEventToState(SaferideEvent event) async* {
    switch (event.runtimeType) {
      case SaferideNoEvent:
        {
          yield SaferideNoState();
        }
        break;
      case SaferideSelectingEvent:
        {
          yield* _mapSaferideSelectionToState(event as SaferideSelectingEvent);
        }
        break;
      case SaferideConfirmedEvent:
        {
          yield* _mapConfirmToState(event as SaferideConfirmedEvent);
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
              licensePlate: (event as SaferidePickingUpEvent).licensePlate,
              phoneNumber: event.driverPhone,
              driverName: event.driverName,
              queuePosition: event.queuePosition,
              estimatedPickup: event.estimatedPickup);
        }
        break;
      case SaferideDroppingOffEvent:
        {
          yield SaferideDroppingOffState();
        }
        break;
      case SaferideUserCancelledEvent:
        {
          yield* _mapCancelToState(event as SaferideUserCancelledEvent);
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

  /// attempts to cancel saferide
  /// true if successful, false if fail
  Stream<SaferideState> _mapCancelToState(
      SaferideUserCancelledEvent event) async* {
    await saferideRepo.cancelOrder();
    yield SaferideNoState();
  }

  /// listens to the order status and creates events accordingly
  Future<void> orderListener(DocumentSnapshot update) async {
    final order = Order.fromSnapshot(update);

    switch (order.status) {
      case 'WAITING':
        {
          prefsBloc.setCurrentOrderId(order.orderRef.id);
          add(SaferideWaitingEvent(
              queuePosition: order.queuePosition ?? -1,
              estimatedPickup: order.estimatedPickup));
        }
        break;
      case 'PICKING_UP':
        {
          final vehicle = await order.vehicleRef!.get();
          print(vehicle.get('current_driver').runtimeType);
          final currentDriver =
              (vehicle.get('current_driver') as Map<String, dynamic>);
          add(SaferidePickingUpEvent(
              driverName: currentDriver['name']!,
              driverPhone: currentDriver['phone_number']!,
              licensePlate: vehicle.get('license_plate'),
              queuePosition: order.queuePosition ?? -1,
              estimatedPickup: order.estimatedPickup));
        }
        break;
      case 'DROPPING_OFF':
        {
          add(SaferideDroppingOffEvent());
        }
        break;
      case 'CANCELLED':
        {
          prefsBloc.setCurrentOrderId(null);
          add(SaferideDriverCancelledEvent(reason: order.cancellationReason!));
        }
        break;
      case 'COMPLETED':
        {
          prefsBloc.setCurrentOrderId(null);
          add(SaferideNoEvent());
        }
        break;
      case 'ERROR':
        {
          prefsBloc.setCurrentOrderId(null);
        }
        break;
      default:
        {
          // should never get here
          print(order.status);
          assert(false); //TODO: error handling

        }
        break;
    }

    // need to add condition to switch state if about to get picked up,
    // can listen to change in order status
  }

  Stream<SaferideState> _mapConfirmToState(
      SaferideConfirmedEvent event) async* {
    //create order, listen to changes in snapshot, update display vars in state
    if (pickupPoint != null && dropoffPoint != null) {
      yield SaferideLoadingState();

      final order = await saferideRepo.createNewOrder(
          user: FirebaseFirestore.instance.doc(
              'users/${authRepo.getActualUser!.uid}'), //TODO: move this and fix auth providers
          pickupAddress: pickupAddress!,
          pickupPoint: pickupPoint!,
          dropoffAddress: dropoffAddress!,
          dropoffPoint: dropoffPoint!);

      order.listen(orderListener);
    } else {
      yield SaferideErrorState(message: 'bruh', status: 'bruh');
    }
  }

  Stream<SaferideState> _mapSaferideSelectionToState(
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
          await places.getDetailsByPlaceId(event.dropoffPrediction!.placeId!);
      pickupAddress = pickupDetails!.result.formattedAddress!;
      pickupDescription = pickupDetails!.result.name;
      pickupPoint = GeoPoint(pickupDetails!.result.geometry!.location.lat,
          pickupDetails!.result.geometry!.location.lng);
    }

    /// if they didn't enter a pickup location, we just use their current location
    if (pickupDetails == null) {
      try {
        Position currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        pickupPoint =
            GeoPoint(currentLocation.latitude, currentLocation.longitude);
        pickupAddress =
            '${currentLocation.latitude}, ${currentLocation.longitude}'; // try to get this in a way that google maps can use
        pickupDescription = 'Current Location';
      } on PermissionDeniedException catch (_) {
        pickupDescription = 'Enter Pickup Location';
      }
    }

    yield SaferideSelectingState(
      pickupPoint: pickupPoint,
      pickupDescription: pickupDescription,
      dropPoint: dropoffPoint,
      dropDescription: dropoffDescription,
      queuePosition: 0, //
    );
  }
}
