// ui dependencies
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared/models/bus/bus_timetable.dart';
// loading custom widgets and data
import 'package:smartrider/ui/widgets/bus_schedules/bus_unavailable.dart';
import 'package:smartrider/ui/widgets/custom_widgets/custom_sticky_table.dart';
import 'package:sizer/sizer.dart';
//import 'package:sticky_headers/sticky_headers.dart';
//import 'package:table_sticky_headers/table_sticky_headers.dart';

class BusTable extends StatefulWidget {
  const BusTable({Key? key, required this.timetableMap}) : super(key: key);
  final Map<String?, BusTimetable>? timetableMap;

  @override
  BusTableState createState() => BusTableState();
}

class BusTableState extends State<BusTable>
    with SingleTickerProviderStateMixin {
  final List<Widget> busTabs = [
    const Tab(text: 'Route 87'),
    const Tab(text: 'Route 286'),
    const Tab(text: 'Route 289'),
    const Tab(text: 'Express Shuttle'),
  ];
  TabController? _tabController;
  //TODO: overswipe on right switches to shuttle view
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: busTabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TabBar(
        // indicatorColor: Theme.of(context).buttonColor,

        //_getTabColor(_tabController),
        tabs: busTabs,
        // unselectedLabelColor: Colors.white.withOpacity(0.3),
        // labelColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.black
        //     : null,
        // unselectedLabelColor: Theme.of(context).brightness == Brightness.light
        //     ? Colors.black
        //     : null,
        controller: _tabController,
      ),
      SizedBox(
        height: 63.h,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            busList('87'),
            busList('286'),
            busList('289'),
            busList('288'),
          ],
        ),
      )
    ]);
  }

  Widget busList(String routeId) {
    if (!widget.timetableMap!.containsKey(routeId)) {
      return const BusUnavailable();
    }

    final table = widget.timetableMap![routeId]!;

    return Scaffold(
        body: CustomStickyHeader(
      columnsLength: table.numColumns,
      rowsLength: table.numRows,
      columnsTitleBuilder: (i) => Container(
          alignment: Alignment.center,
          width: 100,
          height: 50,
          child: SizedBox(
            child: Text(table.stops![i].stopName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          )),
      contentCellBuilder: (i, j) => Text(table.getTime(i, j)),
      cellDimensions: const CellDimensions.fixed(
          contentCellWidth: 100,
          contentCellHeight: 50,
          stickyLegendWidth: 100,
          stickyLegendHeight: 50),
    ));
  }
}
