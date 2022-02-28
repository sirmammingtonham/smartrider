import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_timetable.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/ui/widgets/sliding_up_panel.dart';
import 'package:timezone/timezone.dart' as tz;

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required this.mapBloc,
    required this.busRepo,
    required this.notifications,
  }) : super(ScheduleInitialState()) {
    _isTimeline = true;
    platformChannelSpecifics = const NotificationDetails(
      android: AndroidNotificationDetails(
        'schedule_alarm',
        'Schedule notifications',
        channelDescription: 'Notifications for bus/shuttle arrivals',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(),
    );

    mapBloc.stream.listen((mapState) {
      if (mapState is MapLoadedState) {
        switch (mapState.mapView) {
          case MapView.kBusView:
            if (_tabController.index != 0) {
              _tabController.animateTo(0);
            }
            break;
          case MapView.kShuttleView:
            if (_tabController.index != 1) {
              _tabController.animateTo(1);
            }
            break;
          case MapView.kSaferideView:
            break;
        }
      }
    });
  }

  final BusRepository busRepo;
  final MapBloc mapBloc;
  final FlutterLocalNotificationsPlugin notifications;
  late final NotificationDetails platformChannelSpecifics;
  late final PanelController _panelController;
  late final TabController _tabController;

  late bool _isTimeline;

  PanelController get panelController => _panelController;
  TabController get tabController => _tabController;

  Map<String, BusRoute>? busRoutes;
  Map<String, BusTimetable>? busTables;

  Future<void> scheduleAlarm({
    required String vehicle,
    required String stopName,
    required int secondsFromNow,
    required String payload,
  }) async {
    // set up an alert for 5 mins before, 2 mins, before, and 1 min before
    for (final timeOffset in [300, 120, 60]) {
      if (secondsFromNow - timeOffset > 0) {
        await notifications.zonedSchedule(
          timeOffset,
          '$vehicle arriving in ${timeOffset ~/ 60} '
              'minute${timeOffset == 60 ? "" : "s"}!',
          '$stopName is arriving soon!',
          tz.TZDateTime.now(tz.local)
              .add(Duration(seconds: secondsFromNow - timeOffset)),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: payload,
        );
      }
    }

    await notifications.zonedSchedule(
      0,
      'Your ${vehicle.toLowerCase()} is here!',
      '$stopName should have arrived.',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: secondsFromNow)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }

  Future<void> scheduleBusAlarm(
    int secondsFromNow,
    TimetableStop stop,
  ) =>
      scheduleAlarm(
        vehicle: 'Bus',
        stopName: stop.stopName,
        secondsFromNow: secondsFromNow,
        payload: jsonEncode({
          'latitude': stop.stopLat,
          'longitude': stop.stopLon,
        }),
      );

  Future<void> scheduleShuttleAlarm(
    int secondsFromNow,
    ShuttleStop stop,
  ) =>
      scheduleAlarm(
        vehicle: 'Shuttle',
        stopName: stop.name ?? '',
        secondsFromNow: secondsFromNow,
        payload: jsonEncode({
          'latitude': stop.coordinate?.latitude,
          'longitude': stop.coordinate?.longitude,
        }),
      );

  void tabListener() {
    add(const ScheduleViewChangeEvent());
    if (_tabController.index == 0 && mapBloc.mapView != MapView.kBusView) {
      mapBloc.add(const MapViewChangeEvent(newView: MapView.kBusView));
    } else if (_tabController.index == 1 &&
        mapBloc.mapView != MapView.kShuttleView) {
      mapBloc.add(const MapViewChangeEvent(newView: MapView.kShuttleView));
    }
  }

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    switch (event.runtimeType) {
      case ScheduleInitEvent:
        {
          _tabController = (event as ScheduleInitEvent).tabController
            ..addListener(tabListener);
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
