import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';

import 'package:smartrider/blocs/map/map_bloc.dart';

import 'package:shared/models/bus/bus_timetable.dart';
import 'package:smartrider/data/repositories/bus_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BusRepository busRepo;
  final MapBloc mapBloc;
  late final PanelController _panelController;
  late final TabController _tabController;

  late bool _isTimeline;

  ScheduleBloc({required this.mapBloc, required this.busRepo})
      : super(ScheduleInitialState()) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    _isTimeline = true;
  }

  PanelController get panelController => _panelController;
  TabController get tabController => _tabController;

  Map<String, BusRoute>? busRoutes;
  Map<String?, BusTimetable>? busTables;

  Future<void> scheduleBusAlarm(int secondsFromNow, TimetableStop stop) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Your bus is almost here!',
            body: '${stop.stopName} is arriving soon!'),
        schedule: NotificationInterval(
            interval: secondsFromNow, repeats: false, allowWhileIdle: true));
  }

  Future<void> scheduleShuttleAlarm(
      int secondsFromNow, ShuttleStop stop) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Your bus is almost here!',
            body: '${stop.name} is arriving soon!'),
        schedule: NotificationInterval(
            interval: secondsFromNow, repeats: false, allowWhileIdle: true));
  }

  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    switch (event.runtimeType) {
      case ScheduleInitEvent:
        {
          _tabController = (event as ScheduleInitEvent).tabController
            ..addListener(() => add(ScheduleViewChangeEvent()));
          _panelController = event.panelController;
          busTables = await busRepo.getTimetables;
          yield* _mapScheduleTimelineToState();
        }
        break;

      /// type change (i.e. timeline to table)
      case ScheduleTypeChangeEvent:
        {
          _isTimeline = (event as ScheduleTypeChangeEvent).isTimeline;
          if (event.isTimeline) {
            yield* _mapScheduleTimelineToState();
          } else {
            yield* _mapScheduleTableToState();
          }
        }
        break;

      /// view change (i.e. bus schedule to shuttle schedule)
      case ScheduleViewChangeEvent:
        {
          if (_isTimeline) {
            yield* _mapScheduleTimelineToState();
          } else {
            yield* _mapScheduleTableToState();
          }
        }
        break;
      default:
        print('error in schedule bloc');
    }
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState(
      busTables: busTables,
      shuttleTables: null,
    );
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(busTables: busTables, shuttleTables: null);
  }
}
