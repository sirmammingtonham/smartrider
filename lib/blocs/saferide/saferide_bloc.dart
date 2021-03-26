import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartrider/data/models/saferide/driver.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';
import 'package:smartrider/data/repository/saferide_repository.dart';
import 'package:smartrider/util/strings.dart';
import 'package:smartrider/data/models/saferide/order.dart';

part 'saferide_event.dart';
part 'saferide_state.dart';

class SaferideBloc extends Bloc<SaferideEvent, SaferideState> {
  final _geocoder = GoogleMapsGeocoding(apiKey: GOOGLE_API_KEY);
  final SaferideRepository saferideRepo;
  final AuthRepository authRepo;
  Prediction _currentPrediction;
  LatLng _currentPickupLatLng,
      _currentDropoffLatLng = const LatLng(42.729280, -73.679056);
  Driver _currentDriver;

  SaferideBloc({@required this.saferideRepo, @required this.authRepo})
      : super(SaferideInitialState());

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<SaferideState> mapEventToState(SaferideEvent event) async* {
    if (event is SaferideNoEvent) {
      yield SaferideNoState();
    } else if (event is SaferideSelectionEvent) {
      yield* _mapSaferideSelectionToState(event);
    } else if (event is SaferideSelectionTestEvent) {
      yield* _mapTestToState(event);
    } else if (event is SaferideConfirmedEvent) {
      yield* _mapConfirmToState(event);
    } else if (event is SaferideAcceptedEvent) {
      yield SaferideAcceptedState(
          licensePlate: event.licensePlate,
          driverName: event.driverName,
          queuePosition: event.queuePosition,
          waitEstimate: event.waitEstimate);
    } else if (event is SaferideCancelEvent) {
      if (_cancelSaferide()) {
        yield SaferideNoState();
      } else {
        yield SaferideErrorState(status: 'FAIL', message: 'Couldn\'t cancel');
      }
    }
  }

  /// attempts to cancel saferide
  /// true if successful, false if fail
  bool _cancelSaferide() {
    return true;
  }

  Stream<SaferideState> _mapConfirmToState(
      SaferideConfirmedEvent event) async* {
    //create order, listen to changes in snapshot, update display vars in state
    if (_currentPickupLatLng != null && _currentDropoffLatLng != null) {
      yield SaferideLoadingState();

      final order = await saferideRepo.createOrder(
          order: Order(
        status: "NEW",
        pickup: GeoPoint(
            _currentPickupLatLng.latitude, _currentPickupLatLng.longitude),
        dropoff: GeoPoint(
            _currentDropoffLatLng.latitude, _currentDropoffLatLng.longitude),
        rider: authRepo.getUser(),
        createdAt: DateTime.now(),
      ));

      order.listen((DocumentSnapshot update) async {
        final order = update.data();
        print(update.data()['status']);
        // if (order['status'] == 'NEW') return;

        // _currentDriver = Driver.fromDocument(order['driver']);

        int queuePos = update.data()['queue_position'];
        //await saferideRepo.getOrderPosition(order: update);
        add(SaferideAcceptedEvent(
            driverName: _currentDriver?.name ?? '',
            licensePlate: _currentDriver?.licensePlate ?? '',
            queuePosition: queuePos ?? -1,
            waitEstimate: order['wait_estimate'] ?? -1));

        // need to add condition to switch state if about to get picked up,
        // can listen to change in order status
      });

      // TODO: add state while waiting for saferide to pickup
    } else {
      yield SaferideErrorState(message: 'bruh', status: 'bruh');
    }
  }

  Stream<SaferideState> _mapTestToState(
      SaferideSelectionTestEvent event) async* {
    String pickupDescription;

    try {
      Position currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _currentPickupLatLng =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      pickupDescription = 'Current Location';
    } on PermissionDeniedException catch (_) {
      pickupDescription = 'Choose on Map';
    }

    yield SaferideSelectionState(
        pickupLatLng: _currentPickupLatLng,
        pickupDescription: pickupDescription,
        dropLatLng: event.testCoord,
        dropAddress: event.testAdr,
        dropDescription: event.testDesc);
  }

  // TODO: add logic to calculate route, we want polylines at this point!
  Stream<SaferideState> _mapSaferideSelectionToState(
      SaferideSelectionEvent event) async* {
    if (_currentPrediction == null && event.prediction == null) return;
    if (event.prediction != null) {
      _currentPrediction = event.prediction;
    }

    final GeocodingResponse responses =
        await _geocoder.searchByPlaceId(_currentPrediction.placeId);
    if (responses.status != 'OK') {
      yield SaferideErrorState(
          status: responses.status, message: responses.errorMessage);
    }

    String pickupDescription;
    _currentPickupLatLng = event.pickupLatLng;
    if (_currentPickupLatLng == null) {
      try {
        Position currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        _currentPickupLatLng =
            LatLng(currentLocation.latitude, currentLocation.longitude);
        pickupDescription = 'Current Location';
      } on PermissionDeniedException catch (_) {
        pickupDescription = 'Choose on Map';
      }
    }

    if (responses.results.isNotEmpty) {
      GeocodingResult r = responses.results[0];
      _currentDropoffLatLng =
          LatLng(r.geometry.location.lat, r.geometry.location.lng);
      yield SaferideSelectionState(
          pickupLatLng: _currentPickupLatLng,
          pickupDescription: pickupDescription,
          dropLatLng: _currentDropoffLatLng,
          dropAddress: r.formattedAddress,
          dropDescription: _currentPrediction.description);
    }
  }
}
