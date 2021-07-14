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

  bool _isBus = true;
  late bool _isTimeline;

  /// bool to prevent [_handleTabSelection] callback from switching
  /// if type is updated via bloc event
  late bool _isChanging;

  /// notification stuff
  // final FlutterLocalNotificationsPlugin _notifications =
  //     FlutterLocalNotificationsPlugin();
  // final _platformChannelSpecifics = NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'alarm_notif',
  //       'alarm_notif',
  //       'Channel for Alarm notification',
  //       icon: 'app_icon',
  //       largeIcon: DrawableResourceAndroidBitmap('app_icon'),
  //     ),
  //     iOS: IOSNotificationDetails(
  //         presentAlert: true, presentBadge: true, presentSound: true));

  ScheduleBloc({required this.mapBloc, required this.busRepo})
      : super(ScheduleInitialState()) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // _notifications.initialize(
    //     InitializationSettings(
    //         android: AndroidInitializationSettings('app_icon'),
    //         iOS: IOSInitializationSettings()),
    //     onSelectNotification: _notificationSelected);

    _isBus = true;
    _isTimeline = true;
    _isChanging = false;
  }

  PanelController get panelController => _panelController;
  TabController get tabController => _tabController;

  void _handleTabSelection() {
    if (_tabController.indexIsChanging && !_isChanging) {
      mapBloc.add(MapTypeChangeEvent());
      add(ScheduleTypeChangeEvent());
    }
  }

  Map<String, BusRoute>? busRoutes;
  Map<String?, BusTimetable>? busTables;

  // Future _notificationSelected(String? payload) async {
  //   var split = payload!.split('/').map((coord) => double.tryParse(coord));
  //   LatLng loc = LatLng(split.first!, split.last!);
  //   _panelController!.animatePanelToPosition(0);
  //   mapBloc.scrollToLocation(loc);
  // }

  Future<void> scheduleBusAlarm(int secondsFromNow, TimetableStop stop) async {
    // await _notifications.schedule(
    //     DateTime.now().millisecondsSinceEpoch,
    //     'Your bus is almost here!',
    //     '${stop.stopName} is arriving soon!',
    //     DateTime.now().add(Duration(seconds: secondsFromNow)),
    //     _platformChannelSpecifics,
    //     payload:
    //         '${stop.stopLat}/${stop.stopLon}', // split it so we can parse later
    //     androidAllowWhileIdle: true);
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
    // await _notifications.schedule(
    //     DateTime.now().millisecondsSinceEpoch,
    //     'Your shuttle is almost here!',
    //     '${stop.name} is arriving soon!',
    //     DateTime.now().add(Duration(seconds: secondsFromNow)),
    //     _platformChannelSpecifics,
    //     payload:
    //         '${stop.latitude}/${stop.longitude}', // split it so we can parse later
    //     androidAllowWhileIdle: true);
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
            ..addListener(_handleTabSelection);
          _panelController = event.panelController;
          // busRoutes = await busRepo.getRoutes;
          busTables = await busRepo.getTimetables;
          yield* _mapScheduleTimelineToState();
        }
        break;
      case ScheduleViewChangeEvent:
        {
          _isTimeline = (event as ScheduleViewChangeEvent).isTimeline;
          if (event.isTimeline) {
            yield* _mapScheduleTimelineToState();
          } else {
            yield* _mapScheduleTableToState();
          }
        }
        break;
      case ScheduleTypeChangeEvent:
        {
          _isChanging = true;
          _tabController.animateTo(_isBus ? 1 : 0);
          _isChanging = false;
          _isBus = !_isBus;
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
    yield ScheduleTimelineState(busTables: busTables, isBus: _isBus);
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(busTables: busTables, isBus: _isBus);
  }
}
