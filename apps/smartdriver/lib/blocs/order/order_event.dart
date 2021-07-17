part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderDefaultEvent extends OrderEvent {}

class OrderQueueUpdateEvent extends OrderEvent {
  const OrderQueueUpdateEvent({required this.latest, required this.queue});
  final Order latest;
  final Iterable<Order> queue;

  @override
  List<Object?> get props => [latest, queue];
}

class OrderAcceptedEvent extends OrderEvent {
  const OrderAcceptedEvent({required this.order, required this.rider});
  final Order order;
  final SRUser rider;

  @override
  List<Object?> get props => [order, rider];
}

class OrderReachedPickupEvent extends OrderEvent {
  const OrderReachedPickupEvent({required this.order, required this.rider});
  final Order order;
  final SRUser rider;

  @override
  List<Object?> get props => [order, rider];
}

class OrderReachedDropoffEvent extends OrderEvent {
  const OrderReachedDropoffEvent({required this.order, required this.rider});
  final Order order;
  final SRUser rider;

  @override
  List<Object?> get props => [order, rider];
}

class OrderUserCancelledEvent extends OrderEvent {
  const OrderUserCancelledEvent(
      {required this.orderRef, required this.cancellationReason});
  final DocumentReference orderRef;
  final String cancellationReason;

  @override
  List<Object?> get props => [orderRef];
}

class OrderDriverCancelledEvent extends OrderEvent {
  const OrderDriverCancelledEvent(
      {required this.orderRef, required this.cancellationReason});
  final DocumentReference orderRef;
  final String cancellationReason;

  @override
  List<Object?> get props => [orderRef];
}

class OrderErrorEvent extends OrderEvent {
  const OrderErrorEvent({required this.error});
  final SRError error;

  @override
  List<Object?> get props => [error];
}
