part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

//WAITING, PICKING_UP, DROPPING_OFF, CANCELLED, ERROR

class OrderDefaultState extends OrderState {}

class OrderWaitingState extends OrderState {}

class OrderPickingUpState extends OrderState {}

class OrderDroppingOffState extends OrderState {}

class OrderCancelledState extends OrderState {}

class OrderErrorState extends OrderState {}
