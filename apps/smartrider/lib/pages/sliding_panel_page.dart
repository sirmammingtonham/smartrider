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
  final ScrollController panelScrollController;
  PanelPage({required this.panelScrollController});
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.directions_bus, color: Colors.grey)),
    Tab(icon: Icon(Icons.airport_shuttle, color: Colors.grey)),
  ];

  Widget panelAppBar(BuildContext context, ScheduleState scheduleState) {
    void animatePanel() {
      final pc = BlocProvider.of<ScheduleBloc>(context).panelController;
      pc.animatePanelToPosition(pc.isPanelClosed ? 1 : 0);
    }


    final icon = InkWell(
      onTap: animatePanel,
      child: Icon(
        Icons.expand_more,
        color: Colors.white,
        size: 30.sp,
      ),
    );

    final title = Center(
      child: Text(
        scheduleState.isBus ? 'Bus Schedules' : 'Shuttle Schedules',
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.white,
        ),
      ),
    );
    return Stack(
      children: [
        Container(
          color: Theme.of(context).accentColor,
          height: 15.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              icon,
              title,
              icon,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: InkWell(
            onTap: animatePanel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 15.w,
                  height: 3.sp,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget panelBody(BuildContext context, ScheduleState scheduleState) =>
      Expanded(
        child: TabBarView(
          controller: BlocProvider.of<ScheduleBloc>(context).tabController,
          children: scheduleState is ScheduleTimelineState
              ? [
                  // timeline widgets
                  BusTimeline(
                    panelController:
                        BlocProvider.of<ScheduleBloc>(context).panelController,
                    scrollController: panelScrollController,
                    busTables: scheduleState.busTables,
                  ),
                  ShuttleUnavailable(),
                ]
              : [
                  // table widgets
                  BusTable(
                      timetableMap:
                          (scheduleState as ScheduleTableState).busTables),
                  ShuttleUnavailable(),
                ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, scheduleState) {
        if (scheduleState is ScheduleTimelineState ||
            scheduleState is ScheduleTableState) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            child: Scaffold(
              body: Column(
                children: [
                  panelAppBar(context, scheduleState),
                  Showcase(
                    key: showcaseTransportTab,
                    description: SLIDING_PAGE_TAB_SHOWCASE_MESSAGE,
                    child: TabBar(
                      controller:
                          BlocProvider.of<ScheduleBloc>(context).tabController,
                      tabs: _tabs,
                    ),
                  ),
                  panelBody(context, scheduleState)
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
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
