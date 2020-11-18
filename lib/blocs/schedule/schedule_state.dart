part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}
class ScheduleInitialState extends ScheduleState{
  final Map<String,Map<String,String>> bustimetable;
  const ScheduleInitialState({@required this.bustimetable});
  @override
  List<Object> get props => [];
}
class ScheduleTimelineState extends ScheduleState{
  final bool isShuttle;
  final Map<String,Map<String,String>> bustimetable;
  const ScheduleTimelineState({@required this.isShuttle,@required this.bustimetable});
  @override
  List<Object> get props => [];
}
class ScheduleTableState extends ScheduleState{
  final bool isShuttle;
  final Map<String,Map<String,String>> bustimetable;
  const ScheduleTableState({@required this.isShuttle, @required this.bustimetable});
  @override
  List<Object> get props => [];
}

class ScheduleChangeState extends ScheduleState{
  final bool isShuttle;
  final Map<String,Map<String,String>> bustimetable;
  const ScheduleChangeState({@required this.isShuttle,@required this.bustimetable});
  @override
  List<Object> get props => [];
}

class ScheduleTransitionState extends ScheduleState{
  final bool isShuttle;
  final ScheduleState currentState;
  final bool update;
  const ScheduleTransitionState({@required this.isShuttle,@required this.currentState, this.update = false});
  @override
  List<Object> get props => [];
}

// class ScheduleUpdateState extends ScheduleState{
//   final Map<String,Map<String,String>> timetable;
//   final bool isShuttle;
//   const ScheduleUpdateState({@required this.isShuttle, @required this.timetable});
//   @override
//   List<Object> get props => [];

// }