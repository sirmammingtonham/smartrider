part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
  @override
  List<Object?> get props => [];
}

class ScheduleInitialState extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleTimelineState extends ScheduleState {
  const ScheduleTimelineState(
      {required this.busTables,
      required this.shuttleTables,
      required this.shuttleAnnouncements,});

  final Map<String?, BusTimetable>? busTables;
  final Object? shuttleTables; // placeholder
  final List<ShuttleAnnouncement> shuttleAnnouncements;

  @override
  List<Object?> get props => [busTables];
}

class ScheduleTableState extends ScheduleState {
  const ScheduleTableState({
    required this.busTables,
    required this.shuttleTables,
    required this.shuttleAnnouncements,
  });

  final Map<String?, BusTimetable>? busTables;
  final Object? shuttleTables; // placeholder
  final List<ShuttleAnnouncement> shuttleAnnouncements;

  @override
  List<Object?> get props => [busTables];
}
