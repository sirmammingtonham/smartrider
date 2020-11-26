// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// bloc stuff
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// loading custom widgets and data
import 'package:smartrider/widgets/shuttle_schedules/shuttle_timeline.dart';
import 'package:smartrider/widgets/shuttle_schedules/shuttle_table.dart';
import 'package:smartrider/widgets/bus_schedules/bus_timeline.dart';
import 'package:smartrider/widgets/bus_schedules/bus_table.dart';

class PanelPage extends StatefulWidget {
  final PanelController panelController;
  final VoidCallback scheduleChanged;
  PanelPage({Key key, this.panelController, this.scheduleChanged})
      : super(key: key);
  @override
  PanelPageState createState() => PanelPageState();
}

class PanelPageState extends State<PanelPage> with TickerProviderStateMixin {
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.airport_shuttle/*, color: Theme.of(context).primaryColor,*/)),
    Tab(icon: Icon(Icons.directions_bus)),
  ];

  TabController _tabController;
  String filter;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(_handleTabSelection);
    BlocProvider.of<ScheduleBloc>(context).add(ScheduleInitEvent());
    filter = null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      ScheduleState s = BlocProvider.of<ScheduleBloc>(context).state;
      BlocProvider.of<ScheduleBloc>(context)
          .add(ScheduleTransitionEvent(currentstate: s));
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
                appBar: panelAppBar(state.isShuttle,
                    this.widget.panelController, _tabController, _tabs),
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ShuttleTimeline(),
                    BusTimeline(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: Icon(Icons.toc, color: Theme.of(context).primaryColor),
                  elevation: 5.0,
                  onPressed: () {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(ScheduleTableEvent());
                  },
                ),
              );
            } else if (state is ScheduleTableState) {
              return Scaffold(
                appBar: panelAppBar(state.isShuttle,
                    this.widget.panelController, _tabController, _tabs),
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ShuttleTable(),
                    BusTable(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: Icon(Icons.timeline, color: Theme.of(context).primaryColor),
                  elevation: 5.0,
                  onPressed: () {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(ScheduleTimelineEvent());
                  },
                ),
              );
            } else if (state is ScheduleTransitionState) {
              BlocProvider.of<ScheduleBloc>(context).add(ScheduleChangeEvent());
              return Scaffold(
                appBar: panelAppBar(state.isShuttle,
                    this.widget.panelController, _tabController, _tabs),
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    state.currentState is ScheduleTableState
                        ? ShuttleTable()
                        : ShuttleTimeline(),
                    state.currentState is ScheduleTableState
                        ? BusTable()
                        : BusTimeline(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: state.currentState is ScheduleTableState
                      ? Icon(Icons.timeline)
                      : Icon(Icons.toc),
                  elevation: 5.0,
                  onPressed: () {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(ScheduleTableEvent());
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
    TabController tabController, List<Widget> tabs, BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).bottomAppBarColor,
    centerTitle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),

    leading: Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 35),
      child: IconButton(
      icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
      onPressed: () {
        panelController.animatePanelToPosition(0);
      },
    )
   ),
    title: Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(isShuttle ? 'Shuttle Schedules' : 'Bus Schedules', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25) ) ),

actions: <Widget>[
  Padding(
      padding: const EdgeInsets.only(right: 45.0, bottom: 35),
      child: IconButton(
        icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
        onPressed: () {
          panelController.animatePanelToPosition(0);
        },
       )
      )
    ],




/*
    leading: IconButton(
      icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
      onPressed: () {
        panelController.animatePanelToPosition(0);
      },
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
        onPressed: () {
          panelController.animatePanelToPosition(0);
        },
      )
    ],*/
    bottom: TabBar(
      unselectedLabelColor: Theme.of(context).disabledColor,
      indicatorColor: Theme.of(context).indicatorColor,
      controller: tabController,
      tabs: tabs,
      labelColor: Theme.of(context).primaryColor,
    ),
  );
}

// _handleSearchQuery() {
//   setState(() {
//     filter = _textController.text;
//   });
// }

// _displayFilterDialog() async {
//   final builder = (BuildContext ctx) => FilterDialog(
//         stops: _isShuttle
//             ? shuttleStopLists[_tabController.index]
//             : busStopLists[_tabController.index],
//         controller: _textController,
//       );
//   await showDialog(context: context, builder: builder);
// }

// bool _containsFilter(var curStopList, var curTimeList, var index) {
//   if (this.filter == null) {
//     return true;
//   }
//   if (double.tryParse(this.filter) != null) {
//     return curTimeList[index].contains(this.filter);
//   }
//   if (this.filter.contains('am') ||
//       this.filter.contains('pm') ||
//       this.filter.contains(':')) {
//     return curTimeList[index].contains(this.filter);
//   }
//   if (this.filter.contains('@')) {
//     var filterSplit = this.filter.split('@');
//     return (curStopList[index % curStopList.length][0]
//             .toLowerCase()
//             .contains(filterSplit[0].toLowerCase()) &&
//         curTimeList[index].contains(filterSplit[1]));
//   }
//   return curStopList[index % curStopList.length][0]
//       .toLowerCase()
//       .contains(this.filter.toLowerCase().trim());
// }

// _jumpMap(double lat, double long) {
//   this.widget.panelController.animatePanelToPosition(0);
//   BlocProvider.of<MapBloc>(context).scrollToLocation(LatLng(lat, long));
// }
