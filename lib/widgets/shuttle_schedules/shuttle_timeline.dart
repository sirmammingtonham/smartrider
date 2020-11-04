// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

//import 'package:flutter/rendering.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/custom_expansion_tile.dart';

List<String> choices = ['See on map', 'View on timetable', 'Set Reminder'];

final FlutterLocalNotificationsPlugin fltrNotification =
FlutterLocalNotificationsPlugin();

/// Creates an object that contains all the shuttles and their respective stops.
class ShuttleTimeline extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  ShuttleTimeline({Key key, this.containsFilter, this.jumpMap})
      : super(key: key);
  @override
  ShuttleTimelineState createState() => ShuttleTimelineState();
}

/// Defines each shuttle and makes a tab for each one atop of the schedule panel.
class ShuttleTimelineState extends State<ShuttleTimeline>
    with SingleTickerProviderStateMixin {
  final List<Widget> shuttleTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
    Tab(text: 'WEEKEND'),
  ];

  TabController _tabController;
  var isExpandedList = List<bool>.filled(100, false);
  @override

  /// Affects the expansion of each shuttles list of stops
  void initState() {
    super.initState();
    var androidInitilize = AndroidInitializationSettings('app_icon');
    var iOSinitilize = IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    _tabController = TabController(vsync: this, length: shuttleTabs.length);
    _tabController.addListener(() {
      isExpandedList.fillRange(0, 100, false);
    });
    isExpandedList.fillRange(0, 100, false);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  /// Builds each tab for each shuttle and also accounts for the users
  /// light preferences.
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TabBar(
        isScrollable: true,
        tabs: shuttleTabs,
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

  /// Builds the shuttlelist widget which contains all the stops and
  /// useful user information like the next arrival.
  Widget shuttleList(int idx, Function _containsFilter, Function _jumpMap) {
    return ScrollablePositionedList.builder(
      itemCount: shuttleStopLists[idx].length,
      itemBuilder: (context, index) {
        var curStopList = shuttleStopLists[idx];
        return CustomExpansionTile(
          title: Text(curStopList[index % curStopList.length][0]),
          subtitle: Text('Next Arrival: ' +
              shuttleTimeLists[idx][_getTimeIndex(shuttleTimeLists[idx])]),
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
                              '${shuttleTimeLists[idx][timeIndex]}',
                              style: TextStyle(fontSize: 15),
                            ),
                            subtitle: Text('In 11 minutes'),
                            trailing: PopupMenuButton<String>(
                                onSelected: (String selected) {
                                  if (selected == choices[0]) {
                                    _jumpMap(
                                        double.parse(
                                            shuttleStopLists[idx][index][1]),
                                        double.parse(
                                            shuttleStopLists[idx][index][2]));
                                  }
                                  if (selected == choices[2]) {
                                    scheduleAlarm();
                                  }
                                },
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

  Future<void> scheduleAlarm() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'app_icon',
      ///sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        ///sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await fltrNotification.schedule(
        0,
        'Test',
        'bruh',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
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
/// schedule list for each shuttle. This particular class is responsible
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
/// schedule list for each shuttle. This particular class is responsible
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
