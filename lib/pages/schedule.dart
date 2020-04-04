import 'package:flutter/material.dart';
import 'package:smartrider/util/schedule_data.dart';
import 'package:smartrider/widgets/filter_dialog.dart';

class ShuttleSchedule extends StatefulWidget {
  ScrollController scroll_c;
  ShuttleSchedule({Key key, this.scroll_c}) : super(key: key);
  @override
  _ShuttleScheduleState createState() => _ShuttleScheduleState();
}
  
class _ShuttleScheduleState extends State<ShuttleSchedule> with SingleTickerProviderStateMixin {
  static final weekday_north_flat = weekday_north.expand((i) => i).toList();
  static final weekday_south_flat = weekday_south.expand((i) => i).toList();
  static final weekday_west_flat = weekday_west.expand((i) => i).toList();
  final shuttle_lists = [weekday_south_flat, weekday_north_flat, weekday_west_flat];
  final shuttle_stops_lists = [south_stops,north_stops,west_stops];
  final List<Widget> myTabs = [
    Tab(text: 'SOUTH'),
    Tab(text: 'NORTH'),
    Tab(text: 'WEST'),
  ];
  double initial, distance;
  String filter;

  TabController _tabController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
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
  }

  _displayFilterDialog() async {
    final builder = (BuildContext ctx) => FilterDialog(
      stops: shuttle_lists[_tabController.index],
      controller: _textController,
    );
    await showDialog(context: context, builder: builder);
    print(filter);
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
        child: ListView.builder(
          itemCount: this.shuttle_lists[_tabController.index].length,
          controller: this.widget.scroll_c,
          itemBuilder: (context, index) {
            var cur_stop_list = this.shuttle_stops_lists[_tabController.index];
            var cur_shuttle_list = this.shuttle_lists[_tabController.index];
            if (filter == null) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.airport_shuttle),
                  title: Text(cur_stop_list[index%cur_stop_list.length]),
                  subtitle: Text(cur_shuttle_list[index]),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
              );
            }
            else if (cur_stop_list[index%cur_stop_list.length].toLowerCase().contains(filter) || cur_stop_list[index%cur_stop_list.length].contains(filter)) {
               return Card(
                 child: ListTile(
                  leading: Icon(Icons.airport_shuttle),
                  title: Text(cur_stop_list[index%cur_stop_list.length]),
                  subtitle: Text(cur_shuttle_list[index]),
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
    ));
  }
}