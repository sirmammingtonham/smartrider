part of 'bus_bloc.dart';

abstract class BusEvent extends Equatable {
  const BusEvent();
}

class BusInitDataRequested extends BusEvent {
  const BusInitDataRequested();
  
  @override
  List<Object> get props => [];
}

class BusUpdateRequested extends BusEvent {
  const BusUpdateRequested();

  @override
  List<Object> get props => [];
}
