// ui dependencies
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/custom_expansion_tile.dart';

List<String> choices = ['See on map', 'View on timetable'];

/// Creates an object that contains all the busses and their respective stops.
class BusTimeline extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  BusTimeline({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  BusTimelineState createState() => BusTimelineState();
}

/// Defines each bus and makes a tab for each one atop of the schedule panel.
class BusTimelineState extends State<BusTimeline> with SingleTickerProviderStateMixin {
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
    /// Controls the format (tabs on top, list of bus stops on bottom).
    return Column(children: <Widget>[
      /// The tab bar displayed when the bus icon is selected.
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

      /// The list of bus stops to be displayed.
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
    /// Returns the scrollable list for our bus stops to be contained in.
    return ScrollablePositionedList.builder(
      itemCount: busStopLists[idx].length,
      itemBuilder: (context, index) {
        /// Contains the current stops for the busses.
        var curStopList = busStopLists[idx];

        /// Contains our Expansion Tile to control how the user views each bus stop.
        return CustomExpansionTile(
          title: Text(curStopList[index % curStopList.length][0]),
          subtitle: Text('Next Arrival: ' +
              busTimeLists[idx][_getTimeIndex(busTimeLists[idx])]),
          tilePadding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),

          /// Controls the leading circle icon in front of each bus stop.
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
          trailing: isExpandedList[index % curStopList.length]
              ? Text('Hide Arrivals -')
              : Text('Show Arrivals +'),
          onExpansionChanged: (value) {
            setState(() {
              isExpandedList[index % curStopList.length] = value;
            });
          },

          /// Contains everything below the ExpansionTile when it is expanded.
          children: [
            CustomPaint(
              painter: StrokePainter(
                circleColor: Theme.of(context).buttonColor,
                lineColor: Theme.of(context).primaryColorLight,
                last: index == curStopList.length - 1,
              ),

              /// A list item for every arrival time for the selected bus stop.
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    margin: const EdgeInsets.only(left: 34.5),
                    constraints: BoxConstraints.expand(width: 8),
                  ),
                  title: Container(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          Future.delayed(const Duration(seconds: 1), () => "1"),
                      displacement: 1,

                      /// A list of the upcoming bus stop arrivals.
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemExtent: 50,
                        itemBuilder: (BuildContext context, int timeIndex) {
                          /// The container in which the bus stop arrival times are displayed.
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
                        },
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

/// Returns the stop that is closest to the current time.
_getTimeIndex(List<String> curTimeList) {
  var now = DateTime.now();
  var f = DateFormat('H.m');
  double min = double.maxFinite;
  double curTime = double.parse(f.format(now));
  double compTime;
  String closest;

  /// Formats the times to be displayed.
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

  /// Returns the time that the first bus will arrive to the current selected bus stop.
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

  /// WARNING: Default value for overflow may need to be changed based on how
  /// much space the names of the
  final double overflow;

  FillPainter(
      {this.circleColor,
      this.lineColor,
      this.first = false,
      this.last = false,
      this.overflow = 30.0})
      : super();

  /// Controls how the circle and lines are drawn.
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
