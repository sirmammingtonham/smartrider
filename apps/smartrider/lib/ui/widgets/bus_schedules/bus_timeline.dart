// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_timetable.dart';
import 'package:shared/util/messages.dart';
import 'package:smartrider/ui/widgets/bus_schedules/bus_unavailable.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/ui/home.dart';
import 'package:smartrider/ui/widgets/custom_widgets/custom_painters.dart';
import 'package:shared/models/tuple.dart';

// loading custom widgets and data
import 'package:smartrider/ui/widgets/custom_widgets/custom_expansion_tile.dart';

const List<String> choices = [
  'Set reminder',
  'See on map',
  'View on timetable'
];

/// Creates an object that contains all the busses and their respective stops.
class BusTimeline extends StatefulWidget {
  const BusTimeline(
      {Key? key,
      required this.panelController,
      required this.scrollController,
      // @required this.busRoutes,
      required this.busTables})
      : super(key: key);
  final PanelController panelController;
  final ScrollController scrollController;
  // final Map<String, BusRoute> busRoutes;
  final Map<String?, BusTimetable>? busTables;

  @override
  BusTimelineState createState() => BusTimelineState();
}

/// Defines each bus and makes a tab for each one atop of the schedule panel.
class BusTimelineState extends State<BusTimeline>
    with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    const Tab(text: 'Route 87'),
    const Tab(text: 'Route 286'),
    const Tab(text: 'Route 289'),
    const Tab(text: 'Express Shuttle'),
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
    // so we dont get the annoying asf 'multiple scroll view' error
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

  /// Builds each tab for each bus and also accounts for the users light
  /// preferences.
  @override
  Widget build(BuildContext context) {
    /// Controls the format (tabs on top, list of bus stops on bottom).
    return Column(children: <Widget>[
      /// The tab bar displayed when the bus icon is selected.
      Showcase(
        key: showcaseBusTab,
        description: busTabShowcaseMessage,
        child: TabBar(
          indicatorColor: busColors.values.toList()[_tabController.index],
          isScrollable: true,
          tabs: busTabs,
          labelColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : null,
          unselectedLabelColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black45
              : null,
          controller: _tabController,
        ),
      ),

      /// The list of bus stops to be displayed.
      Expanded(
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

  Widget busExpansionTile(int index, List<TimetableStop> busStops,
      List<Tuple<String, int>> stopTimes, String routeId) {
    return CustomExpansionTile(
      title: Text(busStops[index].stopName),
      subtitle: Text('Next Arrival: ${stopTimes[0].first}'),
      tilePadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

      /// Controls the leading circle icon in front of each bus stop.
      leading: CustomPaint(
          painter: FillPainter(
              circleColor: busColors[routeId],
              lineColor: Theme.of(context).primaryColor,
              first: index == 0,
              last: index == busStops.length - 1),
          child: const SizedBox(
            height: 50,
            width: 45,
          )),
      trailing: isExpandedList[index]
          ? const Text('Hide Arrivals -')
          : const Text('Show Arrivals +'),
      onExpansionChanged: (value) {
        setState(() {
          isExpandedList[index] = value;
        });
      },

      /// Contains everything below the ExpansionTile when it is expanded.
      children: [
        CustomPaint(
          painter: StrokePainter(
            circleColor: Theme.of(context).primaryColor,
            lineColor: Theme.of(context).primaryColor,
            last: index == busStops.length - 1,
          ),

          /// A list item for every arrival time for the selected bus stop.
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              margin: const EdgeInsets.only(left: 34.5),
              constraints: const BoxConstraints.expand(width: 8),
            ),
            title: RefreshIndicator(
              onRefresh: () =>
                  Future.delayed(const Duration(seconds: 1), () => '1'),
              displacement: 1,

              /// A list of the upcoming bus stop arrivals.
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: stopTimes.length,
                itemExtent: 50,
                itemBuilder: (BuildContext context, int timeIndex) {
                  if (stopTimes[timeIndex].first == '-') {
                    // return empty container if stop not available
                    return Container();
                  }

                  String subText;
                  if (stopTimes[timeIndex].second / 3600 > 1) {
                    final num time =
                        (stopTimes[timeIndex].second / 3600).truncate();
                    subText = 'In $time ${time > 1 ? 'hours' : 'hour'}';
                  } else {
                    final num time =
                        (stopTimes[timeIndex].second / 60).truncate();
                    subText = 'In $time ${time > 1 ? 'minutes' : 'minute'}';
                  }

                  /// The container in which the bus stop arrival times are
                  /// displayed.
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.access_time,
                        size:
                            20), // TODO: change icon if bus is within 5 minutes
                    title: Text(
                      stopTimes[timeIndex].first,
                      style: const TextStyle(fontSize: 15),
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
      ],
    );
  }

  /// Builds the buslist widget which contains all the stops and useful user
  /// information like the next arrival.
  Widget busList(String routeId) {
    // check if schedule is unavailable
    if (!widget.busTables!.containsKey(routeId)) {
      return const BusUnavailable();
    }
    final busStops = widget.busTables![routeId]!.stops!;

    /// Returns the scrollable list for our bus stops to be contained in.
    // return ScrollablePositionedList.builder(
    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      itemCount: busStops.length,
      itemBuilder: (context, index) {
        final stopTimes = widget.busTables![routeId]!
            .getClosestTimes(index)
            .where((stopPair) => stopPair.second != -1)
            .toList();
        return index == 0
            ? busExpansionTile(index, busStops, stopTimes, routeId)
            : busExpansionTile(index, busStops, stopTimes, routeId);

        /// showcase doesn't work because of duplicate global keys (it tries to
        /// use the same global key despite there being multiple tabs)
        // TODO: fix dis Showcase(key: GlobalKey(debugLabel:
        // 'bruh2'),//showcaseTimeline, description:
        // TIMELINE_ITEM_SHOWCASE_MESSAGE, child: busExpansionTile(index,
        // busStops, stopTimes, routeId))
      },
    );
  }

  void _handlePopupSelection(
      String choice, TimetableStop? busStop, Tuple<String, int>? stopTime) {
    if (choice == choices[0]) {
      BlocProvider.of<ScheduleBloc>(context)
          .scheduleBusAlarm(stopTime!.second, busStop!);
    } else if (choice == choices[1]) {
      widget.panelController.animatePanelToPosition(0);
      BlocProvider.of<MapBloc>(context).scrollToLatLng(busStop!.latLng);
    }
  }
}
