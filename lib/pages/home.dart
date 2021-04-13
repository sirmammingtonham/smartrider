// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:flutter/scheduler.dart';
import 'package:showcaseview/showcaseview.dart';
// bloc imports
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/util/multi_bloc_builder.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// custom widget imports
import 'package:smartrider/widgets/map_widget.dart';
import 'package:smartrider/widgets/search_bar.dart';
import 'package:smartrider/widgets/saferide_status_widget.dart';
import 'package:smartrider/pages/sliding_panel_page.dart';
import 'package:smartrider/main.dart';

GlobalKey showcaseSettings = GlobalKey();
GlobalKey showcaseShuttleToggle = GlobalKey();

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
  static const String route = '/';

  /// Builds our Home Page by calling the constructor for
  /// the class that builds the homepage.
  @override
  Widget build(BuildContext context) {
    return _HomePage();
  }
}

/// Class that represents the HomePage.
class _HomePage extends StatefulWidget {
  _HomePage();

  /// Grabs the current state of the HomePage
  /// given from dynamic data.
  @override
  _HomePageState createState() => _HomePageState();
}

/// Builds the current instance of the home page.
class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  PanelController _panelController; // Lets the user control the stop tabs
  TabController _tabController;
  // The height of the tab when the user is viewing the shuttle and bus stops
  double _panelHeightOpen;

  double _panelHeightClosed = 95.0; // Height of the closed tab

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
    _tabController = TabController(vsync: this, length: 2);
    BlocProvider.of<MapBloc>(context).add(MapInitEvent());
    BlocProvider.of<ScheduleBloc>(context).add(ScheduleInitEvent(
        panelController: _panelController, tabController: _tabController));
  }

  void startShowcase(PrefsLoadedState prefState, context) {
    if (prefState.prefs.getBool('firstTimeLoad') == true) {
      ShowCaseWidget.of(context).startShowCase([
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

  void startTimelineShowcase(PrefsLoadedState prefState, context) {
    if (prefState.prefs.getBool('firstSlideUp') == true) {
      ShowCaseWidget.of(context).startShowCase(
          [showcaseTransportTab, showcaseBusTab, showcaseTimeline]);
      prefState.prefs.setBool('firstSlideUp', false);
    }
  }

  Widget _slidingPanel(SaferideState saferideState, MapState mapState,
          PrefsState prefsState, BuildContext context) =>
      SlidingUpPanel(
        controller: _panelController,
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        onPanelOpened: () {
          startTimelineShowcase(prefsState, context);
        },
        parallaxEnabled: true,
        renderPanelSheet: false,
        backdropEnabled: true,
        parallaxOffset: .1,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        collapsed: Showcase(
            key: showcaseSlidingPanel,
            description: 'Swipe up to view shuttle/bus schedules',
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18.0),
              ),
            ),
            child: AppBar(
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18.0),
                ),
              ),
              leading: Icon(Icons.arrow_upward),
              title: Text(mapState is MapLoadedState && !mapState.isBus
                  ? 'Shuttle Schedules'
                  : 'Bus Schedules'),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.arrow_upward))
              ],
            )),
        // stack the search bar widget over the map ui
        body: Stack(children: <Widget>[
          SmartriderMap(),
          SearchBar(),
          saferideState is SaferideSelectionState ||
                  saferideState is SaferideConfirmedState
              ? SaferideStatusWidget()
              : Container()
        ]),
        panel: PanelPage(
          panelController: _panelController,
        ),
      );

  /// Builds the map and the schedule dropdown based on dynamic data.
  @override
  Widget build(BuildContext context) {
    /// Height of the stop schedules when open
    _panelHeightOpen = MediaQuery.of(context).size.height * .95;
    return MultiBlocBuilder(
        blocs: [
          BlocProvider.of<SaferideBloc>(context),
          BlocProvider.of<MapBloc>(context),
          BlocProvider.of<PrefsBloc>(context),
        ],
        builder: (context, states) {
          final saferideState = states.get<SaferideState>();
          final mapState = states.get<MapState>();
          final prefState = states.get<PrefsState>();
          if (saferideState is SaferideNoState) {
            _panelController.show();
          } else if (saferideState is SaferideSelectionState) {
            _panelController.hide();
          }
          if (prefState is PrefsLoadingState) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (prefState is PrefsLoadedState) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => startShowcase(prefState, context));
            return _slidingPanel(saferideState, mapState, prefState, context);
          } else if (prefState is PrefsSavingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text("oh poops"));
          }
        });
  }
}
