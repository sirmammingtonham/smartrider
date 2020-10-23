// ui dependencies
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';

class ShuttleList2 extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  ShuttleList2({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  ShuttleList2State createState() => ShuttleList2State();
}

class ShuttleList2State extends State<ShuttleList2>
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
    return Material(
      child: Column(children: <Widget>[
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
              shuttleList2(0, this.widget.containsFilter, this.widget.jumpMap),
              shuttleList2(1, this.widget.containsFilter, this.widget.jumpMap),
              shuttleList2(2, this.widget.containsFilter, this.widget.jumpMap),
              shuttleList2(3, this.widget.containsFilter, this.widget.jumpMap),
            ],
          ),
        )
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
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

Widget shuttleList2(int idx, Function _containsFilter, Function _jumpMap) {
  return ScrollablePositionedList.builder(
    itemCount: shuttleTimeLists[idx].length,
    initialScrollIndex: _getTimeIndex(shuttleTimeLists[idx]),
    itemBuilder: (context, index) {
      var curStopList = shuttleStopLists[idx];
      var curTimeList = shuttleTimeLists[idx];
      if (!_containsFilter(curStopList, curTimeList, index) ||
          curTimeList[index] == "- - - -") {
        return null;
      }
      return Card(
        child: ListTile(
          leading: Icon(Icons.airport_shuttle),
          title: Text(curStopList[index % curStopList.length][0]),
          subtitle: Text(curTimeList[index]),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);

            // _jumpMap(double.parse(curStopList[index % curStopList.length][1]),
            //     double.parse(curStopList[index % curStopList.length][2]));
          },
        ),
      );
    },
  );
}
