import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/util/consts/messages.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/ui/home.dart';
import 'package:smartrider/ui/widgets/bus_schedules/bus_table.dart';
import 'package:smartrider/ui/widgets/bus_schedules/bus_timeline.dart';
import 'package:smartrider/ui/widgets/shuttle_schedules/shuttle_unavailable.dart';

class PanelBody extends StatelessWidget {
  PanelBody({
    Key? key,
    required this.panelScrollController,
    required this.headerHeight,
  }) : super(key: key);

  final ScrollController panelScrollController;
  final double headerHeight;
  final List<Widget> _tabs = [
    const Tab(text: 'Bus Schedule', icon: Icon(Icons.directions_bus)),
    const Tab(text: 'Shuttle Schedule', icon: Icon(Icons.airport_shuttle)),
  ];

  Widget panelBody(BuildContext context, ScheduleState scheduleState) =>
//TODO: probably need a document or something in the database to manually
// enable/disable the schedules in case of an outage or something
      TabBarView(
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
                const ShuttleUnavailable(),
              ]
            : [
                // table widgets
                BusTable(
                  timetableMap: (scheduleState as ScheduleTableState).busTables,
                ),
                const ShuttleUnavailable(),
              ],
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ScheduleBloc>(context),
      builder: (context, scheduleState) {
        switch (scheduleState.runtimeType) {
          case ScheduleTimelineState:
          case ScheduleTableState:
            {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Scaffold(
                  body: Column(
                    children: [
                      SizedBox(height: headerHeight),
                      Showcase(
                        key: showcaseTransportTab,
                        description: slidingPageTabShowcaseMessage,
                        child: TabBar(
                          controller: BlocProvider.of<ScheduleBloc>(context)
                              .tabController,
                          indicatorColor:
                              Theme.of(context).colorScheme.secondary,
                          labelColor:
                              Theme.of(context).colorScheme.onBackground,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                          tabs: _tabs,
                        ),
                      ),
                      Expanded(
                        child:
                            panelBody(context, scheduleState! as ScheduleState),
                      )
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    heroTag: 'switch_schedule_view_button',
                    elevation: 5,
                    onPressed: () {
                      if (scheduleState is ScheduleTimelineState) {
                        BlocProvider.of<ScheduleBloc>(context).add(
                          const ScheduleTypeChangeEvent(isTimeline: false),
                        );
                      } else if (scheduleState is ScheduleTableState) {
                        BlocProvider.of<ScheduleBloc>(context).add(
                          const ScheduleTypeChangeEvent(isTimeline: true),
                        );
                      }
                    },
                    child: Icon(
                      scheduleState is ScheduleTimelineState
                          ? Icons.table_chart_outlined
                          : Icons.timeline_outlined,
                    ),
                  ),
                ),
              );
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
