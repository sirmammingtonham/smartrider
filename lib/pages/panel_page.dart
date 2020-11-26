// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
// bloc stuff
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// loading custom widgets and data
import 'package:smartrider/widgets/shuttle_schedules/shuttle_timeline.dart';
import 'package:smartrider/widgets/shuttle_schedules/shuttle_table.dart';
import 'package:smartrider/widgets/bus_schedules/bus_timeline.dart';
import 'package:smartrider/widgets/bus_schedules/bus_table.dart';
import 'package:smartrider/widgets/shuttle_schedules/shuttle_unavailable.dart';

///
class PanelPage extends StatefulWidget {
  final PanelController panelController;
  final VoidCallback scheduleChanged;
  PanelPage(
      {Key key, @required this.panelController, @required this.scheduleChanged})
      : super(key: key);
  @override
  PanelPageState createState() => PanelPageState();
}

class PanelPageState extends State<PanelPage> with TickerProviderStateMixin {
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.airport_shuttle)),
    Tab(icon: Icon(Icons.directions_bus)),
  ];

  TabController _tabController;
  String filter;
  bool _isShuttle = true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(_handleTabSelection);
    BlocProvider.of<ScheduleBloc>(context).add(ScheduleInitEvent());
    // const pollRefreshDelay = const Duration(seconds: 5); // update every 3 sec
    // new Timer.periodic(
    //     pollRefreshDelay,
    //     (Timer t) =>
    // BlocProvider.of<ScheduleBloc>(context).add(ScheduleTransitionEvent(currentstate: BlocProvider.of<ScheduleBloc>(context).state, update: true))
    // );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // handling this shit in bloc is too much trouble for something so simple
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _isShuttle = !_isShuttle;
      });
      this.widget.scheduleChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleTimelineState) {
              return Scaffold(
                appBar: panelAppBar(_isShuttle, this.widget.panelController,
                    _tabController, _tabs),
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ShuttleTimeline(),
                    BusTimeline(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: Icon(Icons.toc),
                  elevation: 5.0,
                  onPressed: () {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(ScheduleViewChangeEvent(isTimeline: false));
                  },
                ),
              );
            } else if (state is ScheduleTableState) {
              return Scaffold(
                appBar: panelAppBar(_isShuttle, this.widget.panelController,
                    _tabController, _tabs),
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    // ShuttleTable(),
                    ShuttleUnavailable(),
                    BusTable(timetableMap: state.timetableMap),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: Icon(Icons.timeline),
                  elevation: 5.0,
                  onPressed: () {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(ScheduleViewChangeEvent(isTimeline: true));
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

Widget panelAppBar(bool isShuttle, PanelController panelController,
    TabController tabController, List<Widget> tabs) {
  return AppBar(
    centerTitle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    title: Text(isShuttle ? 'Shuttle Schedules' : 'Bus Schedules'),
    leading: IconButton(
      icon: Icon(Icons.arrow_downward),
      onPressed: () {
        panelController.animatePanelToPosition(0);
      },
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.arrow_downward),
        onPressed: () {
          panelController.animatePanelToPosition(0);
        },
      )
    ],
    bottom: TabBar(
      unselectedLabelColor: Colors.white.withOpacity(0.3),
      indicatorColor: Colors.white,
      controller: tabController,
      tabs: tabs,
    ),
  );
}
