// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/util/multi_bloc_builder.dart';
import 'package:sizer/sizer.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';

// bloc stuff
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// loading custom widgets and data
import 'package:showcaseview/showcaseview.dart';
import 'package:shared/util/messages.dart';
import 'package:smartrider/widgets/saferide_status_widgets.dart'
    as saferide_widgets;
// import 'package:smartrider/widgets/shuttle_schedules/shuttle_timeline.dart';
// import 'package:smartrider/widgets/shuttle_schedules/shuttle_table.dart';
import 'package:smartrider/widgets/shuttle_schedules/shuttle_unavailable.dart';
import 'package:smartrider/widgets/bus_schedules/bus_timeline.dart';
import 'package:smartrider/widgets/bus_schedules/bus_table.dart';
import 'package:smartrider/pages/home.dart';

class PanelPage extends StatelessWidget {
  PanelPage({Key? key, required this.panelScrollController}) : super(key: key);

  final ScrollController panelScrollController;
  final List<Widget> _tabs = [
    const Tab(icon: Icon(Icons.directions_bus, color: Colors.grey)),
    const Tab(icon: Icon(Icons.airport_shuttle, color: Colors.grey)),
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
        'Schedules',
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.white,
        ),
      ),
    );
    return Stack(
      children: [
        // ignore: sized_box_for_whitespace
        Container(
          color: Theme.of(context).primaryColor,
          height: saferide_widgets.saferideDefaultHeight,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                    timetableMap:
                        (scheduleState as ScheduleTableState).busTables),
                const ShuttleUnavailable(),
              ],
      );

  Future<void> _saferideDriverCancelPopup(
      BuildContext context, SaferideCancelledState saferideState) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Driver Cancelled Your Ride!'),
        content: Text('REASON: ${saferideState.reason}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
// TODO: prompt to send email to student life or something
              BlocProvider.of<SaferideBloc>(context).add(SaferideNoEvent());
              Navigator.pop(context, 'Report');
            },
            child: const Text('Report Driver'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<SaferideBloc>(context).add(SaferideNoEvent());
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocBuilder(
      blocs: [
        BlocProvider.of<ScheduleBloc>(context),
        BlocProvider.of<SaferideBloc>(context),
      ],
      builder: (context, states) {
        final scheduleState = states.get<ScheduleState>();
        final saferideState = states.get<SaferideState>();

        late final Widget appBarWidget;
        switch (saferideState.runtimeType) {
          case SaferideNoState:
          case SaferideDroppingOffState:
            appBarWidget = panelAppBar(context, scheduleState);
            break;
          case SaferideSelectingState:
            appBarWidget = saferide_widgets.saferideSelectionWidget(
                context, saferideState as SaferideSelectingState);

            break;
          case SaferideWaitingState:
            appBarWidget = saferide_widgets.saferideWaitingWidget(
                context, saferideState as SaferideWaitingState);
            break;
          case SaferidePickingUpState:
            appBarWidget = saferide_widgets.saferidePickingUpWidget(
                context, saferideState as SaferidePickingUpState);
            break;
          case SaferideCancelledState:
            _saferideDriverCancelPopup(
                context, saferideState as SaferideCancelledState);
            appBarWidget = Container();
            break;
          default:
            appBarWidget = Container();
            break;
        }

        switch (scheduleState.runtimeType) {
          case ScheduleTimelineState:
          case ScheduleTableState:
            {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                child: Scaffold(
                  body: Column(
                    children: [
                      appBarWidget,
                      Showcase(
                        key: showcaseTransportTab,
                        description: slidingPageTabShowcaseMessage,
                        child: TabBar(
                          controller: BlocProvider.of<ScheduleBloc>(context)
                              .tabController,
                          tabs: _tabs,
                        ),
                      ),
                      Expanded(child: panelBody(context, scheduleState))
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    heroTag: 'switch_schedule_view_button',
                    elevation: 5.0,
                    onPressed: () {
                      if (scheduleState is ScheduleTimelineState) {
                        BlocProvider.of<ScheduleBloc>(context).add(
                            const ScheduleTypeChangeEvent(isTimeline: false));
                      } else if (scheduleState is ScheduleTableState) {
                        BlocProvider.of<ScheduleBloc>(context).add(
                            const ScheduleTypeChangeEvent(isTimeline: true));
                      }
                    },
                    child: Icon(scheduleState is ScheduleTimelineState
                        ? Icons.table_view
                        : Icons.timeline),
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
