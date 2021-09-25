part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class ScheduleInitEvent extends ScheduleEvent {
  const ScheduleInitEvent(
      {required this.panelController, required this.tabController});

  final PanelController panelController;
  final TabController tabController;

  @override
  List<Object?> get props => [panelController, tabController];
}

class ScheduleViewChangeEvent extends ScheduleEvent {
  const ScheduleViewChangeEvent();

  @override
  List<Object> get props => [];
}

class ScheduleTypeChangeEvent extends ScheduleEvent {
  const ScheduleTypeChangeEvent({required this.isTimeline});

  final bool isTimeline;

  @override
  List<Object> get props => [isTimeline];
}
