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
  final Map<String?, BusTimetable>? busTables;
  final Object? shuttleTables; // placeholder
  const ScheduleTimelineState({required this.busTables, required this.shuttleTables});

  @override
  List<Object?> get props => [this.busTables];
}

class ScheduleTableState extends ScheduleState {
  final Map<String?, BusTimetable>? busTables;
  final Object? shuttleTables; // placeholder
  const ScheduleTableState({required this.busTables, required this.shuttleTables});

  @override
  List<Object?> get props => [this.busTables];
}
