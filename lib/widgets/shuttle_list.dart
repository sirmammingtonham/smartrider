// ui dependencies
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

// loading custom widgets and data
import 'package:smartrider/util/schedule_data.dart';

class ShuttleList extends StatefulWidget {
  final List<ItemScrollController> scrollControllers;
  final Function containsFilter;
  ShuttleList({Key key, this.scrollControllers, this.containsFilter}) : super(key: key);
  @override
  ShuttleListState createState() => ShuttleListState();
}
  
class ShuttleListState extends State<ShuttleList> with SingleTickerProviderStateMixin,
AutomaticKeepAliveClientMixin<ShuttleList> 
{
  final List<Widget> shuttleTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
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
          tabs: shuttleTabs,
          // unselectedLabelColor: Colors.white.withOpacity(0.3),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.74,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              shuttleList(0, this.widget.scrollControllers[0], this.widget.containsFilter),
              shuttleList(1, this.widget.scrollControllers[1], this.widget.containsFilter),
              shuttleList(2, this.widget.scrollControllers[2], this.widget.containsFilter),
            ],
          ),
        )
      ]
    );
  }
  @override
  bool get wantKeepAlive => true;
}

Widget shuttleList(int idx, ItemScrollController _scrollController, Function _containsFilter) {
  return ScrollablePositionedList.builder(
    itemCount: shuttleTimeLists[idx].length,
    itemScrollController: _scrollController,
    itemBuilder: (context, index) {
      var curStopList = shuttleStopLists[idx];
      var curTimeList = shuttleTimeLists[idx];
      if (!_containsFilter(curStopList, curTimeList, index)) {
        return null;
      }
      return Card(
        child: ListTile(
          leading: Icon(Icons.airport_shuttle),
          title: Text(curStopList[index%curStopList.length]),
          subtitle: Text(curTimeList[index]),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {},
        ),
      );
    },
  );
}