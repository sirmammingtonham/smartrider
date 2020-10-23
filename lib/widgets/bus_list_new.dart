// ui dependencies
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
//import 'package:flutter/rendering.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/custom_expansion_tile.dart';
import 'package:smartrider/pages/shuttle_dropdown.dart';
import 'package:smartrider/widgets/filter_dialog.dart';
import 'package:smartrider/widgets/shuttle_list.dart';
import 'package:smartrider/widgets/bus_list.dart';
import 'package:smartrider/widgets/map_ui.dart';
import 'package:smartrider/widgets/shuttle_list_copy.dart';

List<String> choices = ['See on map', 'View on timetable'];

/// Creates an object that contains all the busses and their respective stops.
class BusList extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  BusList({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  BusListState createState() => BusListState();
}

/// Defines each bus and makes a tab for each one atop of the schedule panel.
class BusListState extends State<BusList> with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    Tab(text: 'Route 87'),
    Tab(text: 'Route 286'),
    Tab(text: 'Route 289'),
  ];

  TabController _tabController;
  var isExpandedList = new List<bool>.filled(100, false);
  @override

  /// Affects the expansion of each bus's list of stops
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: busTabs.length);
    _tabController.addListener(() {
      isExpandedList.fillRange(0, 100, false);
    });
    isExpandedList.fillRange(0, 100, false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Builds each tab for each bus and also accounts for the users
  /// light preferences.
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TabBar(
        isScrollable: true,
        tabs: busTabs,
        labelColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : null,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : null,
        controller: _tabController,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            busList(0, this.widget.containsFilter, this.widget.jumpMap),
            busList(1, this.widget.containsFilter, this.widget.jumpMap),
            busList(2, this.widget.containsFilter, this.widget.jumpMap),
          ],
        ),
      )
    ]);
  }

  /// Builds the buslist widget which contains all the stops and
  /// useful user information like the next arrival.
  @override
  Widget busList(int idx, Function _containsFilter, Function _jumpMap) {
    return ScrollablePositionedList.builder(
      itemCount: busStopLists[idx].length,
      itemBuilder: (context, index) {
        var curStopList = busStopLists[idx];
        return CustomExpansionTile(
          title: Text(curStopList[index % curStopList.length][0]),
          subtitle: Text('Next Arrival: ' +
              busTimeLists[idx][_getTimeIndex(busTimeLists[idx])]),
          leading: CustomPaint(
              painter: FillPainter(
                  circleColor: Theme.of(context).buttonColor,
                  lineColor: Theme.of(context).primaryColorLight,
                  first: index == 0,
                  last: index == curStopList.length - 1),
              child: Container(
                height: 50,
                width: 45,
              )),
          trailing:
              //toggle()
              isExpandedList[index % curStopList.length]
                  ? Text('Hide Arrivals -')
                  : Text('Show Arrivals +'),
          onExpansionChanged: (value) {
            setState(() {
              isExpandedList[index % curStopList.length] = value;
            });
          },
          children: [
            CustomPaint(
              painter: StrokePainter(
                circleColor: Theme.of(context).buttonColor,
                lineColor: Theme.of(context).primaryColorLight,
                last: index == curStopList.length - 1,
              ),
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    margin: const EdgeInsets.only(left: 34.5),
                    constraints: BoxConstraints.expand(width: 8),
                  ),
                  title: Container(
                    // height: 100.0,
                    // margin: const EdgeInsets.only(left: 0),
                    child: RefreshIndicator(
                      onRefresh: () =>
                          Future.delayed(const Duration(seconds: 1), () => "1"),
                      displacement: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemExtent: 50,
                        itemBuilder: (BuildContext context, int timeIndex) {
                          return ListTile(
                            dense: true,
                            leading: Icon(Icons.access_time, size: 20),
                            title: Text(
                              '${busTimeLists[idx][timeIndex]}',
                              style: TextStyle(fontSize: 15),
                            ),
                            subtitle: Text('In 11 minutes'),
                            trailing: PopupMenuButton<String>(
                                onSelected: null,
                                itemBuilder: (BuildContext context) => choices
                                    .map((choice) => PopupMenuItem<String>(
                                        value: choice, child: Text(choice)))
                                    .toList()),
                          );
                          // onTap: () {
                          //   _jumpMap(
                          //       double.parse(
                          //           shuttleStopLists[idx][index][1]),
                          //       double.parse(
                          //           shuttleStopLists[idx][index][2]));
                          // });
                        },
                        // separatorBuilder: (BuildContext context, int index) =>
                        //     const SizedBox(height: 1),
                      ),
                    ),
                  )),
            ),
          ],
        );
      },
    );
  }
}

// _calculateTimeAway(String time) {
//   var now = DateTime.now();
//   var f = DateFormat('H.m');
//   double curTime = double.parse(f.format(now));
//   var t = time.replaceAll(':', '.');
//   var compTime =
//       double.tryParse(t.substring(0, t.length - 2)); // comparison time
//   return (curTime - compTime).round();
// }

/// Returns the stop that is closest to the current time.
_getTimeIndex(List<String> curTimeList) {
  var now = DateTime.now();
  var f = DateFormat('H.m');
  double min = double.maxFinite;
  double curTime = double.parse(f.format(now));
  double compTime;
  String closest;
  curTimeList.forEach((time) {
    var t = time.replaceAll(':', '.');
    compTime = double.tryParse(t.substring(0, t.length - 2));
    if (compTime == null) return;
    if (t.endsWith('pm') && !t.startsWith("12")) {
      compTime += 12.0;
    }
    if ((curTime - compTime).abs() < min) {
      min = (curTime - compTime).abs();
      closest = time;
    }
  });

  return curTimeList.indexWhere((element) => element == closest);
}

/// Creates our "lines and circles" on the left hand side of the
/// schedule list for each bus. This particular class is responsible
/// for the first stop.
class FillPainter extends CustomPainter {
  final Color circleColor;
  final Color lineColor;
  final bool first;
  final bool last;
  final double overflow;

  FillPainter(
      {this.circleColor,
      this.lineColor,
      this.first = false,
      this.last = false,
      this.overflow = 20.0})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // cascade notation, look it up it's pretty cool
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 6;

    if (first) {
      canvas.drawLine(Offset(size.width / 2, size.height + overflow),
          Offset(size.width / 2, size.height / 2 + 15), line);
    } else if (last) {
      canvas.drawLine(Offset(size.width / 2, size.height / 2 - 15.0),
          Offset(size.width / 2, -overflow), line);
    } else {
      canvas.drawLine(Offset(size.width / 2, (size.height / 2) - 15.0),
          Offset(size.width / 2, -overflow), line);
      canvas.drawLine(Offset(size.width / 2, (size.height / 2) + 15.0),
          Offset(size.width / 2, size.height + overflow), line);
    }

    // set the color property of the paint
    paint.color = circleColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;

    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 11.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Creates our "lines and circles" on the left hand side of the
/// schedule list for each bus. This particular class is responsible
/// for all stops but the first.
class StrokePainter extends CustomPainter {
  final Color circleColor;
  final Color lineColor;
  final bool last;
  StrokePainter({
    this.circleColor,
    this.lineColor,
    this.last = false,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 6;

    if (!last) {
      canvas.drawLine(Offset(38.5, size.height), Offset(38.5, 0), line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
