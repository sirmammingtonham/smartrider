// ui imports
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:humanize/humanize.dart' as humanize;

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:shared/util/multi_bloc_builder.dart';

import 'package:shared/util/num_to_ordinal.dart';
import 'package:url_launcher/url_launcher.dart';

class SaferideStatusWidget extends StatelessWidget {
  const SaferideStatusWidget({Key? key}) : super(key: key);

  /// widget when user is still selecting pickup/dropoff
  Widget _selectionWidget(BuildContext context, SaferideSelectingState state) =>
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.16,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18.0),
                    )),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).buttonColor)),
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
                )),
          ));

  /// widget for order status waiting
  // TODO: hide search bar wtf is up
  Widget _waitingWidget(BuildContext context, SaferideWaitingState state) =>
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.22,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          'TODO: waiting countdown',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.hourglass_top),
                        title: Text('${state.queuePosition} in line'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor)),
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
                )),
          ));

  /// widget for order status picking up
  Widget _pickingUpWidget(BuildContext context, SaferidePickingUpState state) =>
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.32,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          'TODO: waiting countdown',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.face),
                        title: Text(state.driverName),
                        subtitle: const Text('Driver'),
                        trailing: const Icon(Icons.call),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor)),
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
                )),
          ));

  /// widget for order status dropping off
  Widget _droppingOffWidget(
          BuildContext context, SaferideDroppingOffState state) =>
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.16,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          'On your way!',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const Divider(
                        height: 0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor)),
                        onPressed: () {
                          BlocProvider.of<SaferideBloc>(context)
                              .add(SaferideNoEvent());
                        },
                        child: const FractionallySizedBox(
                          widthFactor: 0.6,
                          child: Text(
                            'View Schedules',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ));

  @override
  Widget build(BuildContext context) {
    return MultiBlocBuilder(
        blocs: [
          BlocProvider.of<SaferideBloc>(context),
          BlocProvider.of<MapBloc>(context)
        ],
        builder: (context, states) {
          final saferideState = states.get<SaferideState>();
          // final mapState = states.get<MapState>();
          switch (saferideState.runtimeType) {
            case SaferideSelectingState:
              return _selectionWidget(
                  context, saferideState as SaferideSelectingState);
            case SaferideWaitingState:
              return _waitingWidget(
                  context, saferideState as SaferideWaitingState);
            case SaferidePickingUpState:
              return _pickingUpWidget(
                  context, saferideState as SaferidePickingUpState);
            case SaferideDroppingOffState:
              return _droppingOffWidget(
                  context, saferideState as SaferideDroppingOffState); //TODO
            case SaferideCancelledState:
              //TODO add modal popup or something too
              return Container(); //TODO
            default:
              return Container();
          }
        });
  }
}
