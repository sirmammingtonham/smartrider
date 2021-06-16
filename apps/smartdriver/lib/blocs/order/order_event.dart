part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderDefaultEvent extends OrderEvent {}

class OrderQueueUpdateEvent extends OrderEvent {
  final Order latest;
  final Iterable<Order> queue;

  const OrderQueueUpdateEvent({required this.latest, required this.queue});

  @override
  List<Object?> get props => [latest, queue];
}

class OrderAcceptedEvent extends OrderEvent {
  final Order order;
  final SRUser rider;

  const OrderAcceptedEvent({required this.order, required this.rider});

  @override
  List<Object?> get props => [order, rider];
}

class OrderReachedPickupEvent extends OrderEvent {
  final Order order;
  final SRUser rider;

  const OrderReachedPickupEvent({required this.order, required this.rider});

  @override
  List<Object?> get props => [order, rider];
}

class OrderReachedDropoffEvent extends OrderEvent {
  final Order order;
  final SRUser rider;

  const OrderReachedDropoffEvent({required this.order, required this.rider});

  @override
  List<Object?> get props => [order, rider];
}

class OrderUserCancelledEvent extends OrderEvent {
  final DocumentReference orderRef;
  final String cancellationReason;

  const OrderUserCancelledEvent(
      {required this.orderRef, required this.cancellationReason});

  @override
  List<Object?> get props => [orderRef];
}

class OrderDriverCancelledEvent extends OrderEvent {
  final DocumentReference orderRef;
  final String cancellationReason;

  const OrderDriverCancelledEvent(
      {required this.orderRef, required this.cancellationReason});

  @override
  List<Object?> get props => [orderRef];
}

class OrderErrorEvent extends OrderEvent {
  final SRError error;

  const OrderErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
