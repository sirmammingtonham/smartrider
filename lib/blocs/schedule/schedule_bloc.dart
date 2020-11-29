import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartrider/data/models/bus/bus_route.dart';
import 'package:smartrider/data/models/shuttle/shuttle_stop.dart';

import 'package:smartrider/blocs/map/map_bloc.dart';

import 'package:smartrider/data/models/bus/bus_timetable.dart';
import 'package:smartrider/data/repository/bus_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BusRepository busRepo;
  final MapBloc mapBloc;
  final PanelController panelController;

  /// notification stuff
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final _platformChannelSpecifics = NotificationDetails(
      AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        'Channel for Alarm notification',
        icon: 'app_icon',

        ///sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      ),
      IOSNotificationDetails(

          ///sound: 'a_long_cold_sting.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true));

  ScheduleBloc(
      {@required this.mapBloc,
      @required this.busRepo,
      @required this.panelController})
      : super(ScheduleInitialState()) {
    _notifications.initialize(
        InitializationSettings(AndroidInitializationSettings('app_icon'),
            IOSInitializationSettings()),
        onSelectNotification: _notificationSelected);
  }

  Map<String, BusRoute> busRoutes;
  Map<String, BusTimetable> busTables;

  Future _notificationSelected(String payload) async {
    var split = payload.split('/').map((coord) => double.tryParse(coord));
    LatLng loc = LatLng(split.first, split.last);
    panelController.animatePanelToPosition(0);
    mapBloc.scrollToLocation(loc);
  }

  Future<void> scheduleBusAlarm(int secondsFromNow, TimetableStop stop) async {
    await _notifications.schedule(
        0, //DateTime.now().millisecondsSinceEpoch // unique id? doesnt seem to do anything
        'Your bus is almost here!',
        '${stop.stopName} is arriving soon!',
        DateTime.now().add(Duration(seconds: secondsFromNow)),
        _platformChannelSpecifics,
        payload:
            '${stop.stopLat}/${stop.stopLon}', // split it so we can parse later
        androidAllowWhileIdle: true);
  }

  Future<void> scheduleShuttleAlarm(int secondsFromNow, ShuttleStop stop) async {
    await _notifications.schedule(
        0, //DateTime.now().millisecondsSinceEpoch // unique id? doesnt seem to do anything
        'Your bus is almost here!',
        '${stop.name} is arriving soon!',
        DateTime.now().add(Duration(seconds: secondsFromNow)),
        _platformChannelSpecifics,
        payload:
            '${stop.latitude}/${stop.longitude}', // split it so we can parse later
        androidAllowWhileIdle: true);
  }

  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleInitEvent) {
      busRoutes = await busRepo.getRoutes;
      busTables = await busRepo.getTimetables;
      yield* _mapScheduleTimelineToState();
    } else if (event is ScheduleViewChangeEvent) {
      if (event.isTimeline) {
        yield* _mapScheduleTimelineToState();
      } else {
        yield* _mapScheduleTableToState();
      }
    } else {}
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState(busRoutes: busRoutes, busTables: busTables);
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(busTables: busTables);
  }
}
