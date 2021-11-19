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
      {required this.busTables, required this.shuttleTables,});

  final Map<String?, BusTimetable>? busTables;
  final Object? shuttleTables; // placeholder

  @override
  List<Object?> get props => [busTables];
}

class ScheduleTableState extends ScheduleState {
  const ScheduleTableState(
      {required this.busTables, required this.shuttleTables,});

  final Map<String?, BusTimetable>? busTables;
  final Object? shuttleTables; // placeholder

  @override
  List<Object?> get props => [busTables];
}
