// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/data/models/bus/bus_route.dart';
import 'package:smartrider/data/models/bus/bus_shape.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';

// loading custom widgets and data
import 'package:smartrider/widgets/custom_expansion_tile.dart';

const List<String> choices = [
  'Set Reminder',
  'See on map',
  'View on timetable'
];

/// Creates an object that contains all the busses and their respective stops.
class BusTimeline extends StatefulWidget {
  final PanelController panelController;
  // final Map<String, BusRoute> busRoutes;
  final Map<String, BusTimetable> busTables;
  var BUSCOLORS = [
       Colors.purple,
        Colors.deepOrange,
        Colors.cyan,
        Colors.pinkAccent,
    ];
  BusTimeline(
      {Key key,
      @required this.panelController,
      // @required this.busRoutes,
      @required this.busTables})
      : super(key: key);
  @override
  BusTimelineState createState() => BusTimelineState();
}

/// Defines each bus and makes a tab for each one atop of the schedule panel.
class BusTimelineState extends State<BusTimeline>
    with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    Tab(text: 'Route 87'),
    Tab(text: 'Route 286'),
    Tab(text: 'Route 289'),
    Tab(text: 'Express Shuttle'),
  ];

  TabController _tabController;

  // TODO: better way to do this
  var isExpandedList = List<bool>.filled(50, false);

  /// Affects the expansion of each bus's list of stops
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: busTabs.length);
    _tabController.addListener(() {
      isExpandedList.fillRange(0, 50, false);
      setState(() {});
    });
    isExpandedList.fillRange(0, 50, false);
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
        indicatorColor: this.widget.BUSCOLORS[_tabController.index],
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
            busList('87-185'),
            busList('286-185'),
            busList('289-185'),
            busList('288-185'),
          ],
        ),
      )
    ]);
  }

  /// Builds the buslist widget which contains all the stops and
  /// useful user information like the next arrival.
  Widget busList(String routeId) {
    var busStops = widget.busTables[routeId]
        .stops; //this.widget.busRoutes[routeId].forwardStops;
    /// Returns the scrollable list for our bus stops to be contained in.
    return RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1), () => "1"),
        displacement: 1,

        /// A list of the upcoming bus stop arrivals.
        child: ScrollablePositionedList.builder(
          itemCount: busStops.length,
          itemBuilder: (context, index) {
            var stopTimes = this
                .widget
                .busTables[routeId]
                .getClosestTimes(index)
                .where((stopPair) => stopPair[1] != -1)
                .toList();

            /// Contains our Expansion Tile to control how the user views each bus stop.
            return CustomExpansionTile(
              title: Text(busStops[index].stopName),
              subtitle: Text('Next Arrival: ${stopTimes[0][0]}'),
              tilePadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

              /// Controls the leading circle icon in front of each bus stop.
              leading: CustomPaint(
                  painter: FillPainter(
                      circleColor: BUS_COLORS[routeId],
                      lineColor: Theme.of(context).primaryColorLight,
                      first: index == 0,
                      last: index == busStops.length - 1),
                  child: Container(
                    height: 50,
                    width: 45,
                  )),
              trailing: isExpandedList[index]
                  ? Text('Hide Arrivals -')
                  : Text('Show Arrivals +'),
              onExpansionChanged: (value) {
                setState(() {
                  isExpandedList[index] = value;
                });
              },

              /// Contains everything below the ExpansionTile when it is expanded.
              children: [
                CustomPaint(
                    painter: StrokePainter(
                      circleColor: Theme.of(context).buttonColor,
                      lineColor: Theme.of(context).primaryColorLight,
                      last: index == busStops.length - 1,
                    ),

                    /// A list item for every arrival time for the selected bus stop.
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        margin: const EdgeInsets.only(left: 34.5),
                        constraints: BoxConstraints.expand(width: 8),
                      ),
                      title: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: stopTimes.length,
                          itemExtent: 50,
                          itemBuilder: (BuildContext context, int timeIndex) {
                            String subText;
                            if (stopTimes[timeIndex][1] / 3600 > 1) {
                              var time =
                                  (stopTimes[timeIndex][1] / 3600).truncate();
                              subText =
                                  "In $time ${time > 1 ? 'hours' : 'hour'}";
                            } else {
                              var time =
                                  (stopTimes[timeIndex][1] / 60).truncate();
                              subText =
                                  "In $time ${time > 1 ? 'minutes' : 'minute'}";
                            }

                            /// The container in which the bus stop arrival times are displayed.
                            return ListTile(
                              dense: true,
                              leading: Icon(Icons.access_time, size: 20),
                              title: Text(
                                stopTimes[timeIndex][0],
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(subText),
                              trailing: PopupMenuButton<String>(
                                  onSelected: (choice) => _handlePopupSelection(
                                      choice,
                                      busStops[index],
                                      stopTimes[timeIndex]),
                                  itemBuilder: (BuildContext context) => choices
                                      .map((choice) => PopupMenuItem<String>(
                                          value: choice, child: Text(choice)))
                                      .toList()),
                            );
                          },
                        ),
                      ),
                    )),
              ],
            );
          },
        ));
  }

  void _handlePopupSelection(
      String choice, TimetableStop busStop, List<dynamic> stopTime) {
    if (choice == choices[0]) {
      BlocProvider.of<ScheduleBloc>(context)
          .scheduleBusAlarm(stopTime[1], busStop);
    } else if (choice == choices[1]) {
      this.widget.panelController.animatePanelToPosition(0);
      BlocProvider.of<MapBloc>(context).scrollToLocation(busStop.latLng);
    }
  }
}

///TODO: Move these custom painters to another file

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
