// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// custom widget imports
// import '../widgets/map_ui.dart';
import '../widgets/search_bar.dart';
import 'schedule.dart';

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
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          // sliding panel (body is the background, panelBuilder is the actual panel)
          SlidingUpPanel(
            collapsed: AppBar(
                centerTitle: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
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
            body: SearchBar(),
            panelBuilder: (ScrollController sc) => ShuttleSchedule(scroll_c: sc), 
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
            // onPanelSlide: (double pos) => setState((){
            // }),
          ),

          // blur filter
          Positioned(
            top: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).padding.top,
                  color: Colors.transparent,
                )
              )
            )
          ),
        ],
      ),
    );
  }
}
