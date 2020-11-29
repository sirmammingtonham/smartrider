part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class ScheduleInitEvent extends ScheduleEvent {
  @override
  List<Object> get props => [];
}

class ScheduleViewChangeEvent extends ScheduleEvent {
  final bool isTimeline;
  ScheduleViewChangeEvent({@required this.isTimeline});

  @override
  List<Object> get props => [this.isTimeline];
}

class ScheduleNotificationEvent extends ScheduleEvent {
  // final bool isTimeline;
  ScheduleNotificationEvent();

  @override
  List<Object> get props => [];
}
