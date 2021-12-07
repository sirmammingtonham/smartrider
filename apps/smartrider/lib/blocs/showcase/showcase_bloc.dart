
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
    required this.prefsBloc,
  }) : super(const ShowcaseLoadingState());

  /// Preferences Bloc

  final PrefsBloc prefsBloc;


  // TODO: showcase logic, move out of home.dart
  void startShowcase(BuildContext context) {
    if (prefsBloc.getBool('firstTimeLoad') == true) {
      ShowCaseWidget.of(context)!.startShowCase([
        showcaseMap,
        showcaseSettings,
        showcaseSearch,
        showcaseProfile,
        showcaseViewChange,
        showcaseLocation,
        showcaseSlidingPanel
      ]);
      prefsBloc.setBool('firstTimeLoad');
    }
  }

  //  TODO: showcase logic, move out of home.dart
  void startTimelineShowcase(BuildContext context) {
    if (prefsBloc.getBool('firstSlideUp') == true) {
      ShowCaseWidget.of(context)!.startShowCase(
          [showcaseTransportTab, showcaseBusTab, showcaseTimeline],);
      prefsBloc.setBool('firstSlideUp');
    }
  }

}
