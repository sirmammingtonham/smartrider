part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderDefaultEvent extends OrderEvent {}

class OrderWaitingEvent extends OrderEvent {}

class OrderPickingUpEvent extends OrderEvent {}

class OrderDroppingOffEvent extends OrderEvent {}

class OrderCancelledEvent extends OrderEvent {}

class OrderErrorEvent extends OrderEvent {}
