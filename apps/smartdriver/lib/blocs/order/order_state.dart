part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

//WAITING, PICKING_UP, DROPPING_OFF, CANCELLED, ERROR

/// State when driver is waiting to accept an order
class OrderWaitingState extends OrderState {
  final Order? latest;
  final SRUser? latestRider;
  final Iterable<Order>? queue;

  const OrderWaitingState({this.latest, this.latestRider, this.queue});

  @override
  List<Object?> get props => [latest, queue];
}

class OrderPickingUpState extends OrderState {
  final Map<String, dynamic> orderData;

  OrderPickingUpState({required this.orderData});

  @override
  List<Object?> get props => [orderData];
}

class OrderDroppingOffState extends OrderState {}

class OrderCancelledState extends OrderState {}

class OrderErrorState extends OrderState {}
