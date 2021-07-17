part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

//WAITING, PICKING_UP, DROPPING_OFF, CANCELLED, ERROR

/// State when driver is waiting to accept an order
class OrderWaitingState extends OrderState {
  const OrderWaitingState({this.latest, this.latestRider, this.queue});
  final Order? latest;
  final SRUser? latestRider;
  final Iterable<Order>? queue;

  @override
  List<Object?> get props => [latest, queue];
}

class OrderPickingUpState extends OrderState {
  const OrderPickingUpState({required this.order, required this.rider});
  final Order order;
  final SRUser rider;

  @override
  List<Object?> get props => [order, rider];
}

class OrderDroppingOffState extends OrderState {
  const OrderDroppingOffState({required this.order, required this.rider});
  final Order order;
  final SRUser rider;

  @override
  List<Object?> get props => [order, rider];
}

class OrderCancelledState extends OrderState {}

class OrderErrorState extends OrderState {
  const OrderErrorState({required this.error});
  final SRError error;

  @override
  List<Object?> get props => [error];
}
