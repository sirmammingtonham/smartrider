// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// bloc stuff
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';
import 'package:smartrider/util/multi_bloc_builder.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// loading custom widgets and data
import 'package:smartrider/widgets/shuttle_schedules/shuttle_timeline.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:smartrider/widgets/shuttle_schedules/shuttle_table.dart';
import 'package:smartrider/widgets/shuttle_schedules/shuttle_unavailable.dart';
import 'package:smartrider/widgets/bus_schedules/bus_timeline.dart';
import 'package:smartrider/widgets/bus_schedules/bus_table.dart';
import 'package:smartrider/pages/home.dart';

class PanelPage extends StatefulWidget {
  final PanelController panelController;
  PanelPage({Key key, @required this.panelController}) : super(key: key);
  @override
  PanelPageState createState() => PanelPageState();
}

class PanelPageState extends State<PanelPage> with TickerProviderStateMixin {
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.directions_bus)),
    Tab(icon: Icon(Icons.airport_shuttle)),
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget panelAppBar(bool isBus, PanelController panelController,
      TabController tabController, List<Widget> tabs) {
    return AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        title: Text(isBus ? 'Bus Schedules' : 'Shuttle Schedules'),
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
        bottom: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: Showcase(
              key: showcaseTransportTab,
              description:
                  'Click on either tab to switch between bus/shuttle scheudles',
              child: TabBar(
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
                controller: tabController,
                tabs: tabs,
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, scheduleState) {
            if (scheduleState is ScheduleTimelineState) {
              return Scaffold(
                appBar: panelAppBar(
                    scheduleState.isBus,
                    BlocProvider.of<ScheduleBloc>(context).panelController,
                    BlocProvider.of<ScheduleBloc>(context).tabController,
                    _tabs),
                body: TabBarView(
                  controller:
                      BlocProvider.of<ScheduleBloc>(context).tabController,
                  children: <Widget>[
                    BusTimeline(
                      panelController: BlocProvider.of<ScheduleBloc>(context)
                          .panelController,
                      busTables: scheduleState.busTables,
                    ),
                    ShuttleTimeline(
                        panelController: BlocProvider.of<ScheduleBloc>(context)
                            .panelController),
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
            } else if (scheduleState is ScheduleTableState) {
              return Scaffold(
                appBar: panelAppBar(
                    scheduleState.isBus,
                    BlocProvider.of<ScheduleBloc>(context).panelController,
                    BlocProvider.of<ScheduleBloc>(context).tabController,
                    _tabs),
                body: TabBarView(
                  controller:
                      BlocProvider.of<ScheduleBloc>(context).tabController,
                  children: <Widget>[
                    // ShuttleTable(),

                    BusTable(timetableMap: scheduleState.busTables),
                    ShuttleUnavailable(),
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
