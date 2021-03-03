part of 'saferide_bloc.dart';

abstract class SaferideEvent extends Equatable {
  const SaferideEvent();
}

class SaferideNoEvent extends SaferideEvent {
  @override
  List<Object> get props => [];
}

class SaferideSelectionEvent extends SaferideEvent {
  final LatLng pickupLatLng;
  final Prediction prediction;

  const SaferideSelectionEvent({this.pickupLatLng, this.prediction});

  @override
  List<Object> get props => [pickupLatLng, prediction];
}

class SaferideSelectionTestEvent extends SaferideEvent {
  final testCoord = const LatLng(42.729280, -73.679056);
  final testAdr = "1761 15th St, Troy, NY 12180";
  final testDesc = "Rensselaer Union";
  const SaferideSelectionTestEvent();

  @override
  List<Object> get props => [];
}

// not sure what fields to add to this yet
class SaferideConfirmedEvent extends SaferideEvent {
  const SaferideConfirmedEvent();

  @override
  List<Object> get props => [];
}