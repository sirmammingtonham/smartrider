// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';

import 'package:smartrider/ui/widgets/sliding_up_panel.dart';

// import 'package:shared/util/consts/messages.dart';
import 'package:showcaseview/showcaseview.dart';

// import 'package:sizer/sizer.dart';
// bloc imports
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

// custom widget imports
import 'package:smartrider/ui/widgets/map_widget.dart';
import 'package:smartrider/ui/widgets/search_bar.dart';
import 'package:smartrider/ui/widgets/panel_header.dart';
import 'package:smartrider/ui/widgets/panel_body.dart';
import 'package:smartrider/ui/widgets/saferide_status_widgets.dart'
    as saferide_widgets;

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
    BlocProvider.of<ScheduleBloc>(context).add(
      ScheduleInitEvent(
          panelController: _panelController, tabController: _tabController,),
    );
    BlocProvider.of<MapBloc>(context).add(const MapInitEvent());
    BlocProvider.of<SaferideBloc>(context).add(const SaferideNoEvent());
  }

  // TODO: showcase logic, move out of home.dart
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

  //  TODO: showcase logic, move out of home.dart
  void startTimelineShowcase(PrefsLoadedState prefState, BuildContext context) {
    if (prefState.prefs.getBool('firstSlideUp') == true) {
      ShowCaseWidget.of(context)!.startShowCase(
          [showcaseTransportTab, showcaseBusTab, showcaseTimeline]);
      prefState.prefs.setBool('firstSlideUp', false);
    }
  }

  Widget _slidingPanel(SaferideState saferideState, BuildContext context) {
    late final double minHeight;
    switch (saferideState.runtimeType) {
      case SaferideSelectingState:
        minHeight = saferide_widgets.saferideSelectingHeight;
        break;
      case SaferideWaitingState:
        minHeight = saferide_widgets.saferideWaitingHeight;
        break;
      case SaferidePickingUpState:
        minHeight = saferide_widgets.saferidePickingUpHeight;
        break;
      case SaferideCancelledState:
        minHeight = saferide_widgets.saferideCancelledHeight;
        break;
      case SaferideErrorState:
        minHeight = saferide_widgets.saferideErrorHeight;
        break;
      case SaferideNoState:
      case SaferideDroppingOffState:
      default:
        minHeight = saferide_widgets.saferideDefaultHeight;
        break;
    }

    return SlidingUpPanel(
      controller: _panelController,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      minHeight: minHeight,
      // onPanelOpened: () {
      //   startTimelineShowcase(prefsState as PrefsLoadedState, context);
      // },
      parallaxEnabled: true,
      renderPanelSheet: false,
      backdropEnabled: true,
      parallaxOffset: .1,
      // stack the search bar widget over the map ui
      body: Stack(children: const <Widget>[
        SmartriderMap(),
        SearchBar(),
      ]),
      header: PanelHeader(panelController: _panelController),
      panelBuilder: (sc) => PanelBody(
        panelScrollController: sc,
        headerHeight: minHeight,
      ),
    );
  }

  /// Builds the map and the schedule dropdown based on dynamic data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<SaferideBloc, SaferideState>(
        bloc: BlocProvider.of<SaferideBloc>(context),
        builder: (context, state) {
          return _slidingPanel(state, context);
        },
      ),
    );
  }
}
