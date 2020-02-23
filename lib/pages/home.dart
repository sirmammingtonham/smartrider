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

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState(){
    super.initState();

    _fabHeight = _initFabHeight;
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
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: SearchBar(),
            // body: ShuttleMap(),
            panelBuilder: (sc) => ShuttleSchedule(), //_panel(sc), // replace with custom shuttle schedule page later
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState((){
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
            }),
          ),

          // the fab icon
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: (){},
              backgroundColor: Colors.white,
            ),
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

  Widget _panel(ScrollController sc){
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          // gray pull bar (replace with the thing from mockup)
          SizedBox(height: 12.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),
              ),
            ],
          ),
          // Title (replace with "Schedules" in the right font)
          SizedBox(height: 15.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Shuttle Schedule Page Test",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          )
        ]
      )
    );
  }
}
