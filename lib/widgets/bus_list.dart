// ui dependencies
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// loading custom widgets and data
import 'package:smartrider/util/schedule_data.dart';

class BusList extends StatefulWidget {
  final List<ItemScrollController> scrollControllers;
  final Function containsFilter;
  final Function jumpMap;
  BusList({Key key, this.scrollControllers, this.containsFilter, this.jumpMap}) : super(key: key);
  @override
  BusListState createState() => BusListState();
}
  
class BusListState extends State<BusList> with SingleTickerProviderStateMixin,
AutomaticKeepAliveClientMixin<BusList> 
{
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
    return Column(
      children: <Widget> [
        TabBar(
          tabs: busTabs,
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
              busList(0, this.widget.scrollControllers[0], this.widget.containsFilter, this.widget.jumpMap),
              busList(1, this.widget.scrollControllers[1], this.widget.containsFilter, this.widget.jumpMap),
              busList(2, this.widget.scrollControllers[2], this.widget.containsFilter, this.widget.jumpMap),
            ],
          ),
        )
      ]
    );
  }
  @override
  bool get wantKeepAlive => true;
}

Widget busList(int idx, ItemScrollController _scrollController, Function _containsFilter, Function _jumpMap) {
  return ScrollablePositionedList.builder(
    itemCount: busTimeLists[idx].length,
    itemScrollController: _scrollController,
    itemBuilder: (context, index) {
      var curStopList = busStopLists[idx];
      var curTimeList = busTimeLists[idx];
      if (!_containsFilter(curStopList, curTimeList, index) || curTimeList[index] == "- - - -") {
        return null;
      }
      return Card(
        child: ListTile(
          leading: Icon(Icons.directions_bus),
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