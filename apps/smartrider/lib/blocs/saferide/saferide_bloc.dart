import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:smartrider/data/repositories/authentication_repository.dart';
import 'package:smartrider/data/repositories/saferide_repository.dart';
import 'package:smartrider/util/strings.dart';
import 'package:shared/models/saferide/order.dart';

part 'saferide_event.dart';
part 'saferide_state.dart';

class SaferideBloc extends Bloc<SaferideEvent, SaferideState> {
  // final _geocoder = GoogleMapsGeocoding(apiKey: GOOGLE_API_KEY);
  final places = new GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);

  final SaferideRepository saferideRepo;
  final AuthRepository authRepo;
  LatLng? _currentPickupLatLng, _currentDropoffLatLng;
  Driver? _currentDriver;

  PlacesDetailsResponse? dropoffDetails, pickupDetails;
  String? dropoffAddress, pickupAddress;
  String? dropoffDescription, pickupDescription;
  GeoPoint? dropoffPoint, pickupPoint;

  SaferideBloc({required this.saferideRepo, required this.authRepo})
      : super(SaferideNoState());

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<SaferideState> mapEventToState(SaferideEvent event) async* {
    if (event is SaferideNoEvent) {
      yield SaferideNoState();
    } else if (event is SaferideSelectionEvent) {
      yield* _mapSaferideSelectionToState(event);
    }
// else if (event is SaferideSelectionTestEvent) {
//       yield* _mapTestToState(event);
//     }
    else if (event is SaferideConfirmedEvent) {
      yield* _mapConfirmToState(event);
    } else if (event is SaferideWaitUpdateEvent) {
      yield SaferideWaitingState(
          queuePosition: event.queuePosition,
          waitEstimate: 0); //event.estimatedPickup);
    } else if (event is SaferideAcceptedEvent) {
      yield SaferideAcceptedState(
          licensePlate: event.licensePlate,
          driverName: event.driverName,
          queuePosition: event.queuePosition,
          waitEstimate: event.waitEstimate);
    } else if (event is SaferideCancelEvent) {
      yield* _mapCancelToState(event);
    }
  }

  /// attempts to cancel saferide
  /// true if successful, false if fail
  Stream<SaferideState> _mapCancelToState(SaferideCancelEvent event) async* {
    await saferideRepo.cancelOrder();
    yield SaferideNoState();
  }

  /// listens to the order status and creates events accordingly
  Future<void> orderListener(DocumentSnapshot update) async {
    final order = Order.fromSnapshot(update);

    switch (order.status) {
      case 'WAITING':
        {
          add(SaferideWaitUpdateEvent(
              queuePosition: order.queuePosition ?? -1,
              estimatedPickup: order.estimatedPickup));
        }
        break;
      case 'PICKING_UP':
        {
          // _currentDriver = order.driver;
          // add(SaferideAcceptedEvent(
          //     driverName: _currentDriver!.name,
          //     licensePlate: _currentDriver!.licensePlate,
          //     queuePosition: order.queuePosition ?? -1,
          //     waitEstimate: order.estimate?.remainingDuration ?? -1));
        }
        break;
      default:
        print(order.status);
        break;
    }

    // need to add condition to switch state if about to get picked up,
    // can listen to change in order status
  }

  Stream<SaferideState> _mapConfirmToState(
      SaferideConfirmedEvent event) async* {
    //create order, listen to changes in snapshot, update display vars in state
    if (_currentPickupLatLng != null && _currentDropoffLatLng != null) {
      yield SaferideLoadingState();

      // final order = await saferideRepo.createOrder(Order(
      //   status: TripStatus.NEW,
      //   pickup: GeoPoint(
      //       _currentPickupLatLng!.latitude, _currentPickupLatLng!.longitude),
      //   dropoff: GeoPoint(
      //       _currentDropoffLatLng!.latitude, _currentDropoffLatLng!.longitude),
      //   rider: authRepo.getUser,
      // ));

      // order.listen(orderListener);

      // TODO: add state while waiting for saferide to pickup
    } else {
      yield SaferideErrorState(message: 'bruh', status: 'bruh');
    }
  }

  Stream<SaferideState> _mapSaferideSelectionToState(
      SaferideSelectionEvent event) async* {
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

    yield SaferideSelectionState(
      pickupPoint: pickupPoint,
      pickupDescription: pickupDescription,
      dropPoint: dropoffPoint,
      dropDescription: dropoffDescription,
      queuePosition: 0, //
    );
  }
}
