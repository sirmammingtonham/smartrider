import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:smartdriver/blocs/order/order_bloc.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> showCancellationDialog(DocumentReference orderRef) async {
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
              BlocProvider.of<OrderBloc>(context).add(OrderDriverCancelledEvent(
                  orderRef: orderRef, cancellationReason: str));
              Navigator.pop(context);
            },
          )));
        });
  }

  Widget waitingStateWidget(OrderWaitingState state) {
    if (state.latest == null) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 25.h),
            Text(
              'Waiting for First Rider',
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 8.h),
            CircularProgressIndicator()
          ],
        ),
      );
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
                                    order: state.latest!,
                                    rider: state.latestRider!));
                          },
                        ),
                        const SizedBox(width: 8),
                        // should we even allow a driver to decline/cancel before accepting?
                        TextButton(
                            child: const Text('DECLINE'),
                            onPressed: () async => await showCancellationDialog(
                                state.latest!.orderRef)),
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

//TODO: add list tile to call rider
  Widget pickingUpStateWidget(OrderPickingUpState state) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Picking up ${state.rider.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              leading: Icon(Icons.face),
              title: Text(state.rider.name),
              subtitle: Text('Rider\'s name'),
            ),
            ListTile(
              leading: Icon(Icons.add_location_alt_rounded),
              title: Text(state.order.pickupAddress),
              subtitle: Text('Tap to Map to Pickup'),
              onTap: () {
                MapsLauncher.launchCoordinates(state.order.pickupPoint.latitude,
                    state.order.pickupPoint.longitude);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text('REACHED PICKUP'),
                  onPressed: () {
                    //TODO: maybe require a confirmation dialogue?
                    BlocProvider.of<OrderBloc>(context).add(
                        OrderReachedPickupEvent(
                            order: state.order, rider: state.rider));
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () async =>
                      await showCancellationDialog(state.order.orderRef),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget droppingOffStateWidget(OrderDroppingOffState state) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Dropping off ${state.rider.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              leading: Icon(Icons.face),
              title: Text(state.rider.name),
              subtitle: Text('Rider\'s name'),
            ),
            ListTile(
              leading: Icon(Icons.wrong_location_rounded),
              title: Text(state.order.dropoffAddress),
              subtitle: Text('Tap to Map to Dropoff'),
              onTap: () {
                MapsLauncher.launchQuery(state.order.dropoffAddress);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text('REACHED DROPOFF'),
                  onPressed: () {
                    //TODO: maybe require a confirmation dialogue?
                    BlocProvider.of<OrderBloc>(context).add(
                        OrderReachedDropoffEvent(
                            order: state.order, rider: state.rider));
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () async =>
                      await showCancellationDialog(state.order.orderRef),
                ),
                const SizedBox(width: 8),
              ],
            ),
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
          print(state.runtimeType);
          switch (state.runtimeType) {
            case OrderWaitingState:
              return waitingStateWidget(state as OrderWaitingState);
            case OrderPickingUpState:
              return pickingUpStateWidget(state as OrderPickingUpState);
            case OrderDroppingOffState:
              return droppingOffStateWidget(state as OrderDroppingOffState);
            case OrderCancelledState:
              return Placeholder();
            case OrderErrorState:
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text((state as OrderErrorState).error.toString()),
                  duration: const Duration(seconds: 10),
                  action: SnackBarAction(
                    label: 'REPORT',
                    onPressed: () {
                      //TODO: add anonymous github issue request or firebase crashlytics
                    },
                  ),
                ));
              }
              return Container();
            default:
              return Placeholder();
          }
        }));
  }
}
