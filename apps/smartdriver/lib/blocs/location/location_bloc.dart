import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationNotTrackingState());
  StreamSubscription<Position>? positionStream;
  late DocumentReference vehicleRef;

  @override
  Future<void> close() async {
    await positionStream?.cancel();
    await super.close();
  }

  void positionListener(Position position) {
    print('${position.latitude}, ${position.longitude}');
    vehicleRef.update({
      'position_data': {
        'location': GeoPoint(position.latitude, position.longitude),
        'heading': position.heading,
        'speed': position.speed
      }
    });
  }

  void positionErrorListener(Object error, StackTrace trace) {}

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case LocationStartTrackingEvent:
        vehicleRef = (event as LocationStartTrackingEvent).vehicleRef;
        {
          positionStream = Geolocator.getPositionStream(distanceFilter: 20)
              .listen(positionListener, onError: positionErrorListener);
          //TODO: make sure they enable location permissions
        }
        break;
      case LocationStopTrackingEvent:
        {
          await positionStream?.cancel();
        }
        break;
    }
  }
}
