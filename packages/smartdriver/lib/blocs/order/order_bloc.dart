import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/driver.dart';
import '../../data/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_exception.dart';
part 'order_state.dart';

// class OrderBloc extends Bloc<OrderEvent, OrderState> {
//   final OrderRepository orderRepository;

//   OrderBloc({required OrderRepository authRepository})
//       : super(OrderDefaultState());

//   @override
//   Stream<OrderState> mapEventToState(
//     OrderEvent event,
//   ) async* {
//     switch (event.runtimeType) {
//       case OrderAcceptedEvent:
//         yield* _mapOrderAcceptedToState(event as OrderAcceptedEvent);
//         break;
//       case OrderCancelledEvent:
//         yield* _mapOrderCancelledToState(event as OrderCancelledEvent);
//         break;
//       case OrderDeclinedEvent:
//         yield* _mapOrderDeclinedToState(event as OrderDeclinedEvent);
//         break;
//     }
//   }

//   Stream<OrderState> _mapOrderAcceptedToState(OrderAcceptedEvent event) async* {
//     yield OrderAcceptedState();
//   }

//   Stream<OrderState> _mapOrderCancelledToState(
//       OrderCancelledEvent event) async* {
//     yield OrderDefaultState();
//   }

//   Stream<OrderState> _mapOrderDeclinedToState(OrderDeclinedEvent event) async* {
//     yield OrderDefaultState();
//   }
// }
