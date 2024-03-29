// // ui dependencies
// import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// //import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:awesome_notifications/awesome_notifications.dart';

// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// // import 'package:intl/intl.dart';
//
// import 'package:smartrider/ui/widgets/sliding_up_panel.dart';
// // import 'package:smartrider/blocs/map/map_bloc.dart';
// // import 'package:smartrider/blocs/schedule/schedule_bloc.dart';

// //import 'package:flutter/rendering.dart';

// // loading custom widgets and data
// import 'package:shared/util/data.dart';
// import 'package:smartrider/ui/widgets/custom_widgets/custom_expansion_tile.dart';

// import 'package:smartrider/ui/widgets/custom_widgets/custom_painters.dart';

// const List<String> choices = [
//   'Set Reminder',
//   'See on map',
//   'View on timetable'
// ];

// /// Creates an object that contains all the shuttles and their respective stops.
// class ShuttleTimeline extends StatefulWidget {
//   const ShuttleTimeline({Key? key, required this.panelController})
//       : super(key: key);

//   final PanelController panelController;
//   @override
//   ShuttleTimelineState createState() => ShuttleTimelineState();
// }

// /// Defines each shuttle and makes a tab for each one atop of the schedule panel.
// class ShuttleTimelineState extends State<ShuttleTimeline>
//     with SingleTickerProviderStateMixin {
//   final List<Widget> shuttleTabs = [
//     const Tab(text: 'SOUTH'),
//     const Tab(text: 'NORTH'),
//     const Tab(text: 'WEST'),
//     const Tab(text: 'WEEKEND'),
//   ];

//   static const List<Color> shuttleColors = [
//     Colors.green,
//     Colors.red,
//     Colors.blue,
//     Colors.orange
//   ];

//   TabController? _tabController;
//   var isExpandedList = List<bool>.filled(100, false);
//   @override

//   /// Affects the expansion of each shuttles list of stops
//   void initState() {
//     super.initState();
//     _tabController =
//         TabController(vsync: this, length:
// shuttleTabs.length, initialIndex: 1);
//     _tabController!.addListener(() {
//       isExpandedList.fillRange(0, 100, false);
//       _handleTabSelection();
//     });
//     isExpandedList.fillRange(0, 100, false);
//   }

//   void _handleTabSelection() {
//     setState(() {});
//   }

//   /// Builds each tab for each shuttle and also accounts for the users
//   /// light preferences.
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       TabBar(
//         indicatorColor: shuttleColors[_tabController!.index],
//         isScrollable: true,
//         tabs: shuttleTabs,
//         labelColor: Theme.of(context).brightness == Brightness.light
//             ? Colors.black
//             : null,
//         unselectedLabelColor:
// Theme.of(context).brightness == Brightness.light
//             ? Colors.black
//             : null,
//         controller: _tabController,
//       ),
//       SizedBox(
//         height: MediaQuery.of(context).size.height * 0.7,
//         child: TabBarView(
//           controller: _tabController,
//           children: <Widget>[
//             shuttleList(0),
//             shuttleList(1),
//             shuttleList(2),
//             shuttleList(3),
//           ],
//         ),
//       )
//     ]);
//   }

//   /// Builds the shuttlelist widget which contains all the stops and
//   /// useful user information like the next arrival.
//   Widget shuttleList(int idx) {
//     return ScrollablePositionedList.builder(
//       itemCount: shuttleStopLists[idx].length,
//       itemBuilder: (context, index) {
//         final curStopList = shuttleStopLists[idx];
//         return CustomExpansionTile(
//           title: Text(curStopList[index % curStopList.length][0]),
//           subtitle: const Text('Info unavailable'),
//           leading: CustomPaint(
//               painter: FillPainter(
//                   circleColor: shuttleColors[_tabController!.index],
//                   lineColor: Theme.of(context).primaryColorLight,
//                   first: index == 0,
//                   last: index == curStopList.length - 1),
//               child: const SizedBox(
//                 height: 50,
//                 width: 45,
//               )),
//           trailing:
//               //toggle()
//               isExpandedList[index % curStopList.length]
//                   ? const Text('Hide Arrivals -')
//                   : const Text('Show Arrivals +'),
//           onExpansionChanged: (value) {
//             setState(() {
//               isExpandedList[index % curStopList.length] = value;
//             });
//           },
//           children: [
//             CustomPaint(
//               painter: StrokePainter(
//                 circleColor: Theme.of(context).buttonColor,
//                 lineColor: Theme.of(context).primaryColorLight,
//                 last: index == curStopList.length - 1,
//               ),
//               child: ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: Container(
//                     margin: const EdgeInsets.only(left: 34.5),
//                     constraints: const BoxConstraints.expand(width: 8),
//                   ),
//                   title: RefreshIndicator(
//                       onRefresh: () =>
//                    Future.delayed(const Duration(seconds: 1), () => '1'),
//                       displacement: 1,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: 5,
//                         itemExtent: 50,
//                         itemBuilder: (BuildContext context, int timeIndex) {
/*
  * Here we should add the use of DateTime.now()
  * When the backend team is complete of full implementing
  * time.dart file we can use each objects values to find the
  * difference to the current time.
  * EX:
  * var current_time = new DateTime.now();
  * var shuttle_time = new DateTime.parse(2002-02-27T19:00:00Z);
  * Duration difference = shuttle_time.difference(current_time);
  * 'In ' + difference.inMinutes.toString() + ' minutes' should print out a int
  * that can be given
  * to the user
  */
//                           //var currentTime = new DateTime.now();
//                           //var shuttleTime = DateTime.parse(2002-02-27T19:00:00Z);
//                           //Duration difference = shuttleTime.difference(currentTime);
//                           return ListTile(
//                             dense: true,
//                             leading: const Icon(Icons.access_time, size: 20),
//                             title: Text(
//                               shuttleTimeLists[idx][timeIndex],
//                               style: const TextStyle(fontSize: 15),
//                             ),
//                             subtitle: const Text('Info unavailable'),
//                             trailing: PopupMenuButton<String>(
//                                 onSelected: _handlePopupSelection,
//                                itemBuilder: (BuildContext context) => choices
//                                     .map((choice) => PopupMenuItem<String>(
//                                         value: choice, child: Text(choice)))
//                                     .toList()),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _handlePopupSelection(String choice) {
//     if (choice == choices[0]) {
//       // BlocProvider.of<ScheduleBloc>(context)
//       //     .scheduleAlarm(stopTime[1], 'busStop.stopName', isShuttle: true);
//     } else if (choice == choices[1]) {
//       widget.panelController.animatePanelToPosition(0);
//       // BlocProvider.of<MapBloc>(context).scrollToLocation();
//     }
//   }
// }

// // /// Returns the stop that is closest to the current time.
// // _getTimeIndex(List<String> curTimeList) {
// //   var now = DateTime.now();
// //   var f = DateFormat('H.m');
// //   double min = double.maxFinite;
// //   double curTime = double.parse(f.format(now));
// //   String? closest;
// //   curTimeList.forEach((time) {
// //     var t = time.replaceAll(':', '.');
// //     double? compTime = double.tryParse(t.substring(0, t.length - 2));
// //     if (compTime == null) return;
// //     if (t.endsWith('pm') && !t.startsWith('12')) {
// //       compTime += 12.0;
// //     }
// //     if ((curTime - compTime).abs() < min) {
// //       min = (curTime - compTime).abs();
// //       closest = time;
// //     }
// //   });

// //   return curTimeList.indexWhere((element) => element == closest);
// // }
