part of 'schedule_bloc.dart';


abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}
class ScheduleInitEvent extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
class ScheduleTimelineEvent extends ScheduleEvent{

  const ScheduleTimelineEvent();
  @override
  List<Object> get props => [];
}
class ScheduleTableEvent extends ScheduleEvent{

  const ScheduleTableEvent();
  @override
  List<Object> get props => [];
}
class ScheduleChangeEvent extends ScheduleEvent{
  
  @override
  List<Object> get props => [];
}
class ScheduleTransitionEvent extends ScheduleEvent{
  final ScheduleState currentstate;
  const ScheduleTransitionEvent({@required this.currentstate});
  @override
  List<Object> get props => [];
}