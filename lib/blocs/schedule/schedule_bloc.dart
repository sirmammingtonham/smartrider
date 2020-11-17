import 'dart:async';

import 'package:flutter/material.dart';

import 'package:smartrider/data/models/bus/bus_stop.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';
import 'package:smartrider/data/repository/bus_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///import 'package:smartrider/pages/schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BusRepository busRepo;
  ScheduleBloc({@required this.busRepo}) : super(ScheduleInitialState());

  bool isShuttle =
      true; //true if we have to build the shuttle schedule, false if bus
  ScheduleState prevState;
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleInitEvent) {
      yield* _mapScheduleInitToState();
    } else if (event is ScheduleTimelineEvent) {
      yield* _mapScheduleTimelineToState();
    } else if (event is ScheduleTableEvent) {
      yield* _mapScheduleTableToState();
    } else if (event is ScheduleChangeEvent) {
      this.isShuttle = !this.isShuttle;
      if (this.prevState is ScheduleTimelineState) {
        yield* _mapScheduleTimelineToState();
      } else if (this.prevState is ScheduleTableState) {
        yield* _mapScheduleTableToState();
      }
    } else if (event is ScheduleTransitionEvent) {
      this.prevState = event.currentstate;
      yield* _mapScheduleTransitionToState();
    }
  }

  Stream<ScheduleState> _mapScheduleInitToState() async* {
    yield ScheduleTimelineState(isShuttle: this.isShuttle);
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState(
        isShuttle: this.isShuttle); // is shuttle default to true
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(
        isShuttle: this.isShuttle,
        stopMap: await busRepo.getStops,
        timetableMap: await busRepo.getTimetables);
  }

  Stream<ScheduleState> _mapScheduleTransitionToState() async* {
    yield ScheduleTransitionState(
        currentState: this.prevState, isShuttle: this.isShuttle);
  }
}
