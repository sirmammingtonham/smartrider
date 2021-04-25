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
import 'package:smartrider/widgets/shuttle_schedules/shuttle_unavailable.dart';

///
class PanelPage extends StatefulWidget {
  final PanelController panelController;
  // final TabController tabController;
  final VoidCallback scheduleChanged;
  PanelPage(
      {Key key, @required this.panelController, @required this.scheduleChanged})
      : super(key: key);
  @override
  PanelPageState createState() => PanelPageState();
}

class PanelPageState extends State<PanelPage> with TickerProviderStateMixin {
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.directions_bus)),
    Tab(icon: Icon(Icons.airport_shuttle)),
  ];

  ScheduleBloc _scheduleBloc;

  @override
  void initState() {
    super.initState();
    _scheduleBloc = BlocProvider.of<ScheduleBloc>(context)
      ..add(ScheduleInitEvent());
  }

  @override
  void dispose() {
    _scheduleBloc.close();
    super.dispose();
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
                appBar: panelAppBar(state.isBus, _scheduleBloc.panelController,
                    _scheduleBloc.tabController, _tabs, context),
                body: TabBarView(
                  controller: _scheduleBloc.tabController,
                  children: <Widget>[
                    BusTimeline(
                      panelController: _scheduleBloc.panelController,
                      busTables: state.busTables,
                    ),
                    ShuttleTimeline(
                        panelController: _scheduleBloc.panelController),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: Icon(Icons.toc, color: Theme.of(context).primaryColor),
                  elevation: 5.0,
                  onPressed: () {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(ScheduleViewChangeEvent(isTimeline: false));
                  },
                ),
              );
            } else if (state is ScheduleTableState) {
              return Scaffold(
                appBar: panelAppBar(state.isBus, _scheduleBloc.panelController,
                    _scheduleBloc.tabController, _tabs, context),
                body: TabBarView(
                  controller: _scheduleBloc.tabController,
                  children: <Widget>[
                    // ShuttleTable(),

                    BusTable(timetableMap: state.busTables),
                    ShuttleUnavailable(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "Filter",
                  child: Icon(Icons.timeline, color: Theme.of(context).primaryColor),
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

Widget panelAppBar(bool isBus, PanelController panelController,
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
       child: Text(isBus ? 'Bus Schedules' : 'Shuttle Schedules', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25) ) ),

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
    bottom: TabBar(
      unselectedLabelColor: Theme.of(context).disabledColor,
       indicatorColor: Theme.of(context).indicatorColor,
      controller: tabController,
      tabs: tabs,
      labelColor: Theme.of(context).primaryColor,
    ),
  );
}
