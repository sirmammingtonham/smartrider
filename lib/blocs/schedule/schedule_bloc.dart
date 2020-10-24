import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///import 'package:smartrider/pages/schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitialState());

  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleInitEvent) {
      yield* _mapScheduleInitToState();
    } else if (event is ScheduleTimelineEvent) {
      yield* _mapScheduleTimelineToState();
    } else if (event is ScheduleTableEvent) {
      yield* _mapScheduleTableToState();
    }
  }

  Stream<ScheduleState> _mapScheduleInitToState() async* {
    yield ScheduleTimelineState();
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState();
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState();
  }
}
