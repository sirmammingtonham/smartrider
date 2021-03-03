// ui imports
import 'dart:ui';

import 'package:flutter/material.dart';

// bloc imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/util/multi_bloc_builder.dart';

class SaferideStatusWidget extends StatelessWidget {
  const SaferideStatusWidget();

  @override
  Widget build(BuildContext context) {
    return MultiBlocBuilder(
        blocs: [
          BlocProvider.of<SaferideBloc>(context),
          BlocProvider.of<MapBloc>(context)
        ],
        builder: (context, states) {
          // final saferideState = states.get<SaferideState>();
          // final mapState = states.get<MapState>();
          // TODO: get this to animate, with a slide up from previous state
          return Align(
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
                              'Estimated Wait: 10 mins',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Text(
                              '2nd in Queue',
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
                            onPressed: () {},
                          )
                        ],
                      ),
                    )),
              ));
        });
  }
}
