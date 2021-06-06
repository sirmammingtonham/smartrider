part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  final bool? isBus = true;
  const ScheduleState();
  @override
  List<Object?> get props => [isBus];
}

class ScheduleInitialState extends ScheduleState {
  final bool isBus = true;
  @override
  List<Object> get props => [isBus];
}

class ScheduleTimelineState extends ScheduleState {
  // final Map<String, BusRoute> busRoutes;
  final Map<String?, BusTimetable>? busTables;
  final bool isBus;
  const ScheduleTimelineState({required this.busTables, required this.isBus});

  @override
  List<Object?> get props => [this.busTables, this.isBus];
}

class ScheduleTableState extends ScheduleState {
  final Map<String?, BusTimetable>? busTables;
  final bool isBus;
  const ScheduleTableState({required this.busTables, required this.isBus});

  @override
  List<Object?> get props => [this.busTables, this.isBus];
}
