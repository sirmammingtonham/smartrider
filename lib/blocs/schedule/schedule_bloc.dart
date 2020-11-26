import 'dart:async';

import 'package:flutter/material.dart';

import 'package:smartrider/data/models/bus/bus_stop.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';
import 'package:smartrider/data/repository/bus_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BusRepository busRepo;
  ScheduleBloc({@required this.busRepo}) : super(ScheduleInitialState());

  Map<String, BusTimetable> timetableMap;

  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleInitEvent) {
      timetableMap = await busRepo.getTimetables;
      yield* _mapScheduleInitToState();
    } else if (event is ScheduleViewChangeEvent) {
      if (event.isTimeline) {
        yield* _mapScheduleTimelineToState();
      } else {
        yield* _mapScheduleTableToState();
      }
    }
    
  
  }
  /// return map<route_id, list<time>>
  // Future<Map<String,Map<String,String>>> combineUpdatesTable() async{
  //   Map<String,Map<String,String>> updates = await provider.getNewTripUpdates();
  //   // might combine with bustimetable in the future
  //   return updates;
  //   }
   
  Stream<ScheduleState> _mapScheduleInitToState() async* {
    yield ScheduleTimelineState();
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
    yield ScheduleTimelineState(); // is shuttle default to true
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
    yield ScheduleTableState(timetableMap: timetableMap);
  }
  
  
}
