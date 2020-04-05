import 'package:flutter/material.dart';
import 'package:smartrider/util/schedule_data.dart';
import 'package:smartrider/widgets/filter_dialog.dart';

class ShuttleSchedule extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback scheduleChanged;
  ShuttleSchedule({Key key, this.scrollController, this.scheduleChanged}) : super(key: key);
  @override
  _ShuttleScheduleState createState() => _ShuttleScheduleState();
}
  
class _ShuttleScheduleState extends State<ShuttleSchedule> with TickerProviderStateMixin {
  final List<Widget> shuttleTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
    Icon(Icons.directions_bus),
  ];

  final List<Widget> busTabs = [
    Icon(Icons.airport_shuttle),
    Tab(text: '22'),
    Tab(text: '80'),
    Tab(text: '85'),
    Tab(text: '87'),
    Tab(text: '182'),
    Tab(text: '224'),
    Tab(text: '286'),
    Tab(text: '289'),
    Tab(text: '522'),
    Tab(text: '808'),
    Tab(text: '809'),
    Tab(text: '815'),
  ];

  double initial, distance;
  String filter;
  bool _isShuttle; // true if we have to build the shuttle schedule, false if bus
  TabController _tabController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _isShuttle = true;
    _tabController = new TabController(vsync: this, length: shuttleTabs.length);
    _textController = new TextEditingController();
    _tabController.addListener(_handleTabSelection);
    _textController.addListener(_handleSearchQuery);
    filter = null;
  }
  _handleSearchQuery() {
    setState(() {
      filter = _textController.text;
    });
  }
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
    if (_tabController.index == 3 && _isShuttle ) {
      _switchState();
    }
    else if (_tabController.index == 0 && !_isShuttle) {
      _switchState();
    }
  }
  // switches from shuttle build to bus build
  _switchState() {
    _isShuttle = !_isShuttle;
    _tabController = new TabController(vsync: this, length: _isShuttle ? shuttleTabs.length : busTabs.length);
    _tabController.index = _isShuttle ? 2 : 1;
    _tabController.addListener(_handleTabSelection);
    widget.scheduleChanged(); // notify parent widget so we can modify top appbar text
    setState(() {});
  }

  _displayFilterDialog() async {
    final builder = (BuildContext ctx) => FilterDialog(
      stops: _isShuttle ? shuttleStopLists[_tabController.index] : busStopLists[_tabController.index],
      controller: _textController,
    );
    await showDialog(context: context, builder: builder);
  }

  bool _containsFilter(var curStopList, var curTimeList, var index) {
    assert (filter != null);
    if (double.tryParse(filter) != null) {
      return curTimeList[index].contains(filter);
    }
    if (filter.contains('am') || filter.contains('pm') || filter.contains(':')) {
      return curTimeList[index].contains(filter);
    }
    if (filter.contains('@')) {
      var filterSplit = filter.split('@');
      return (curStopList[index%curStopList.length].toLowerCase().contains(filterSplit[0].toLowerCase()) &&
        curTimeList[index].contains(filterSplit[1]));
    }
    return curStopList[index%curStopList.length].toLowerCase().contains(filter.toLowerCase().trim());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
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
          leading: Icon(Icons.arrow_downward),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.arrow_downward)
            )
          ],
          bottom: TabBar(
            isScrollable: !_isShuttle,
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: _isShuttle ? shuttleTabs : busTabs,
          ),
        ),
        body: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            this.initial = details.globalPosition.dx;
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            this.distance = details.globalPosition.dx - this.initial;  
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            this.initial = 0.0; 
            // swiped right
            if (this.distance > 0 && _tabController.index > 0) {
              _tabController.animateTo(_tabController.index - 1);
            }
            // swiped left
            else if (this.distance < 0 && _tabController.index < (_isShuttle ? shuttleTabs.length : busTabs.length) - 1) {
              _tabController.animateTo(_tabController.index + 1);
            }
          },
          child: ListView.builder(
            itemCount: _isShuttle ? shuttleTimeLists[_tabController.index].length : 
              busTimeLists[_tabController.index-1].length,
            controller: this.widget.scrollController,
            itemBuilder: (context, index) {
              var curStopList = _isShuttle ? shuttleStopLists[_tabController.index] : 
                busStopLists[_tabController.index-1];
              var curTimeList = _isShuttle ? shuttleTimeLists[_tabController.index] :
                busTimeLists[_tabController.index-1];
              if (filter == null) {
                return Card(
                  child: ListTile(
                    leading: Icon(_isShuttle ? Icons.airport_shuttle : Icons.directions_bus),
                    title: Text(curStopList[index%curStopList.length]),
                    subtitle: Text(curTimeList[index]),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {},
                  ),
                );
              }
              else if (_containsFilter(curStopList, curTimeList, index)) {
                return Card(
                  child: ListTile(
                    leading: Icon(_isShuttle ? Icons.airport_shuttle : Icons.directions_bus),
                    title: Text(curStopList[index%curStopList.length]),
                    subtitle: Text(curTimeList[index]),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {},
                  ),
                );
              }
              else {
                return Container();
              }
            },
          ),
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