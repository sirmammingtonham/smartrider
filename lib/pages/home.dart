// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
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
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .95;

    return Material(
      child: SlidingUpPanel(
        // sliding panel (body is the background, panelBuilder is the actual panel)
        backdropEnabled: true,
        collapsed: AppBar(
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18.0),
              ),
            ),
            leading: Icon(Icons.arrow_upward),
            title: Text('Shuttle Schedules'),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(Icons.arrow_upward)
              )
            ],
          ),
        
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        // stack the search bar widget over the map ui
        body: Stack(
          children: <Widget>[
            ShuttleMap(),
            SearchBar(),
          ]
        ),
        panelBuilder: (ScrollController sc) => ShuttleSchedule(scroll_c: sc), 
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        // onPanelSlide: (double pos) => setState((){
        // }),
      ),
    );
  }
}
