part of 'shuttle_bloc.dart';

abstract class ShuttleEvent extends Equatable {
  const ShuttleEvent();
}

class ShuttleInitDataRequested extends ShuttleEvent {
  const ShuttleInitDataRequested();
  
  @override
  List<Object> get props => [];
}

class ShuttleUpdateRequested extends ShuttleEvent {
  const ShuttleUpdateRequested();

  @override
  List<Object> get props => [];
}
