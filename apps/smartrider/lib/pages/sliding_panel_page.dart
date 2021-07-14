// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sizer/sizer.dart';

// bloc stuff
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// loading custom widgets and data
import 'package:showcaseview/showcaseview.dart';
import 'package:shared/util/messages.dart';
// import 'package:smartrider/widgets/shuttle_schedules/shuttle_timeline.dart';
// import 'package:smartrider/widgets/shuttle_schedules/shuttle_table.dart';
import 'package:smartrider/widgets/shuttle_schedules/shuttle_unavailable.dart';
import 'package:smartrider/widgets/bus_schedules/bus_timeline.dart';
import 'package:smartrider/widgets/bus_schedules/bus_table.dart';
import 'package:smartrider/pages/home.dart';

class PanelPage extends StatelessWidget {
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.directions_bus)),
    Tab(icon: Icon(Icons.airport_shuttle)),
  ];

  Widget panelAppBar(bool isBus, PanelController panelController,
      TabController tabController, List<Widget> tabs) {
    final barSize = AppBar().preferredSize;
    return AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        // TODO: add little bar at the top to pull like google maps (might be more trouble than it's worth)
        title: Text(isBus ? 'Bus Schedules' : 'Shuttle Schedules'),
        leading: IconButton(
          icon: Icon(Icons.expand_more),
          onPressed: () {
            panelController
                .animatePanelToPosition(panelController.isPanelClosed ? 1 : 0);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.expand_more),
            onPressed: () {
              panelController.animatePanelToPosition(
                  panelController.isPanelClosed ? 1 : 0);
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: barSize,
          child: Showcase(
              key: showcaseTransportTab,
              description: SLIDING_PAGE_TAB_SHOWCASE_MESSAGE,
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
            if (scheduleState is ScheduleTimelineState ||
                scheduleState is ScheduleTableState) {
              return Scaffold(
                appBar: panelAppBar(
                    scheduleState.isBus,
                    BlocProvider.of<ScheduleBloc>(context).panelController,
                    BlocProvider.of<ScheduleBloc>(context).tabController,
                    _tabs) as PreferredSizeWidget?,
                body: TabBarView(
                  controller:
                      BlocProvider.of<ScheduleBloc>(context).tabController,
                  children: scheduleState is ScheduleTimelineState
                      ? [
                          // timeline widgets
                          BusTimeline(
                            panelController:
                                BlocProvider.of<ScheduleBloc>(context)
                                    .panelController,
                            busTables: scheduleState.busTables,
                          ),
                          ShuttleUnavailable(),
                        ]
                      : [
                          // table widgets
                          BusTable(
                              timetableMap:
                                  (scheduleState as ScheduleTableState)
                                      .busTables),
                          ShuttleUnavailable(),
                        ],
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "switch_schedule_view_button",
                  child: Icon(scheduleState is ScheduleTimelineState
                      ? Icons.toc
                      : Icons.timeline),
                  elevation: 5.0,
                  onPressed: () {
                    if (scheduleState is ScheduleTimelineState)
                      BlocProvider.of<ScheduleBloc>(context)
                          .add(ScheduleViewChangeEvent(isTimeline: false));
                    else if (scheduleState is ScheduleTableState)
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
