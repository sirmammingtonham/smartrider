// ui dependencies
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';

class ShuttleList extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  ShuttleList({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  ShuttleListState createState() => ShuttleListState();
}
  
class ShuttleListState extends State<ShuttleList> with SingleTickerProviderStateMixin
{
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
    return Column(
      children: <Widget> [
        TabBar(
          isScrollable: true,
          tabs: shuttleTabs,
          // unselectedLabelColor: Colors.white.withOpacity(0.3),
          labelColor: Theme.of(context).brightness == Brightness.light ? Colors.black : null,
          unselectedLabelColor: Theme.of(context).brightness == Brightness.light ? Colors.black : null,
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
      ]
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
  curTimeList.forEach(
    (time) {
      var t = time.replaceAll(':', '.');
      compTime = double.tryParse(t.substring(0,t.length-2));
      if (compTime == null)
        return;
      if (t.endsWith('pm')) {
        compTime += 12.0;
      }
      if ((curTime - compTime).abs() < min) {
        min = (curTime - compTime).abs();
        closest = time;
      }
    }
  );

  return curTimeList.indexWhere((element) => element == closest);
}

Widget shuttleList(int idx, Function _containsFilter, Function _jumpMap) {
  return ScrollablePositionedList.builder(
    itemCount: shuttleTimeLists[idx].length,
    initialScrollIndex: _getTimeIndex(shuttleTimeLists[idx]),
    itemBuilder: (context, index) {
      var curStopList = shuttleStopLists[idx];
      var curTimeList = shuttleTimeLists[idx];
      if (!_containsFilter(curStopList, curTimeList, index) || curTimeList[index] == "- - - -") {
        return null;
      }
      return Card(
        child: ListTile(
          leading: Icon(Icons.airport_shuttle),
          title: Text(curStopList[index%curStopList.length][0]),
          subtitle: Text(curTimeList[index]),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            _jumpMap(double.parse(curStopList[index%curStopList.length][1]), double.parse(curStopList[index%curStopList.length][2]));
          },
        ),
      );
    },
  );
}