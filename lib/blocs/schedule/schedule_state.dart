part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

class ScheduleInitialState extends ScheduleState {
  @override
  List<Object> get props => [];
}

class ScheduleTimelineState extends ScheduleState {
  final bool isShuttle;
  const ScheduleTimelineState({@required this.isShuttle});
  @override
  List<Object> get props => [];
}

class ScheduleTableState extends ScheduleState {
  final bool isShuttle;
  final Map<String, BusStop> stopMap;
  final Map<String, BusTimetable> timetableMap;
  const ScheduleTableState(
      {@required this.isShuttle, @required this.stopMap, @required this.timetableMap});
  @override
  List<Object> get props => [isShuttle, timetableMap];
}

class ScheduleChangeState extends ScheduleState {
  final bool isShuttle;
  const ScheduleChangeState({@required this.isShuttle});
  @override
  List<Object> get props => [];
}

class ScheduleTransitionState extends ScheduleState {
  final bool isShuttle;
  final ScheduleState currentState;
  const ScheduleTransitionState(
      {@required this.isShuttle, @required this.currentState});
  @override
  List<Object> get props => [];
}
