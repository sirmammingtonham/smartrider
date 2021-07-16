part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class ScheduleInitEvent extends ScheduleEvent {
  final PanelController panelController;
  final TabController tabController;

  const ScheduleInitEvent(
      {required this.panelController, required this.tabController});

  @override
  List<Object?> get props => [panelController, tabController];
}

class ScheduleViewChangeEvent extends ScheduleEvent {
  const ScheduleViewChangeEvent();

  @override
  List<Object> get props => [];
}

class ScheduleTypeChangeEvent extends ScheduleEvent {
  final bool isTimeline;
  const ScheduleTypeChangeEvent({required this.isTimeline});

  @override
  List<Object> get props => [this.isTimeline];
}
