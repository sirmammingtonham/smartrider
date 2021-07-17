// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_timetable.dart';
import 'package:shared/util/messages.dart';
import 'package:smartrider/widgets/bus_schedules/bus_unavailable.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/widgets/custom_widgets/custom_painters.dart';
import 'package:sizer/sizer.dart';

// loading custom widgets and data
import 'package:smartrider/widgets/custom_widgets/custom_expansion_tile.dart';

const List<String> choices = [
  'Set reminder',
  'See on map',
  'View on timetable'
];

/// Creates an object that contains all the busses and their respective stops.
class BusTimeline extends StatefulWidget {
  final PanelController panelController;
  final ScrollController scrollController;
  // final Map<String, BusRoute> busRoutes;
  final Map<String?, BusTimetable>? busTables;

  BusTimeline(
      {Key? key,
      required this.panelController,
      required this.scrollController,
      // @required this.busRoutes,
      required this.busTables})
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

  late final TabController _tabController;
  ScrollController? _scrollController;

  // TODO: better way to do this
  final isExpandedList = List<bool>.filled(50, false);

  /// Affects the expansion of each bus's list of stops
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: busTabs.length);
    _tabController.addListener(() {
      setState(() {
        isExpandedList.fillRange(0, 50, false);
      });
    });

    // we need to disable to scroll controller when the user is switching tabs
    // so we dont get the annoying asf "multiple scroll view" error
    _scrollController = widget.scrollController;
    _tabController.animation?.addListener(() {
      if (_tabController.animation!.value % 1 == 0.0) {
        setState(() {
          _scrollController = widget.scrollController;
        });
      } else if (_scrollController != null) {
        setState(() {
          _scrollController = null;
        });
      }
    });
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
      Showcase(
        key: showcaseBusTab,
        description: BUS_TAB_SHOWCASE_MESSAGE,
        child: TabBar(
          indicatorColor: BUS_COLORS.values.toList()[_tabController.index],
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
      ),

      /// The list of bus stops to be displayed.
      Container(
        height: 63.h,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            busList('87'),
            busList('286'),
            busList('289'),
            busList('288'),
          ],
        ),
      )
    ]);
  }

  Widget busExpansionTile(index, busStops, stopTimes, routeId) {
    return CustomExpansionTile(
      title: Text(busStops[index].stopName),
      subtitle: Text('Next Arrival: ${stopTimes[0][0]}'),
      tilePadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

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
              child: RefreshIndicator(
                onRefresh: () =>
                    Future.delayed(const Duration(seconds: 1), () => "1"),
                displacement: 1,

                /// A list of the upcoming bus stop arrivals.
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: stopTimes.length,
                  itemExtent: 50,
                  itemBuilder: (BuildContext context, int timeIndex) {
                    if (stopTimes[timeIndex][0] == '-') {
                      return Container(); // return empty container if stop not available
                    }

                    String subText;
                    if (stopTimes[timeIndex][1] / 3600 > 1) {
                      var time = (stopTimes[timeIndex][1] / 3600).truncate();
                      subText = "In $time ${time > 1 ? 'hours' : 'hour'}";
                    } else {
                      var time = (stopTimes[timeIndex][1] / 60).truncate();
                      subText = "In $time ${time > 1 ? 'minutes' : 'minute'}";
                    }

                    /// The container in which the bus stop arrival times are displayed.
                    return ListTile(
                      dense: true,
                      leading: Icon(Icons.access_time,
                          size:
                              20), // TODO: change icon if bus is within 5 minutes
                      title: Text(
                        stopTimes[timeIndex][0],
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Text(subText),
                      trailing: PopupMenuButton<String>(
                          onSelected: (choice) => _handlePopupSelection(
                              choice, busStops[index], stopTimes[timeIndex]),
                          itemBuilder: (BuildContext context) => choices
                              .map((choice) => PopupMenuItem<String>(
                                  value: choice, child: Text(choice)))
                              .toList()),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the buslist widget which contains all the stops and
  /// useful user information like the next arrival.
  Widget busList(String routeId) {
    // check if schedule is unavailable
    if (!widget.busTables!.containsKey(routeId)) {
      return BusUnavailable();
    }
    var busStops = widget.busTables![routeId]!.stops!;

    /// Returns the scrollable list for our bus stops to be contained in.
    // return ScrollablePositionedList.builder(
    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      itemCount: busStops.length,
      itemBuilder: (context, index) {
        var stopTimes = this
            .widget
            .busTables![routeId]!
            .getClosestTimes(index)
            .where((stopPair) => stopPair[1] != -1)
            .toList();
        return index == 0
            ? busExpansionTile(index, busStops, stopTimes, routeId)
            : busExpansionTile(index, busStops, stopTimes, routeId);

        /// showcase doesn't work because of duplicate global keys
        /// (it tries to use the same global key despite there being multiple tabs)
        // TODO: fix dis
        // Showcase(
        //   key: GlobalKey(debugLabel: 'bruh2'),//showcaseTimeline,
        //   description: TIMELINE_ITEM_SHOWCASE_MESSAGE,
        //   child: busExpansionTile(index, busStops, stopTimes, routeId))
      },
    );
  }

  void _handlePopupSelection(
      String choice, TimetableStop? busStop, List<dynamic>? stopTime) {
    if (choice == choices[0]) {
      BlocProvider.of<ScheduleBloc>(context)
          .scheduleBusAlarm(stopTime![1], busStop!);
    } else if (choice == choices[1]) {
      this.widget.panelController.animatePanelToPosition(0);
      BlocProvider.of<MapBloc>(context).scrollToLatLng(busStop!.latLng);
    }
  }
}
