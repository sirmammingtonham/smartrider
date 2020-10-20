// ui dependencies
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dash/flutter_dash.dart';
//import 'package:flutter/rendering.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/custom_expansion_tile.dart';
import 'package:smartrider/pages/shuttle_dropdown.dart';
import 'package:smartrider/widgets/filter_dialog.dart';
import 'package:smartrider/widgets/shuttle_list.dart';
import 'package:smartrider/widgets/bus_list.dart';
import 'package:smartrider/widgets/map_ui.dart';

class BusList extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  BusList({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  BusListState createState() => BusListState();
}

class BusListState extends State<BusList> with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    Tab(text: 'Route 87'),
    Tab(text: 'Route 286'),
    Tab(text: 'Route 289'),
  ];

  TabController _tabController;
  var isExpandedList = new List<bool>.filled(100, false);
  @override
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

  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    return Column(children: <Widget>[
      TabBar(
        isScrollable: true,
        tabs: busTabs,
        // unselectedLabelColor: Colors.white.withOpacity(0.3),
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

  @override
  Widget busList(int idx, Function _containsFilter, Function _jumpMap) {
    return ScrollablePositionedList.builder(
      itemCount: busStopLists[idx].length,
      itemBuilder: (context, index) {
        var curStopList = busStopLists[idx];

        //print(curStopList);
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
                  : Text('Show Arrivals +')
          //isExpanded ? Text('Hide Arrivals -') : Text('Show Arrivals +')
          ,
          onExpansionChanged: (value) {
            setState(() {
              isExpandedList[index % curStopList.length] = value;
              //print(isExpandedList);
              //isExpanded = isExpanded_temp;
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
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   margin: const EdgeInsets.only(left: 18),
                          //   child: Text(
                          //     'Current Time: ${DateFormat('H.m').format(DateTime.now())}',
                          //     style: TextStyle(fontSize: 12),
                          //   ),
                          // ),
                          // SizedBox(height: 10),
                          Container(
                              margin: const EdgeInsets.only(left: 18),
                              child: SizedBox(
                                width: 140,
                                height: 60,
                                child: RaisedButton(
                                    onPressed: () {
                                      _jumpMap(
                                          double.parse(curStopList[
                                              index % curStopList.length][1]),
                                          double.parse(curStopList[
                                              index % curStopList.length][2]));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on),
                                        Text('Show This Stop',
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    )),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 65),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 15,
                                  ),
                                  Text(' ${busTimeLists[idx][index]}'),
                                ]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

_getTimeIndex(List<String> curTimeList) {
  // TODO: update so it works with filter
  // List curTimeList = _isShuttle ? shuttleTimeLists[_tabController.index] :
  //             busTimeLists[_tabController.index-1];
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
    // cascade notation, look it up it's pretty cool

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
