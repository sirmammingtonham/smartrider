import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:smartrider/ui/widgets/sliding_up_panel.dart';
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';

import 'package:smartrider/blocs/map/map_bloc.dart';

import 'package:shared/models/bus/bus_timetable.dart';
import 'package:smartrider/blocs/map/data/bus_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({required this.mapBloc, required this.busRepo})
      : super(ScheduleInitialState()) {
    _isTimeline = true;
  }

  final BusRepository busRepo;
  final MapBloc mapBloc;
  late final PanelController _panelController;
  late final TabController _tabController;

  static const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '10', 'basic_channel',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  static const platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late bool _isTimeline;

  PanelController get panelController => _panelController;
  TabController get tabController => _tabController;

  Map<String, BusRoute>? busRoutes;
  Map<String?, BusTimetable>? busTables;

  void onDidReceiveLocalNotification(int x, String? s, String? r, String? i) {}

  void selectNotification(String? s) async {
    if (s != null) {
      debugPrint('notification payload: $s');
    }
  }

  Future<void> scheduleBusAlarm(int secondsFromNow, TimetableStop stop) async {
    await flutterLocalNotificationsPlugin.show(
        secondsFromNow,
        'Your bus is almost here!',
        '${stop.stopName} is arriving soon!',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> scheduleShuttleAlarm(
      int secondsFromNow, ShuttleStop stop) async {
    await flutterLocalNotificationsPlugin.show(
        secondsFromNow,
        'Your bus is almost here!',
        '${stop.name} is arriving soon!',
        platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    switch (event.runtimeType) {
      case ScheduleInitEvent:
        {
          const initializationSettingsAndroid =
              AndroidInitializationSettings('app_icon');

          final initializationSettingsIOS = IOSInitializationSettings(
              onDidReceiveLocalNotification: onDidReceiveLocalNotification);
          final initializationSettings = InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
          await flutterLocalNotificationsPlugin.initialize(
              initializationSettings,
              onSelectNotification: selectNotification);
          _tabController = (event as ScheduleInitEvent).tabController
            ..addListener(() => add(const ScheduleViewChangeEvent()));
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
