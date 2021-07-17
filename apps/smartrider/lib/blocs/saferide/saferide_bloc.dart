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
import 'package:smartrider/data/repositories/authentication_repository.dart';
import 'package:smartrider/data/repositories/saferide_repository.dart';
import 'package:shared/util/strings.dart';
import 'package:shared/models/saferide/order.dart';

part 'saferide_event.dart';
part 'saferide_state.dart';

// BIG TODO: use shared prefs or look up in the database if the user has called a ride
// so they dont reset when they leave and reopen the app
class SaferideBloc extends Bloc<SaferideEvent, SaferideState> {
  final places = new GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);
  final PrefsBloc prefsBloc;
  final SaferideRepository saferideRepo;
  final AuthRepository authRepo;

  DocumentReference? currentOrder;
  PlacesDetailsResponse? dropoffDetails, pickupDetails;
  String? dropoffAddress, pickupAddress;
  String? dropoffDescription, pickupDescription;
  GeoPoint? dropoffPoint, pickupPoint;
  StreamSubscription? orderSubscription;

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
              vehicleId: (event as SaferidePickingUpEvent).vehicleId,
              licensePlate: event.licensePlate,
              phoneNumber: event.phoneNumber,
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

  Future<void> endSubscription() async {
    prefsBloc.setCurrentOrderId(null);
    if (orderSubscription != null) {
      await orderSubscription!.cancel();
    }
  }

  /// listens to the order status and creates events accordingly
  Future<void> orderListener(DocumentSnapshot update) async {
    if (!update.exists) {
      await endSubscription();
      return;
    }

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
          final currentDriver =
              (vehicle.get('current_driver') as Map<String, dynamic>);
          add(SaferidePickingUpEvent(
              vehicleId: vehicle.id,
              driverName: currentDriver['name']! as String,
              phoneNumber: currentDriver['phone_number']! as String,
              licensePlate: vehicle.get('license_plate') as String,
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
          //TODO: error handling
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

      orderSubscription = order.listen(orderListener);
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
          await places.getDetailsByPlaceId(event.pickupPrediction!.placeId!);
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
      pickupPoint: pickupPoint!,
      pickupDescription: pickupDescription!,
      dropPoint: dropoffPoint!,
      dropDescription: dropoffDescription!,
      queuePosition: 0, //
    );
  }
}
