// ui dependencies
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/filter_dialog.dart';
import 'package:smartrider/widgets/shuttle_list.dart';
import 'package:smartrider/widgets/bus_list.dart';
import 'package:smartrider/widgets/map_ui.dart';

class ShuttleSchedule extends StatefulWidget {
  final GlobalKey<ShuttleMapState> mapState;
  final PanelController panelController;
  final VoidCallback scheduleChanged;
  ShuttleSchedule({Key key, this.mapState, this.panelController, this.scheduleChanged}) : super(key: key);
  @override
  ShuttleScheduleState createState() => ShuttleScheduleState();
}
  
class ShuttleScheduleState extends State<ShuttleSchedule> with TickerProviderStateMixin  {

  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.airport_shuttle)),
    Tab(icon: Icon(Icons.directions_bus)),
  ];

  TabController _tabController;
  TextEditingController _textController;
  List<ItemScrollController> _shuttleScrollControllers = List<ItemScrollController>();
  List<ItemScrollController> _busScrollControllers = List<ItemScrollController>();
  double initial, distance;
  String filter;
  bool _isShuttle; // true if we have to build the shuttle schedule, false if bus

  @override
  void initState() {
    super.initState();
    _isShuttle = true;
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _textController = new TextEditingController();
    _tabController.addListener(_handleTabSelection);
    _textController.addListener(_handleSearchQuery);

    [0,1,2,3].forEach((idx) {
      _shuttleScrollControllers.add(new ItemScrollController());
    });

    [0,1,2].forEach((idx) {
      _busScrollControllers.add(new ItemScrollController());
    });
    filter = null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _isShuttle = !_isShuttle;
      this.widget.scheduleChanged();
    }
  }

  _handleSearchQuery() {
    setState(() {
      filter = _textController.text;
    });
  }

  _displayFilterDialog() async {
    final builder = (BuildContext ctx) => FilterDialog(
      stops: _isShuttle ? shuttleStopLists[_tabController.index] : busStopLists[_tabController.index],
      controller: _textController,
    );
    await showDialog(context: context, builder: builder);
  }

  bool _containsFilter(var curStopList, var curTimeList, var index) {
    if (this.filter == null) {
      return true;
    }
    if (double.tryParse(this.filter) != null) {
      return curTimeList[index].contains(this.filter);
    }
    if (this.filter.contains('am') || this.filter.contains('pm') || this.filter.contains(':')) {
      return curTimeList[index].contains(this.filter);
    }
    if (this.filter.contains('@')) {
      var filterSplit = this.filter.split('@');
      return (curStopList[index%curStopList.length][0].toLowerCase().contains(filterSplit[0].toLowerCase()) &&
        curTimeList[index].contains(filterSplit[1]));
    }
    return curStopList[index%curStopList.length][0].toLowerCase().contains(this.filter.toLowerCase().trim());
  }

  _jumpMap(double lat, double long) {
    this.widget.panelController.animatePanelToPosition(0);
    this.widget.mapState.currentState.scrollToLocation(LatLng(lat, long));
  }

  // These functions are broken with the current layout
  // TODO: FIX THEM!

  // _scrollToCurrentTime(int idx, ItemScrollController _scrollController) {
  //   // TODO: update so it works with filter
  //   // List curTimeList = _isShuttle ? shuttleTimeLists[_tabController.index] :
  //   //             busTimeLists[_tabController.index-1];
  //   List curTimeList = shuttleTimeLists[idx];
  //   var now = DateTime.now();
  //   var f = DateFormat('H.m');
  //   double min = double.maxFinite;
  //   double curTime = double.parse(f.format(now));
  //   double compTime;
  //   String closest;
  //   curTimeList.forEach(
  //     (time) {
  //       var t = time.replaceAll(':', '.');
  //       compTime = double.tryParse(t.substring(0,t.length-2));
  //       if (compTime == null)
  //         return;
  //       if (t.endsWith('pm')) {
  //         compTime += 12.0;
  //       }
  //       if ((curTime - compTime).abs() < min) {
  //         min = (curTime - compTime).abs();
  //         closest = time;
  //       }
  //     }
  //   );
  //   var jTo = curTimeList.indexWhere((element) => element == closest);
  //   assert(_scrollController != null);
  //   if (_scrollController.isAttached)
  //     // _scrollController.jumpTo(index: 1);
  //     _scrollController.jumpTo(index: jTo);
  // }

  // scrollAllTabs() {
  //   print(_shuttleScrollControllers);
  //   print(_busScrollControllers);
  //   _shuttleScrollControllers.asMap().forEach((idx, c) {
  //     print(c.toString());
  //     _scrollToCurrentTime(idx, c);
  //   });
  //   _busScrollControllers.asMap().forEach((idx, c) { 
  //     print(c.toString());
  //     _scrollToCurrentTime(idx, c);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          title: Text(_isShuttle ? 'Shuttle Schedules' : 'Bus Schedules'),
          leading: IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () {
              this.widget.panelController.animatePanelToPosition(0);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                this.widget.panelController.animatePanelToPosition(0);
              },
            )
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            ShuttleList(
              scrollControllers: _shuttleScrollControllers,
              containsFilter: _containsFilter,
              jumpMap: _jumpMap,
            ),
            BusList(
              scrollControllers: _busScrollControllers,
              containsFilter: _containsFilter,
              jumpMap: _jumpMap,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "Filter",
          child: Icon(Icons.search),
          elevation: 5.0,
          onPressed: _displayFilterDialog,
        ),
      )
    );
  }
}