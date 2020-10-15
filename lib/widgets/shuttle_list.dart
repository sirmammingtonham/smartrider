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

class ShuttleList extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  ShuttleList({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  ShuttleListState createState() => ShuttleListState();
}

class ShuttleListState extends State<ShuttleList>
    with SingleTickerProviderStateMixin {
  final List<Widget> shuttleTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
    Tab(text: 'WEEKEND'),
  ];

  TabController _tabController;
  var isExpandedList = new List<bool>.filled(100, false);
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: shuttleTabs.length);
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
        tabs: shuttleTabs,
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
            shuttleList(0, this.widget.containsFilter, this.widget.jumpMap),
            shuttleList(1, this.widget.containsFilter, this.widget.jumpMap),
            shuttleList(2, this.widget.containsFilter, this.widget.jumpMap),
            shuttleList(3, this.widget.containsFilter, this.widget.jumpMap),
          ],
        ),
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;

  /*void toggle() {
    if (isExpanded) {
      isExpanded = false;
      //return Text('Show Arrivals +');
    } else {
      isExpanded = true;
      //return Text('Hide Arrivals -');
    }
  }*/
  Widget shuttleList(int idx, Function _containsFilter, Function _jumpMap) {
    return ScrollablePositionedList.builder(
      itemCount: shuttleStopLists[idx].length,
      itemBuilder: (context, index) {
        var curStopList = shuttleStopLists[idx];

        //print(curStopList);
        return CustomExpansionTile(
          title: Text(curStopList[index % curStopList.length][0]),
          subtitle: Text('Next Arrival: ' +
              _getTimeIndex(shuttleTimeLists[idx]).toString()),
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                margin: const EdgeInsets.only(left: 34.5),
                constraints: BoxConstraints.expand(width: 8),
                child: CustomPaint(
                    painter: StrokePainter(
                      circleColor: Theme.of(context).buttonColor,
                      lineColor: Theme.of(context).primaryColorLight,
                      last: index== curStopList.length -1,
                    ),
                    child: Container(
                      height: 50,
                      width: 45,
                    )),
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
      this.overflow = 8.0})
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
          Offset(size.width / 2, size.height / 2), line);
    } else if (last) {
      canvas.drawLine(Offset(size.width / 2, size.height / 2),
          Offset(size.width / 2, -overflow), line);
    } else {
      canvas.drawLine(Offset(size.width / 2, size.height + overflow),
          Offset(size.width / 2, -overflow), line);
    }

    // set the color property of the paint
    paint.color = circleColor;

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
  final double
      circleOffset; // how much to offset lines by based on thiccness of circle stroke
  final double stroke;
  StrokePainter(
      {this.circleColor,
      this.lineColor,
      this.last = false,
      this.circleOffset = 15.0,
      this.stroke = 3.0})
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

    
    if (last) {
      canvas.drawLine(Offset(size.width / 2, (size.height / 2) - circleOffset),
        Offset(size.width / 2, 0), line);
    } else {  // two lines to leave middle empty
      canvas.drawLine(Offset(size.width / 2, (size.height / 2) - circleOffset),
        Offset(size.width / 2, 0), line);
    canvas.drawLine(Offset(size.width / 2, (size.height / 2) + circleOffset),
        Offset(size.width / 2, size.height), line);
    }

    paint.color = circleColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = stroke;

    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 11.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
