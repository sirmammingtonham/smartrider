import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:smartdriver/blocs/authentication/authentication_bloc.dart';
import 'package:smartdriver/blocs/order/order_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> showCancellationDialog(DocumentReference orderRef) async {
    await showDialog<Dialog>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Card(
                  child: TextFormField(
            decoration: const InputDecoration(
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
            const Text(
              'Waiting for First Rider',
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 8.h),
            const CircularProgressIndicator()
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
            /// might want to have the card be the only
            /// part that changes with bloc, idk
            Card(
              margin: EdgeInsets.symmetric(vertical: 3.h),
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'New Rider Waiting!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      leading: const Icon(Icons.face),
                      title: Text(state.latest!.riderEmail),
                      subtitle: const Text('Rider\'s RCS Id'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_location_alt_rounded),
                      title: Text(state.latest!.pickupAddress),
                      subtitle: const Text('Pickup'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.wrong_location_rounded),
                      title: Text(state.latest!.dropoffAddress),
                      subtitle: const Text('Dropoff'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<OrderBloc>(context)
                                .add(OrderAcceptedEvent(order: state.latest!));
                          },
                          child: const Text('ACCEPT'),
                        ),
                        const SizedBox(width: 8),
                        // should we even allow a driver to decline/cancel before accepting?
                        TextButton(
                            onPressed: () async => await showCancellationDialog(
                                state.latest!.orderRef),
                            child: const Text('DECLINE')),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// spacer
            Container(height: 1.h),

            const Center(
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
                        title: Text(order.riderEmail),
                        subtitle: Text(order.status),
                        trailing: const Icon(Icons.bookmark)))
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
                'Picking up ${state.order.riderEmail}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.face),
              title: Text(state.order.riderEmail),
              subtitle: const Text('Rider\'s name'),
            ),
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.phone_iphone),
              title: Text(state.order.riderPhone),
              subtitle: const Text('Tap to Call Rider'),
              onTap: () {
                launch('tel://${state.order.riderPhone}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt_rounded),
              title: Text(state.order.pickupAddress),
              subtitle: const Text('Tap to Map to Pickup'),
              onTap: () {
                MapsLauncher.launchCoordinates(state.order.pickupPoint.latitude,
                    state.order.pickupPoint.longitude);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    //TODO: maybe require a confirmation dialogue?
                    BlocProvider.of<OrderBloc>(context)
                        .add(OrderReachedPickupEvent(order: state.order));
                  },
                  child: const Text('REACHED PICKUP'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async =>
                      await showCancellationDialog(state.order.orderRef),
                  child: const Text('CANCEL'),
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
                'Dropping off ${state.order.riderEmail}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.face),
              title: Text(state.order.riderEmail),
              subtitle: const Text('Rider\'s name'),
            ),
            ListTile(
              leading: const Icon(Icons.wrong_location_rounded),
              title: Text(state.order.dropoffAddress),
              subtitle: const Text('Tap to Map to Dropoff'),
              onTap: () {
                MapsLauncher.launchQuery(state.order.dropoffAddress);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    //TODO: maybe require a confirmation dialogue?
                    BlocProvider.of<OrderBloc>(context)
                        .add(OrderReachedDropoffEvent(order: state.order));
                  },
                  child: const Text('REACHED DROPOFF'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async =>
                      await showCancellationDialog(state.order.orderRef),
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget drawer() => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        SizedBox(
          height: 20.h,
          child: DrawerHeader(
            // decoration: BoxDecoration(
            //     //color: Theme.of(context).accentColor,
            //     ),
            child: Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontSize: 24.sp),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Logout',
            style: TextStyle(fontSize: 12.sp),
          ),
          trailing: const Icon(Icons.logout),
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(const AuthenticationSignOutEvent());
          },
        )
      ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: drawer(),
        body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
          switch (state.runtimeType) {
            case OrderWaitingState:
              return waitingStateWidget(state as OrderWaitingState);
            case OrderPickingUpState:
              return pickingUpStateWidget(state as OrderPickingUpState);
            case OrderDroppingOffState:
              return droppingOffStateWidget(state as OrderDroppingOffState);
            case OrderCancelledState:
              return const Placeholder();
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
              return const Placeholder();
          }
        }));
  }
}
