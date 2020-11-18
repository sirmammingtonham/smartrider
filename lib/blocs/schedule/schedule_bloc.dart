import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/data/providers/bus_provider.dart';
import 'package:smartrider/data/models/bus/bus_trip_update.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';
import 'package:intl/intl.dart';
///import 'package:smartrider/pages/schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitialState(bustimetable: {}));
  bool isShuttle =
      true; //true if we have to build the shuttle schedule, false if bus
  Map<String,Map<String,String>> bustimetable = {};
  ScheduleState prevState;
  BusProvider bprovider = BusProvider();
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
    } else if (event is ScheduleTransitionEvent){
      this.prevState = event.currentstate;
      yield* _mapScheduleTransitionToState(event.update);
    }
    
  
  }
  /// return map<route_id, list<time>>
  Future<Map<String,Map<String,String>>> combineUpdatesTable() async{
    Map<String,Map<String,String>> updates = await bprovider.getNewTripUpdates();
    // might combine with bustimetable in the future
    return updates;
    }
   
  Stream<ScheduleState> _mapScheduleInitToState() async* {
    this.bustimetable = await this.combineUpdatesTable();
    yield ScheduleTimelineState(isShuttle: this.isShuttle, bustimetable: this.bustimetable);
  }

  Stream<ScheduleState> _mapScheduleTimelineToState() async* {
     this.bustimetable = await this.combineUpdatesTable();
    yield ScheduleTimelineState(
        isShuttle: this.isShuttle, bustimetable: this.bustimetable); // is shuttle default to true
  }

  Stream<ScheduleState> _mapScheduleTableToState() async* {
     this.bustimetable = await this.combineUpdatesTable();
    yield ScheduleTableState(isShuttle: this.isShuttle, bustimetable: this.bustimetable);
  }
  Stream<ScheduleState> _mapScheduleTransitionToState(bool requireupdate) async*{
    
    if (!requireupdate){ 
    yield ScheduleTransitionState(currentState: this.prevState, isShuttle: this.isShuttle,update: false);  
    }
    else{
      yield ScheduleTransitionState(currentState: this.prevState, isShuttle: this.isShuttle,update: true);
    }
  }
  
  
}
