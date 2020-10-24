part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}
class ScheduleInitialState extends ScheduleState{
  @override
  List<Object> get props => [];
}
class ScheduleTimelineState extends ScheduleState{
  @override
  List<Object> get props => [];
}
class ScheduleTableState extends ScheduleState{
  @override
  List<Object> get props => [];
}