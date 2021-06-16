import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/authentication/user.dart';
import 'package:shared/models/saferide/driver.dart';
import 'package:shared/models/saferide/order.dart';
import 'package:smartdriver/data/repositories/authentication_repository.dart';
import 'package:smartdriver/data/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_exception.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AuthenticationRepository authenticationRepository;
  final OrderRepository orderRepository;
  late final StreamSubscription orderSubscription;

  OrderBloc(
      {required this.authenticationRepository, required this.orderRepository})
      : super(OrderWaitingState()) {
    orderSubscription = orderRepository.orderStream.listen(orderListener);
  }

  /// listens to changes in order collection and updates the state
  Future<void> orderListener(
      QuerySnapshot<Map<String, dynamic>> collectionSnapshot) async {
    if (this.state is OrderWaitingState) {
      Iterable<Order> orders = collectionSnapshot.docs
          .map((orderSnap) => Order.fromSnapshot(orderSnap));
      add(OrderQueueUpdateEvent(latest: orders.first, queue: orders.skip(1)));
    }
  }

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    switch (event.runtimeType) {
      case OrderQueueUpdateEvent:
        yield* _mapQueueUpdateToState(event as OrderQueueUpdateEvent);
        break;
      case OrderAcceptedEvent:
        yield* _mapOrderAcceptedToState(event as OrderAcceptedEvent);
        break;
      case OrderUserCancelledEvent:
        yield* _mapOrderCancelledToState(event as OrderUserCancelledEvent);
        break;
      case OrderDriverDeclinedEvent:
        yield* _mapOrderDeclinedToState(event as OrderDriverDeclinedEvent);
        break;
    }
  }

  Stream<OrderState> _mapQueueUpdateToState(
      OrderQueueUpdateEvent event) async* {
    SRUser rider = SRUser.fromSnapshot(await event.latest.rider.get());
    yield OrderWaitingState(
        latest: event.latest, latestRider: rider, queue: event.queue);
  }

  Stream<OrderState> _mapOrderAcceptedToState(OrderAcceptedEvent event) async* {
    final ref = await orderRepository.acceptOrder(
        authenticationRepository.currentDriver, event.orderRef);
    yield OrderPickingUpState(
        orderData: ((await ref.get()).data()! as Map<String, dynamic>));
  }

  Stream<OrderState> _mapOrderCancelledToState(
      OrderUserCancelledEvent event) async* {
    yield OrderWaitingState();
  }

  Stream<OrderState> _mapOrderDeclinedToState(
      OrderDriverDeclinedEvent event) async* {
    yield OrderWaitingState();
  }
}
