// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// custom widget imports
import 'package:smartrider/widgets/map_ui.dart';
import 'package:smartrider/widgets/search_bar.dart';
import 'package:smartrider/pages/schedule.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';
  @override
  Widget build(BuildContext context) {
    return _HomePage();
  }
}

class _HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<_HomePage> {
  // We create a key so we can call schedule functions from this class (needed to scroll to current time)
  static final GlobalKey<ShuttleScheduleState> scheduleState = GlobalKey<ShuttleScheduleState>();
  PanelController _panelController;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  bool _isShuttle; // used to determine what text to display

  @override
  void initState(){
    super.initState();
    _panelController = new PanelController();
    _isShuttle = true;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .95;
    return Material(
      child: SlidingUpPanel(
        // sliding panel (body is the background, panelBuilder is the actual panel)
        controller: _panelController,
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: true,
        renderPanelSheet: false,
        backdropEnabled: true,
        parallaxOffset: .5,
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
              child: Icon(Icons.arrow_upward)
            )
          ],
        ),
        // stack the search bar widget over the map ui
        body: Stack(
          children: <Widget>[
            ShuttleMap(),
            SearchBar(),
          ]
        ),
        panel: NotificationListener<OverscrollNotification>(
          child: 
          ShuttleSchedule(
            key: scheduleState,
            panelController: _panelController,
            scheduleChanged: () {
              _isShuttle = !_isShuttle;
              setState(() {});
            },
          ),
          onNotification: (t) {
            if (t.overscroll < -10) {
              _panelController.animatePanelToPosition(0);
              return true;
            }
            return false;
          },
        ),
        // when the panel is closed, we can update the position of our list
        //  to the current time (sneaky like so they don't see our slow animations)
        onPanelClosed: () {
          // scheduleState.currentState.scrollAllTabs();
        },
       ),
    );
  }
}
