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

  SaferideSelectionEvent({this.pickupLatLng, this.prediction});

  @override
  List<Object> get props => [pickupLatLng, prediction];
}

class SaferideSelectionTestEvent extends SaferideEvent {
  final testCoord = LatLng(42.729280, -73.679056);
  final testAdr = "1761 15th St, Troy, NY 12180";
  final testDesc = "Rensselaer Union";
  SaferideSelectionTestEvent();

  @override
  List<Object> get props => [];
}

// class SaferideSelectionEvent extends SaferideEvent {
//   final LatLng coordinate;
//   final String address;
//   final String description;

//   SaferideSelectionEvent(
//       {@required this.coordinate,
//       @required this.address,
//       @required this.description});

//   @override
//   List<Object> get props => [coordinate, address];
// }
