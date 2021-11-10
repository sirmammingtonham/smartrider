//import 'dart:async';

//import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// if we continue with this, we are using awesome notifications
//import 'package:awesome_notifications/awesome_notifications.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:smartrider/ui/widgets/sliding_up_panel.dart';
//import 'package:shared/models/bus/bus_route.dart';
//import 'package:shared/models/shuttle/shuttle_stop.dart';

//import 'package:smartrider/blocs/map/map_bloc.dart';

//import 'package:shared/models/bus/bus_timetable.dart';
//import 'package:smartrider/data/repositories/bus_repository.dart';

//import 'package:equatable/equatable.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//part 'showcase_event.dart';
//part 'showcase_state.dart';

//class ShowcaseBloc extends Bloc<ShowcaseEvent, ShowcaseState> {
//  // TODO: Replace keys and make public
//  GlobalKey showcaseSettings = GlobalKey();
//  GlobalKey showcaseShuttleToggle = GlobalKey();
//  GlobalKey showcaseLegend = GlobalKey();
//
//  GlobalKey showcaseSettings = GlobalKey();
//  GlobalKey showcaseShuttleToggle = GlobalKey();
//  GlobalKey showcaseProfile = GlobalKey();
//  GlobalKey showcaseSlidingPanel = GlobalKey();
//  GlobalKey showcaseViewChange = GlobalKey();
//  GlobalKey showcaseLocation = GlobalKey();
//  GlobalKey showcaseSearch = GlobalKey();
//  GlobalKey showcaseBusTab = GlobalKey();
//  GlobalKey showcaseTransportTab = GlobalKey();
//  GlobalKey showcaseMap = GlobalKey();
//  GlobalKey showcaseTimeline = GlobalKey();
//
//  ShowcaseBloc() {
//    
//  }
//
//
//  // TODO: showcase logic, move out of home.dart
//  void startShowcase(PrefsLoadedState prefState, BuildContext context) {
//    if (prefState.prefs.getBool('firstTimeLoad') == true) {
//      ShowCaseWidget.of(context)!.startShowCase([
//        showcaseMap,
//        showcaseSettings,
//        showcaseSearch,
//        showcaseProfile,
//        showcaseViewChange,
//        showcaseLocation,
//        showcaseSlidingPanel
//      ]);
//      prefState.prefs.setBool('firstTimeLoad', false);
//    }
//  }
//
//  //  TODO: showcase logic, move out of home.dart
//  void startTimelineShowcase(PrefsLoadedState prefState, BuildContext context) {
//    if (prefState.prefs.getBool('firstSlideUp') == true) {
//      ShowCaseWidget.of(context)!.startShowCase(
//          [showcaseTransportTab, showcaseBusTab, showcaseTimeline]);
//      prefState.prefs.setBool('firstSlideUp', false);
//    }
//  }
//
//}
//
//
//