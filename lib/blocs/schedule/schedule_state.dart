part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

class ScheduleInitialState extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleTimelineState extends ScheduleState {
  final Map<String, BusRoute> busRoutes;
  const ScheduleTimelineState({@required this.busRoutes});
  
  @override
  List<Object> get props => [this.busRoutes];
}

class ScheduleTableState extends ScheduleState {
  final Map<String, BusTimetable> timetableMap;
  const ScheduleTableState({@required this.timetableMap});

  @override
  List<Object> get props => [this.timetableMap];
}
