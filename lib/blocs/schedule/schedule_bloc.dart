import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/pages/schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  
  ScheduleBloc():super(ScheduleInitialState());

  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
  }
}