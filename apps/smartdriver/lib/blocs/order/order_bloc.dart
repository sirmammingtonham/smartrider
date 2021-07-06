import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/authentication/user.dart';
import 'package:shared/util/errors.dart';
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
      if (orders.isNotEmpty) {
        add(OrderQueueUpdateEvent(latest: orders.first, queue: orders.skip(1)));
      }
    }
  }

  Future<void> updateAvailibility(bool available) async {
    if (available && this.state is OrderWaitingState) {
      // only set state to available if we don't already have an accepted order
      authenticationRepository.setAvailibility(true);
    } else if (!available) {
      authenticationRepository.setAvailibility(false);
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
      case OrderReachedPickupEvent:
        yield* _mapOrderReachedPickupToState(event as OrderReachedPickupEvent);
        break;
      case OrderReachedDropoffEvent:
        yield* _mapOrderReachedDropoffToState(
            event as OrderReachedDropoffEvent);
        break;
      case OrderUserCancelledEvent:
        yield* _mapOrderUserCancelledToState(event as OrderUserCancelledEvent);
        break;
      case OrderDriverCancelledEvent:
        yield* _mapOrderDriverCancelledToState(
            event as OrderDriverCancelledEvent);
        break;
      case OrderErrorEvent:
        yield* _mapOrderErrorToState(event as OrderErrorEvent);
        break;
      default:
        throw Exception("bruh");
    }
  }

  Stream<OrderState> _mapQueueUpdateToState(
      OrderQueueUpdateEvent event) async* {
    SRUser rider = SRUser.fromSnapshot(await event.latest.rider.get());
    yield OrderWaitingState(
        latest: event.latest, latestRider: rider, queue: event.queue);
  }

  Stream<OrderState> _mapOrderAcceptedToState(OrderAcceptedEvent event) async* {
    // commented code not necessary since fields we care about wont change
    // final ref = await orderRepository.acceptOrder(
    //     authenticationRepository.currentDriver, event.order.orderRef);
    // final order = Order.fromSnapshot(await ref.get());
    await orderRepository.acceptOrder(
        authenticationRepository.currentDriver!, event.order.orderRef);
    yield OrderPickingUpState(order: event.order, rider: event.rider);
  }

  Stream<OrderState> _mapOrderReachedPickupToState(
      OrderReachedPickupEvent event) async* {
    await orderRepository.reachedPickupOrder(event.order.orderRef);
    yield OrderDroppingOffState(order: event.order, rider: event.rider);
  }

  Stream<OrderState> _mapOrderReachedDropoffToState(
      OrderReachedDropoffEvent event) async* {
    await orderRepository.reachedDropoffOrder(
        authenticationRepository.currentDriver!, event.order.orderRef);
    yield OrderWaitingState();
  }

  Stream<OrderState> _mapOrderUserCancelledToState(
      OrderUserCancelledEvent event) async* {
    yield OrderErrorState(error: SRError.USER_CANCELLED_ERROR);
    yield OrderWaitingState();
  }

  Stream<OrderState> _mapOrderDriverCancelledToState(
      OrderDriverCancelledEvent event) async* {
    await orderRepository.cancelOrder(authenticationRepository.currentDriver!,
        event.orderRef, event.cancellationReason);
    yield OrderWaitingState();
  }

  Stream<OrderState> _mapOrderErrorToState(OrderErrorEvent event) async* {
    yield OrderErrorState(error: event.error);
    yield OrderWaitingState();
  }
}
