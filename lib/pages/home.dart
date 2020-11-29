// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

// bloc imports
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/data/repository/shuttle_repository.dart';
import 'package:smartrider/data/repository/bus_repository.dart';

// custom widget imports
import 'package:smartrider/widgets/map_ui.dart';
import 'package:smartrider/widgets/search_bar.dart';
import 'package:smartrider/pages/panel_page.dart';

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
class _HomePageState extends State<_HomePage> {
  PanelController _panelController; // Lets the user control the stop tabs

  // The height of the tab when the user is viewing the shuttle and bus stops
  double _panelHeightOpen;

  double _panelHeightClosed = 95.0; // Height of the closed tab
  bool _isShuttle; // used to determine what text to display

  @override
  void initState() {
    super.initState();
    _panelController = new PanelController();
    _isShuttle = false;
  }

  void _changeCallback() {
    setState(() {
      _isShuttle = !_isShuttle;
    });
  }

  /// Builds the map and the schedule dropdown based on dynamic data.
  @override
  Widget build(BuildContext context) {
    /// Height of the stop schedules when open
    _panelHeightOpen = MediaQuery.of(context).size.height * .95;
    return Material(
      child: MultiBlocProvider(
          providers: [
            BlocProvider<MapBloc>(
                create: (context) => MapBloc(
                    prefsBloc: BlocProvider.of<PrefsBloc>(context),
                    busRepo: BusRepository(),
                    shuttleRepo: ShuttleRepository())),
            BlocProvider<ScheduleBloc>(
                create: (context) => ScheduleBloc(busRepo: BusRepository()))
          ],
          child: SlidingUpPanel(
              // sliding panel (body is the background, panelBuilder is the actual panel)
              controller: _panelController,
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              renderPanelSheet: false,
              backdropEnabled: true,
              parallaxOffset: .1,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
              collapsed: AppBar(
                centerTitle: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.0),
                  ),
                ),
                leading: Icon(Icons.arrow_upward),
                title: Text(_isShuttle ? 'Shuttle Schedules' : 'Bus Schedules'),
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(Icons.arrow_upward))
                ],
              ),
              // stack the search bar widget over the map ui
              body: Stack(children: <Widget>[
                ShuttleMap(
                  key: mapState,
                ),
                SearchBar(),
              ]),
              panel: PanelPage(
                scheduleChanged: _changeCallback,
                panelController: _panelController,
              ))),
    );
  }
}
