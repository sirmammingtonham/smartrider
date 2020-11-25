part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

class ScheduleInitialState extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleTimelineState extends ScheduleState {
  const ScheduleTimelineState();
  @override
  List<Object> get props => [];
}

class ScheduleTableState extends ScheduleState {
  final Map<String, BusTimetable> timetableMap;
  const ScheduleTableState(
      {@required this.timetableMap});
  @override
  List<Object> get props => [timetableMap];
}
