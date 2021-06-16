import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smartdriver/blocs/order/order_bloc.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget waitingStateWidget(OrderWaitingState state) {
    if (state.latest == null) {
      return Placeholder(); // replace with "no new orders widget and loading circle"
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Column(
          children: [
            /// card showing the most recent order they can accept
            /// might want to have the card be the only part that changes with bloc, idk
            Card(
              margin: EdgeInsets.symmetric(vertical: 3.h),
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'New Rider Waiting!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(Icons.face),
                      title: Text(state.latestRider!.name),
                      subtitle: Text('Rider\'s name'),
                    ),
                    ListTile(
                      leading: Icon(Icons.add_location_alt_rounded),
                      title: Text(state.latest!.pickupAddress),
                      subtitle: Text('Pickup'),
                    ),
                    ListTile(
                      leading: Icon(Icons.wrong_location_rounded),
                      title: Text(state.latest!.dropoffAddress),
                      subtitle: Text('Dropoff'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: const Text('ACCEPT'),
                          onPressed: () {
                            BlocProvider.of<OrderBloc>(context).add(
                                OrderAcceptedEvent(
                                    orderRef: state.latest!.orderRef));
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('DECLINE'),
                          onPressed: () async {
                            /* we have to make them give a reason for cancellation */
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      child: Card(
                                          child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Reason for cancellation.',
                                        hintText: 'Reason for cancellation.'),
                                    onFieldSubmitted: (String str) {
                                      BlocProvider.of<OrderBloc>(context).add(
                                          OrderDriverDeclinedEvent(
                                              orderRef: state.latest!.orderRef,
                                              cancellationReason: str));
                                    },
                                  )));
                                });
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// spacer
            Container(height: 1.h),

            Center(
              child: Text(
                'Riders in Queue: ${0}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            /// A list of future orders
            ListView(
                shrinkWrap: true,
                children: state.queue!
                    .map((order) => ListTile(
                        title: Text(order.rider.id),
                        subtitle: Text(order.status),
                        trailing: Icon(Icons.bookmark)))
                    .toList())
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        // might have to wrap in blocbuilder to react to acceptance but idk if we want to do that here
        body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
          switch (state.runtimeType) {
            case OrderWaitingState:
              return waitingStateWidget(state as OrderWaitingState);
            case OrderPickingUpState:
              return Placeholder();
            case OrderDroppingOffState:
              return Placeholder();
            case OrderCancelledState:
              return Placeholder();
            case OrderErrorState:
              return Placeholder();
            default:
              return Placeholder();
          }
        }));
  }
}
