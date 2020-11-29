import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartrider/data/models/bus/bus_route.dart';

import 'package:smartrider/data/models/bus/bus_stop.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';
import 'package:smartrider/data/repository/bus_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BusRepository busRepo;

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

  ScheduleBloc({@required this.busRepo}) : super(ScheduleInitialState()) {
    _notifications.initialize(
        InitializationSettings(AndroidInitializationSettings('app_icon'),
            IOSInitializationSettings()),
        onSelectNotification: _notificationSelected);
  }

  Map<String, BusRoute> busRoutes;
  Map<String, BusTimetable> busTables;

  Future _notificationSelected(String payload) async {
    /// TODO: should zoom the map onto the stop or open the timeline
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text("Notification : $payload"),
    //   ),
    // );
  }

  Future<void> scheduleAlarm(int secondsFromNow, String stopName,
      {bool isShuttle = true}) async {
    await _notifications.schedule(
        0,
        isShuttle ? 'Shuttle Reminder' : 'Bus Reminder', //
        isShuttle ? 'Shuttle ' : 'Bus ' + stopName + ' is arriving soon!',
        DateTime.now().add(Duration(seconds: secondsFromNow)),
        _platformChannelSpecifics,
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
    } else if (event is ScheduleNotificationEvent) {
    } else {}
  }

  /// return map<route_id, list<time>>
  // Future<Map<String,Map<String,String>>> combineUpdatesTable() async{
  //   Map<String,Map<String,String>> updates = await provider.getNewTripUpdates();
  //   // might combine with bustimetable in the future
  //   return updates;
  //   }

  // Stream<ScheduleState> _mapScheduleInitToState() async* {
  //   yield ScheduleTimelineState();
  // }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState(busRoutes: busRoutes, busTables: busTables);
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(busTables: busTables);
  }
}
