part of 'schedule_bloc.dart';


abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}
class ScheduleInit extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
class ScheduleDefault extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
class ScheduleTable extends ScheduleEvent{
  @override
  List<Object> get props => [];
}
