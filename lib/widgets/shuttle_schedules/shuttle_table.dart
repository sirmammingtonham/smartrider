// ui dependencies
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';

class ShuttleTable extends StatefulWidget {
  final Function? containsFilter;
  final Function? jumpMap;
  ShuttleTable({Key? key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  ShuttleTableState createState() => ShuttleTableState();
}

class ShuttleTableState extends State<ShuttleTable>
    with SingleTickerProviderStateMixin {
  final List<Widget> shuttleTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
    Tab(text: 'WEEKEND'),
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: shuttleTabs.length);
    _tabController!.addListener(() {
      _handleTabSelection();
    });
  }

  _handleTabSelection() {
    setState(() {});
  }

  _getTabColor(TabController tc) {
    if (tc.index == 0) {
      return Colors.green;
    } else if (tc.index == 1) {
      return Colors.red;
    } else if (tc.index == 2) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(children: <Widget>[
        TabBar(
          indicatorColor: _getTabColor(_tabController!),
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
  String? closest;
  curTimeList.forEach((time) {
    var t = time.replaceAll(':', '.');
    double? compTime = double.tryParse(t.substring(0, t.length - 2));
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

Widget shuttleList(int idx, Function? _containsFilter, Function? _jumpMap) {
  var curStopList = shuttleStopLists[idx];
  var curTimeList = shuttleTimeLists[idx];
  return
      // CustomStickyHeadersTable(
      //   columnsLength: busStopLists[idx].length,
      //   rowsLength:
      //       (busTimeLists[idx].length / busStopLists[idx].length + 1).truncate(),
      //   columnsTitleBuilder: (i) => Text(curStopList[i % curStopList.length][0]),
      //   //rowsTitleBuilder: (i) => Text("Times:"),
      //   contentCellBuilder: (i, j) => Text("6:30pm"),
      //   legendCell: Text('Bus Stops'),
      // );

      Scaffold(
          body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        shuttleStopLists[idx].length,
                        (index) => Container(
                            alignment: Alignment.center,
                            width: 98,
                            height: 30,
                            child: SizedBox(
                              child: Text(
                                curStopList[index % curStopList.length][0],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                    // DataTable(
                    //     columnSpacing: 50,
                    //     columns: List<DataColumn>.generate(
                    //         busStopLists[idx].length,
                    //         (index) => DataColumn(
                    //               label: Flexible(
                    //                   child: Text(curStopList[
                    //                       index % curStopList.length][0])),
                    //             )),
                    //     rows: <DataRow>[
                    //       DataRow(
                    //           cells: List<DataCell>.generate(
                    //               busStopLists[idx].length,
                    //               (datIdx) => DataCell(Text('6:30pm'))))
                    //     ]),
                    Flexible(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                                columnSpacing: 50,
                                columns: List<DataColumn>.generate(
                                    shuttleStopLists[idx].length,
                                    (index) => DataColumn(
                                          label:
                                              Flexible(child: Text("6:30pm")),
                                        )),
                                rows: List<DataRow>.generate(
                                    (shuttleTimeLists[idx].length /
                                                shuttleStopLists[idx].length +
                                            1)
                                        .truncate(),
                                    (index) => DataRow(
                                        cells: List<DataCell>.generate(
                                            shuttleStopLists[idx].length,
                                            (datIdx) =>
                                                DataCell(Text('6:30pm')))))))),
                  ])));

  // ScrollablePositionedList.builder(
  //   itemCount: shuttleTimeLists[idx].length,
  //   initialScrollIndex: _getTimeIndex(shuttleTimeLists[idx]),
  //   itemBuilder: (context, index) {
  //     var curStopList = shuttleStopLists[idx];
  //     var curTimeList = shuttleTimeLists[idx];
  //     // if (!_containsFilter(curStopList, curTimeList, index) ||
  //     //     curTimeList[index] == "- - - -") {
  //     //   return null;
  //     // }
  //     return Card(
  //       child: ListTile(
  //         leading: Icon(Icons.airport_shuttle),
  //         title: Text(curStopList[index % curStopList.length][0]),
  //         subtitle: Text(curTimeList[index]),
  //         trailing: Icon(Icons.arrow_forward),
  //         onTap: () {
  //           // _jumpMap(double.parse(curStopList[index % curStopList.length][1]),
  //           //     double.parse(curStopList[index % curStopList.length][2]));
  //         },
  //       ),
  //     );
  //   },
  // );
}
