// ui imports
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared/util/num_to_ordinal.dart';
import 'package:url_launcher/url_launcher.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';

import 'package:sizer/sizer.dart';

final saferideDefaultHeight = 15.h;
final saferideSelectingHeight = 16.h;
final saferideWaitingHeight = 22.h;
final saferidePickingUpHeight = 30.h;
final saferideCancelledHeight = 30.h;
final saferideErrorHeight = 16.h;

/// widget when user is still selecting pickup/dropoff
Widget saferideSelectionWidget(
        BuildContext context, SaferideSelectingState state) =>
    Container(
        height: saferideSelectingHeight,
        // decoration: BoxDecoration(
        //   color: Theme.of(context).primaryColor,
        // ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 5),
              Center(
                child: Text(
                  '${state.queuePosition + 1}'
                  '${(state.queuePosition + 1).toOrdinal()} in line',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Builder(builder: (context) {
                // TODO: is this accurate?
                if (state.queuePosition > 7) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        'Note: Wait > 20 mins',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white60),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<SaferideBloc>(context)
                      .add(const SaferideConfirmedEvent());
                },
                child: const FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Text(
                    'CONFIRM PICKUP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ));

/// widget for order status waiting
Widget saferideWaitingWidget(
        BuildContext context, SaferideWaitingState state) =>
    Container(
        height: saferideWaitingHeight,
        // decoration: BoxDecoration(
        //   color: Theme.of(context).primaryColor,
        // ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 5),
               Center(
                child: Text(
                  'Estimate wait time: ${state.estimatedPickup ?? -1} minutes',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.hourglass_top,
                  color: Colors.white,
                ),
                title: Text('${state.queuePosition} in line',
                    style: const TextStyle(
                      color: Colors.white,
                    )),
              ),
              ElevatedButton(
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //         Theme.of(context).buttonColor)),
                onPressed: () {
                  BlocProvider.of<SaferideBloc>(context)
                      .add(const SaferideUserCancelledEvent());
                },
                child: const FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Text(
                    'CANCEL',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ));

/// widget for order status picking up
Widget saferidePickingUpWidget(
        BuildContext context, SaferidePickingUpState state) =>
    Container(
      height: saferidePickingUpHeight,
      // decoration: BoxDecoration(
      //   color: Theme.of(context).primaryColor,
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            Center(
              child: Text(
                'Estimate wait time: ${state.estimatedPickup ?? -1} minutes',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.face,
                color: Colors.white,
              ),
              title: Text(
                state.driverName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: const Text('Driver',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              trailing: const Icon(
                Icons.call,
                color: Colors.white,
              ),
              onTap: () {
                launch('tel://${state.phoneNumber}');
              },
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              leading: const Icon(Icons.drive_eta),
              title: const Text('TODO: replace with brand of car?'),
              trailing: Text(state.licensePlate),
            ),
            ElevatedButton(
              // style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(
              //         Theme.of(context).accentColor)),
              onPressed: () {
                BlocProvider.of<SaferideBloc>(context)
                    .add(const SaferideUserCancelledEvent());
              },
              child: const FractionallySizedBox(
                widthFactor: 0.6,
                child: Text(
                  'CANCEL',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
