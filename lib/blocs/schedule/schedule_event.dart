part of 'schedule_bloc.dart';


abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}
class ScheduleInitEvent extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
class ScheduleTimelineEvent extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
class ScheduleTableEvent extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
