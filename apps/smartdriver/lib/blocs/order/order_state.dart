part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

//WAITING, PICKING_UP, DROPPING_OFF, CANCELLED, ERROR

/// State when driver is waiting to accept an order
class OrderWaitingState extends OrderState {
  const OrderWaitingState({this.latest, this.queue});
  final Order? latest;
  final Iterable<Order>? queue;

  @override
  List<Object?> get props => [latest, queue];
}

class OrderPickingUpState extends OrderState {
  const OrderPickingUpState({required this.order});
  final Order order;

  @override
  List<Object?> get props => [order];
}

class OrderDroppingOffState extends OrderState {
  const OrderDroppingOffState({required this.order});
  final Order order;

  @override
  List<Object?> get props => [order];
}

class OrderCancelledState extends OrderState {}

class OrderErrorState extends OrderState {
  const OrderErrorState({required this.error});
  final SRError error;

  @override
  List<Object?> get props => [error];
}
