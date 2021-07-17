// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// import 'package:shared/util/messages.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:sizer/sizer.dart';
// bloc imports
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:shared/util/multi_bloc_builder.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// custom widget imports
import 'package:smartrider/widgets/map_widget.dart';
import 'package:smartrider/widgets/search_bar.dart';
import 'package:smartrider/widgets/saferide_status_widget.dart';
import 'package:smartrider/pages/sliding_panel_page.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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

/// Default page that is displayed once the user logs in.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/';

  /// Builds our Home Page by calling the constructor for
  /// the class that builds the homepage.
  @override
  Widget build(BuildContext context) {
    return const _HomePage();
  }
}

/// Class that represents the HomePage.
class _HomePage extends StatefulWidget {
  const _HomePage();

  /// Grabs the current state of the HomePage
  /// given from dynamic data.
  @override
  _HomePageState createState() => _HomePageState();
}

/// Builds the current instance of the home page.
class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  late final PanelController _panelController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
    _tabController = TabController(vsync: this, length: 2);
    BlocProvider.of<MapBloc>(context).add(const MapInitEvent());
    BlocProvider.of<ScheduleBloc>(context).add(ScheduleInitEvent(
        panelController: _panelController, tabController: _tabController));
  }

  void startShowcase(PrefsLoadedState prefState, BuildContext context) {
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

  void startTimelineShowcase(PrefsLoadedState prefState, BuildContext context) {
    if (prefState.prefs.getBool('firstSlideUp') == true) {
      ShowCaseWidget.of(context)!.startShowCase(
          [showcaseTransportTab, showcaseBusTab, showcaseTimeline]);
      prefState.prefs.setBool('firstSlideUp', false);
    }
  }

  Widget _slidingPanel(SaferideState saferideState, PrefsState prefsState,
          BuildContext context) =>
      SlidingUpPanel(
        controller: _panelController,
        maxHeight: 90.h,
        minHeight: 15.h,
        onPanelOpened: () {
          startTimelineShowcase(prefsState as PrefsLoadedState, context);
        },
        parallaxEnabled: true,
        renderPanelSheet: false,
        backdropEnabled: true,
        parallaxOffset: .1,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        // stack the search bar widget over the map ui
        body: Stack(children: const <Widget>[
          SmartriderMap(),
          SearchBar(),
          SaferideStatusWidget()
        ]),
        panelBuilder: (sc) => PanelPage(panelScrollController: sc),
      );

  /// Builds the map and the schedule dropdown based on dynamic data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: MultiBlocBuilder(
            blocs: [
              BlocProvider.of<SaferideBloc>(context),
              BlocProvider.of<PrefsBloc>(context),
            ],
            builder: (context, states) {
              final saferideState = states.get<SaferideState>();
              final prefState = states.get<PrefsState>();

              switch (saferideState.runtimeType) {
                case SaferideNoState:
                  {
                    if (_panelController.isAttached) _panelController.show();
                  }
                  break;
                case SaferideSelectingState:
                  {
                    _panelController.hide();
                  }
                  break;
              }

              switch (prefState.runtimeType) {
                case PrefsLoadingState:
                  return const Center(child: CircularProgressIndicator());

                case PrefsLoadedState:
                  {
                    WidgetsBinding.instance!.addPostFrameCallback((_) =>
                        startShowcase(prefState as PrefsLoadedState, context));
                    KeyboardVisibilityController()
                        .onChange
                        .listen((bool visible) {
                      if (visible && saferideState is SaferideNoState) {
                        _panelController.hide();
                      } else {
                        _panelController.show();
                      }
                    });
                    return _slidingPanel(saferideState, prefState, context);
                  }
                case PrefsSavingState:
                  return const Center(child: CircularProgressIndicator());
                default:
                  return const Center(child: Text('oh poops'));
              }
            }));
  }
}
