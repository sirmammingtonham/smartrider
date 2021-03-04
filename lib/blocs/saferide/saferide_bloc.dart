import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartrider/util/strings.dart';

part 'saferide_event.dart';
part 'saferide_state.dart';

class SaferideBloc extends Bloc<SaferideEvent, SaferideState> {
  final _geocoder = GoogleMapsGeocoding(apiKey: GOOGLE_API_KEY);
  int _queueLength =
      3; // can use firebase to retrieve this (need listener to yield states on change!)
  Prediction _currentPrediction;

  SaferideBloc() : super(SaferideInitialState());

  Stream<SaferideState> mapEventToState(SaferideEvent event) async* {
    if (event is SaferideNoEvent) {
      yield SaferideNoState();
    } else if (event is SaferideSelectionEvent) {
      yield* _mapSaferideSelectionToState(event);
    } else if (event is SaferideSelectionTestEvent) {
      yield* _mapTestToState(event);
    } else if (event is SaferideConfirmedEvent) {
      yield* _mapConfirmToState(event);
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
    // hardcode for now to test ui reactions
    yield SaferideConfirmedState(
        licensePlate: 'H32KHS',
        driverName: 'ya boi',
        queuePosition: _queueLength,
        timeEstimate: 5);
  }

  Stream<SaferideState> _mapTestToState(
      SaferideSelectionTestEvent event) async* {
    LatLng _currentPickupLatLng;
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
        destLatLng: event.testCoord,
        destAddress: event.testAdr,
        destDescription: event.testDesc);
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
    LatLng _currentPickupLatLng = event.pickupLatLng;
    String pickupDescription;
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
      yield SaferideSelectionState(
          pickupLatLng: _currentPickupLatLng,
          pickupDescription: pickupDescription,
          destLatLng: LatLng(r.geometry.location.lat, r.geometry.location.lng),
          destAddress: r.formattedAddress,
          destDescription: _currentPrediction.description);
    }
  }
}
