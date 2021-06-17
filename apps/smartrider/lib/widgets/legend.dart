import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/util/messages.dart';
import 'package:smartrider/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

class Legend extends StatefulWidget {
  _LegendState createState() => _LegendState();
}

class _LegendState extends State<Legend> {
  bool _isExpanded = false;

  Widget legendTile(String title, Color color, {String? subtitle}) => ListTile(
        dense: true,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        leading: Icon(
          Icons.trip_origin,
          color: color,
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
      );

  Widget busLegend(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = false;
          });
        },
        child: Container(
          height: 150,
          width: 175,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                legendTile('Route 87', BUS_COLORS['87']!),
                legendTile('Route 286', BUS_COLORS['286']!),
                legendTile('Route 289', BUS_COLORS['289']!),
                legendTile('CDTA Express', BUS_COLORS['288']!),
              ],
            ),
          ),
        ),
      );
  Widget shuttleLegend(BuildContext context) => Container();

  Widget button(BuildContext context) => Showcase(
      key: showcaseLegend,
      description: LEGEND_BUTTON_SHOWCASE_MESSAGE,
      shapeBorder: CircleBorder(),
      child: FloatingActionButton(
        child: Icon(
          Icons.help_outline,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black87
              : Theme.of(context).accentColor,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.white70,
        onPressed: () {
          setState(() {
            _isExpanded = true;
          });
        },
        heroTag: "legendViewButton",
      ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(builder: (context, state) {
      return Positioned(
        left: 20.0,
        bottom: 120.0,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(
            child: child,
            scale: animation,
            alignment: Alignment.bottomLeft,
          ),
          child: _isExpanded
              ? (state.isBus ? busLegend(context) : shuttleLegend(context))
              : button(context),
        ),
      );
    });
  }
}
