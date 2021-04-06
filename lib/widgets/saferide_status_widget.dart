// ui imports
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:humanize/humanize.dart' as humanize;

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/util/multi_bloc_builder.dart';

class SaferideStatusWidget extends StatelessWidget {
  const SaferideStatusWidget();

  Widget _selectionWidget(BuildContext context, SaferideSelectionState state) => Align(
      alignment: FractionalOffset.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.2,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18.0),
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'Estimated Wait: ${state.waitEstimate}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      '${humanize.ordinal(state.queuePos)} in Queue',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white60),
                    ),
                  ),
                  SizedBox(height: 14),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).buttonColor)),
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Text(
                        'CONFIRM PICKUP',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<SaferideBloc>(context)
                          .add(SaferideConfirmedEvent());
                    },
                  )
                ],
              ),
            )),
      ));

  Widget _confirmedWidget(BuildContext context, SaferideAcceptedState state) =>
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.32,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18.0),
                    )),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          state.waitEstimate < 1
                              ? 'Now!'
                              : '${state.waitEstimate} min${state.waitEstimate != 1 ? 's' : ''} away',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.face),
                        title: Text(state.driverName),
                        subtitle: Text('Driver'),
                        trailing: Icon(Icons.call),
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        leading: Icon(Icons.drive_eta),
                        title: Text('Queue position: #${state.queuePosition}'),
                        trailing: Text(state.licensePlate),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor)),
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: Text(
                            'CANCEL',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<SaferideBloc>(context)
                              .add(SaferideCancelEvent());
                        },
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
          // TODO: get this to animate, with a slide up from previous state
          if (saferideState is SaferideSelectionState) {
            return _selectionWidget(context, saferideState);
          } else if (saferideState is SaferideAcceptedState) {
            return _confirmedWidget(context, saferideState);
          }
          return Container();
        });
  }
}
