// ui dependencies
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dash/flutter_dash.dart';
//import 'package:flutter/rendering.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/custom_expansion_tile.dart';
import 'package:smartrider/pages/shuttle_dropdown.dart';
import 'package:smartrider/widgets/filter_dialog.dart';
import 'package:smartrider/widgets/shuttle_list.dart';
import 'package:smartrider/widgets/bus_list.dart';
import 'package:smartrider/widgets/map_ui.dart';

class ShuttleList extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  ShuttleList({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  ShuttleListState createState() => ShuttleListState();
}

class ShuttleListState extends State<ShuttleList>
    with SingleTickerProviderStateMixin {
  final List<Widget> shuttleTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
    Tab(text: 'WEEKEND'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: shuttleTabs.length);
    _tabController.addListener(() {
      print(_tabController.indexIsChanging);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    return Column(children: <Widget>[
      TabBar(
        isScrollable: true,
        tabs: shuttleTabs,
        // unselectedLabelColor: Colors.white.withOpacity(0.3),
        labelColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : null,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : null,
        controller: _tabController,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            shuttleList(0, this.widget.containsFilter, this.widget.jumpMap),
            shuttleList(1, this.widget.containsFilter, this.widget.jumpMap),
            shuttleList(2, this.widget.containsFilter, this.widget.jumpMap),
            shuttleList(3, this.widget.containsFilter, this.widget.jumpMap),
          ],
        ),
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;
  bool isExpanded = true;

  Widget shuttleList(int idx, Function _containsFilter, Function _jumpMap) {
    return ScrollablePositionedList.builder(
      itemCount: shuttleStopLists[idx].length,
      itemBuilder: (context, index) {
        var curStopList = shuttleStopLists[idx];
        return CustomExpansionTile(
          //   tilePadding: EdgeInsets.zero,
          //   subtitle: Text('asdasd'),
          //   leading: Container(
          //     margin: const EdgeInsets.only(left: 32.0),
          //     constraints: BoxConstraints.expand(width: 8),
          //     decoration: BoxDecoration(
          //       border: Border(left: BorderSide(color: Colors.red, width: 4)),
          //     ),
          //   ),
          //   title: Text('foo'),
          //   children: [
          //     ListTile(
          //       contentPadding: EdgeInsets.zero,
          //       leading: Container(
          //         margin: const EdgeInsets.only(left: 32.0),
          //         constraints: BoxConstraints.expand(width: 8),
          //         decoration: BoxDecoration(
          //           border: Border(left: BorderSide(color: Colors.red, width: 4)),
          //         ),
          //       ),
          //     ),
          //   ],
          // );

          onExpansionChanged: (value) => isExpanded,
          title: Text(curStopList[index % curStopList.length][0]),
          subtitle: Text('Next Arrival: ' +
              _getTimeIndex(shuttleTimeLists[idx]).toString()),
          leading: index == 0
              ? Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: .5, color: Colors.green)),
                    ),
                    Dash(
                        direction: Axis.vertical,
                        length: 20,
                        dashLength: 5,
                        dashColor: Colors.grey),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Dash(
                        direction: Axis.vertical,
                        length: 20,
                        dashLength: 5,
                        dashColor: Colors.grey),
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: .5, color: Colors.green)),
                    ),
                    Dash(
                        direction: Axis.vertical,
                        length: 20,
                        dashLength: 5,
                        dashColor: Colors.grey),
                  ],
                ),
          trailing:
              isExpanded ? Text('Show Arrivals +') : Text('Hide Arrivals -'),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                margin: const EdgeInsets.only(left: 20.0),
                constraints: BoxConstraints.expand(width: 8),
                child: Dash(
                    direction: Axis.vertical,
                    length: 55,
                    dashLength: 5,
                    dashColor: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }
}

_getTimeIndex(List<String> curTimeList) {
  // TODO: update so it works with filter
  // List curTimeList = _isShuttle ? shuttleTimeLists[_tabController.index] :
  //             busTimeLists[_tabController.index-1];
  var now = DateTime.now();
  var f = DateFormat('H.m');
  double min = double.maxFinite;
  double curTime = double.parse(f.format(now));
  double compTime;
  String closest;
  curTimeList.forEach((time) {
    var t = time.replaceAll(':', '.');
    compTime = double.tryParse(t.substring(0, t.length - 2));
    if (compTime == null) return;
    if (t.endsWith('pm') && !t.startsWith("12")) {
      compTime += 12.0;
    }
    if ((curTime - compTime).abs() < min) {
      min = (curTime - compTime).abs();
      closest = time;
    }
  });

  return curTimeList.indexWhere((element) => element == closest);
}

// Column( children:
// [ for (var i=0; i< 3; i++)
// ExpansionTile(
//   tilePadding: EdgeInsets.zero,
//   leading: Container(
//     margin: const EdgeInsets.only(left: 32.0),
//     constraints: BoxConstraints.expand(width: 8),
//     decoration: BoxDecoration( border: Border(left: BorderSide(color: Colors.red, width: 4)), ),),
//     title: Text('foo'),
//     children: [
//       ListTile(
//         contentPadding: EdgeInsets.zero,
//         leading: Container( margin: const EdgeInsets.only(left: 32.0),
//         constraints: BoxConstraints.expand(width: 8),
//         decoration: BoxDecoration(
//           border: Border(left: BorderSide(color: Colors.red, width: 4)), ),),),],),],)
