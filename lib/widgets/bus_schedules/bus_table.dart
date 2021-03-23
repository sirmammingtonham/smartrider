// ui dependencies
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';
import 'package:smartrider/data/models/bus/bus_stop.dart';
// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/bus_schedules/bus_unavailable.dart';
import 'package:smartrider/widgets/custom_sticky_table.dart';
//import 'package:sticky_headers/sticky_headers.dart';
//import 'package:table_sticky_headers/table_sticky_headers.dart';

class BusTable extends StatefulWidget {
  final Map<String, BusTimetable> timetableMap;
  BusTable({Key key, @required this.timetableMap}) : super(key: key);

  @override
  BusTableState createState() => BusTableState();
}

class BusTableState extends State<BusTable>
    with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    Tab(text: 'Route 87'),
    Tab(text: 'Route 286'),
    Tab(text: 'Route 289'),
    Tab(text: 'Express Shuttle'),
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
        indicatorColor: Theme.of(context).buttonColor,

        //_getTabColor(_tabController),
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
            busList('87-185'),
            busList('286-185'),
            busList('289-185'),
            busList('288-185'),
          ],
        ),
      )
    ]);
  }

  Widget busList(String routeId) {
    if (!this.widget.timetableMap.containsKey(routeId)) {
      return BusUnavailable();
    }

    final BusTimetable table = this.widget.timetableMap[routeId];

    return Scaffold(
        body: CustomStickyHeader(
      columnsLength: table.numColumns,
      rowsLength: table.numRows,

      columnsTitleBuilder: (i) => Container(
          alignment: Alignment.center,
          width: 100,
          height: 50,
          child: SizedBox(
            child: Text(table.stops[i].stopName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          )),
      contentCellBuilder: (i, j) => Text(table.getTime(i, j)),
      cellDimensions: CellDimensions.fixed(
          contentCellWidth: 100,
          contentCellHeight: 50,
          stickyLegendWidth: 100,
          stickyLegendHeight: 50),
      // SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child:
      //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //       SizedBox(
      //         height: 5,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: List.generate(
      //           stops.length,
      //           (index) => Container(
      //               alignment: Alignment.center,
      //               width: 102.7,
      //               height: 50,
      //               child: SizedBox(
      //   child: Text(stops[index % stops.length].stopName,
      //       textAlign: TextAlign.center,
      //       style: TextStyle(fontWeight: FontWeight.bold)),
      // )),
      //         ),
      //       ),
      //       Flexible(
      //         child: SingleChildScrollView(
      //             scrollDirection: Axis.vertical,
      //             child: DataTable(
      //               columnSpacing: 50,
      //               columns: List<DataColumn>.generate(
      //                   stops.length,
      //                   (colIdx) => DataColumn(
      //                           label: Flexible(
      //                         child: Text(times[colIdx]),
      //                       ))),
      //               rows: List<DataRow>.generate(
      //                 (times.length / stops.length).truncate(),
      //                 (rowIdx) => DataRow(
      //                     cells: List<DataCell>.generate(
      //                         stops.length,
      //                         (colIdx) => DataCell(Text(
      //                             times[rowIdx + 1 * stops.length + colIdx])))),
      //               ),
      //             )),
      //       ),
      //     ]))
    ));
  }
}
