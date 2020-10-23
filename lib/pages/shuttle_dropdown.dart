// ui dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/filter_dialog.dart';
import 'package:smartrider/widgets/shuttle_list.dart';
//import 'package:smartrider/widgets/bus_list.dart'; OBSOLETE
import 'package:smartrider/widgets/bus_list_new.dart';
import 'package:smartrider/widgets/map_ui.dart';

class ShuttleSchedule2 extends StatefulWidget {
  final GlobalKey<ShuttleMapState> mapState;
  final PanelController panelController;
  final VoidCallback scheduleChanged;
  ShuttleSchedule2(
      {Key key, this.mapState, this.panelController, this.scheduleChanged})
      : super(key: key);
  @override
  ShuttleScheduleState createState() => ShuttleScheduleState();
}

//Change this
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

//Also edit this
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class ShuttleScheduleState extends State<ShuttleSchedule2>
    with TickerProviderStateMixin {
  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.airport_shuttle)),
    Tab(icon: Icon(Icons.directions_bus)),
  ];

  TabController _tabController;
  TextEditingController _textController;
  String filter;
  bool
      _isShuttle; // true if we have to build the shuttle schedule, false if bus

  @override
  void initState() {
    super.initState();
    _isShuttle = true;
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _textController = new TextEditingController();
    _tabController.addListener(_handleTabSelection);
    _textController.addListener(_handleSearchQuery);

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
          stops: _isShuttle
              ? shuttleStopLists[_tabController.index]
              : busStopLists[_tabController.index],
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
    if (this.filter.contains('am') ||
        this.filter.contains('pm') ||
        this.filter.contains(':')) {
      return curTimeList[index].contains(this.filter);
    }
    if (this.filter.contains('@')) {
      var filterSplit = this.filter.split('@');
      return (curStopList[index % curStopList.length][0]
              .toLowerCase()
              .contains(filterSplit[0].toLowerCase()) &&
          curTimeList[index].contains(filterSplit[1]));
    }
    return curStopList[index % curStopList.length][0]
        .toLowerCase()
        .contains(this.filter.toLowerCase().trim());
  }

  _jumpMap(double lat, double long) {
    this.widget.panelController.animatePanelToPosition(0);
    BlocProvider.of<MapBloc>(context).scrollToLocation(LatLng(lat, long));
  }

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
                containsFilter: _containsFilter,
                jumpMap: _jumpMap,
              ),
              BusList(
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
        ));
  }
}
