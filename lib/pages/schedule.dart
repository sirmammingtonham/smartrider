import 'package:flutter/material.dart';
import 'package:smartrider/util/schedule_data.dart';

class ShuttleSchedule extends StatefulWidget {
  ScrollController scroll_c;
  ShuttleSchedule({Key key, this.scroll_c}) : super(key: key);
  @override
  _ShuttleScheduleState createState() => _ShuttleScheduleState();
}

class _ShuttleScheduleState extends State<ShuttleSchedule> with SingleTickerProviderStateMixin {
  final shuttle_lists = [shuttle_south, shuttle_north, shuttle_south];
  final List<Widget> myTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
  ];
  double initial, distance;

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        title: Text('Shuttle Schedules'),
        leading: Icon(Icons.arrow_downward),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.arrow_downward)
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
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
          else if (this.distance < 0 && _tabController.index < 2) {
            _tabController.animateTo(_tabController.index + 1);
          }
        },
        child: Container(
          child: ListView.builder(
            itemCount: this.shuttle_lists[_tabController.index].length,
            controller: this.widget.scroll_c,
            itemBuilder: (context, index) {
              var cur_list = this.shuttle_lists[_tabController.index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.airport_shuttle),
                  title: Text(cur_list[index][0]),
                  subtitle: Text(cur_list[index][1]),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}