// ui dependencies
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/custom_sticky_table.dart';
import 'package:sticky_headers/sticky_headers.dart';

class BusTable extends StatefulWidget {
  final Function containsFilter;
  final Function jumpMap;
  BusTable({Key key, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  BusTableState createState() => BusTableState();
}

class BusTableState extends State<BusTable>
    with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    Tab(text: 'Route 87'),
    Tab(text: 'Route 286'),
    Tab(text: 'Route 289'),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: busTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TabBar(
        tabs: busTabs,
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
            busList(0, this.widget.containsFilter, this.widget.jumpMap),
            busList(1, this.widget.containsFilter, this.widget.jumpMap),
            busList(2, this.widget.containsFilter, this.widget.jumpMap),
          ],
        ),
      )
    ]);
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
    if (t.endsWith('pm')) {
      compTime += 12.0;
    }
    if ((curTime - compTime).abs() < min) {
      min = (curTime - compTime).abs();
      closest = time;
    }
  });
  return curTimeList.indexWhere((element) => element == closest);
}

Widget busList(int idx, Function _containsFilter, Function _jumpMap) {
  var curStopList = busStopLists[idx];
  var curTimeList = busTimeLists[idx];
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        busStopLists[idx].length,
                        (index) => Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            child: SizedBox(
                              child: Text(
                                  curStopList[index % curStopList.length][0]),
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
                                    busStopLists[idx].length,
                                    (index) => DataColumn(
                                          label:
                                              Flexible(child: Text("6:30pm")),
                                        )),
                                rows: List<DataRow>.generate(
                                    (busTimeLists[idx].length /
                                                busStopLists[idx].length +
                                            1)
                                        .truncate(),
                                    (index) => DataRow(
                                        cells: List<DataCell>.generate(
                                            busStopLists[idx].length,
                                            (datIdx) =>
                                                DataCell(Text('6:30pm')))))))),
                  ])));

  //Text(curTimeList[(index * busTimeLists[idx].length) + datIdx]))
  // return ScrollablePositionedList.builder(
  //   itemCount: busTimeLists[idx].length,
  //   initialScrollIndex: _getTimeIndex(busTimeLists[idx]),
  //   itemBuilder: (context, index) {
  //     var curStopList = busStopLists[idx];
  //     var curTimeList = busTimeLists[idx];
  //     // if (!_containsFilter(curStopList, curTimeList, index) ||
  //     //     curTimeList[index] == "- - - -") {
  //     //   return null;
  //     // }
  //     return Card(
  //       child: ListTile(
  //         leading: Icon(Icons.directions_bus),
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
