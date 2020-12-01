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
  final TabController tabController;
  final VoidCallback homePageCallback;

  bool _isBus;
  bool _isTimeline;

  /// bool to prevent [_handleTabSelection] callback from switching 
  /// if type is updated via bloc event
  bool _isChanging; 

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
      @required this.panelController,
      @required this.tabController,
      @required this.homePageCallback})
      : super(ScheduleInitialState()) {
    _notifications.initialize(
        InitializationSettings(AndroidInitializationSettings('app_icon'),
            IOSInitializationSettings()),
        onSelectNotification: _notificationSelected);

    tabController.addListener(_handleTabSelection);

    _isBus = true;
    _isTimeline = true;
  }

  void _handleTabSelection() {
    if (tabController.indexIsChanging && !_isChanging) {
      mapBloc.add(MapTypeChangeEvent(zoomLevel: null));
      add(ScheduleTypeChangeEvent());
    }
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

  Future<void> scheduleShuttleAlarm(
      int secondsFromNow, ShuttleStop stop) async {
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
      // busRoutes = await busRepo.getRoutes;
      busTables = await busRepo.getTimetables;
      yield* _mapScheduleTimelineToState();
    } else if (event is ScheduleViewChangeEvent) {
      _isTimeline = event.isTimeline;
      if (event.isTimeline) {
        yield* _mapScheduleTimelineToState();
      } else {
        yield* _mapScheduleTableToState();
      }
    } else if (event is ScheduleTypeChangeEvent) {
      homePageCallback();
      _isChanging = true;
      tabController.animateTo(_isBus ? 1 : 0);
      _isChanging = false;
      _isBus = !_isBus;
      if (_isTimeline) {
        yield* _mapScheduleTimelineToState();
      } else {
        yield* _mapScheduleTableToState();
      }
    } else {}
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState(busTables: busTables, isBus: _isBus);
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(busTables: busTables, isBus: _isBus);
  }
}
