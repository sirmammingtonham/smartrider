
// if we continue with this, we are using awesome notifications
//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

part 'showcase_event.dart';
part 'showcase_state.dart';

class ShowcaseBloc extends Bloc<ShowcaseEvent, ShowcaseState> {
  // TODO: Replace keys and make public
  GlobalKey showcaseSettings = GlobalKey();
  GlobalKey showcaseShuttleToggle = GlobalKey();
  GlobalKey showcaseLegend = GlobalKey();

  GlobalKey showcaseProfile = GlobalKey();
  GlobalKey showcaseSlidingPanel = GlobalKey();
  GlobalKey showcaseViewChange = GlobalKey();
  GlobalKey showcaseLocation = GlobalKey();
  GlobalKey showcaseSearch = GlobalKey();
  GlobalKey showcaseBusTab = GlobalKey();
  GlobalKey showcaseTransportTab = GlobalKey();
  GlobalKey showcaseMap = GlobalKey();
  GlobalKey showcaseTimeline = GlobalKey();
  
  ShowcaseBloc({    
    required this.prefState,
  }) : super(const ShowcaseLoadingState());

  /// Preferences Bloc

  final PrefsLoadedState prefState;


  // TODO: showcase logic, move out of home.dart
  void startShowcase(BuildContext context) {
    if (prefState.prefs.getBool('firstTimeLoad') == true) {
      ShowCaseWidget.of(context)!.startShowCase([
        showcaseMap,
        showcaseSettings,
        showcaseSearch,
        showcaseProfile,
        showcaseViewChange,
        showcaseLocation,
        showcaseSlidingPanel
      ]);
      prefState.prefs.setBool('firstTimeLoad', false);
    }
  }

  //  TODO: showcase logic, move out of home.dart
  void startTimelineShowcase(BuildContext context) {
    if (prefState.prefs.getBool('firstSlideUp') == true) {
      ShowCaseWidget.of(context)!.startShowCase(
          [showcaseTransportTab, showcaseBusTab, showcaseTimeline],);
      prefState.prefs.setBool('firstSlideUp', false);
    }
  }

}
