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
  final Map<String, BusTimetable> busTables;
  const ScheduleTimelineState({@required this.busRoutes, @required this.busTables });

  @override
  List<Object> get props => [this.busRoutes];
}

class ScheduleTableState extends ScheduleState {
  final Map<String, BusTimetable> busTables;
  const ScheduleTableState({@required this.busTables});

  @override
  List<Object> get props => [this.busTables];
}
