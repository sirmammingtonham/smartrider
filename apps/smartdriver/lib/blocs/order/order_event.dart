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
  final DocumentReference orderRef;

  const OrderAcceptedEvent({required this.orderRef});

  @override
  List<Object?> get props => [orderRef];
}

class OrderReachedPickupEvent extends OrderEvent {}

class OrderReachedDropoffEvent extends OrderEvent {}

class OrderUserCancelledEvent extends OrderEvent {
  final DocumentReference orderRef;
  final String cancellationReason;

  const OrderUserCancelledEvent(
      {required this.orderRef, required this.cancellationReason});

  @override
  List<Object?> get props => [orderRef];
}

class OrderDriverDeclinedEvent extends OrderEvent {
  final DocumentReference orderRef;
  final String cancellationReason;

  const OrderDriverDeclinedEvent(
      {required this.orderRef, required this.cancellationReason});

  @override
  List<Object?> get props => [orderRef];
}

class OrderErrorEvent extends OrderEvent {}
