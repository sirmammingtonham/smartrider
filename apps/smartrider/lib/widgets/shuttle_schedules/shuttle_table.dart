// // ui dependencies import 'dart:ui';

// import 'package:flutter/material.dart'; // import
// 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// // loading custom widgets and data import 'package:shared/util/data.dart';

// class ShuttleTable extends StatefulWidget {const ShuttleTable({Key? key,
//   this.containsFilter, this.jumpMap}) : super(key: key); final Function?
//   containsFilter; final Function? jumpMap;

//   @override ShuttleTableState createState() => ShuttleTableState();
// }

// class ShuttleTableState extends State<ShuttleTable> with
//     SingleTickerProviderStateMixin {final List<Widget> shuttleTabs = [const
//     Tab(text: 'SOUTH'), const Tab(text: 'NORTH'), const Tab(text: 'WEST'),
//     const Tab(text: 'WEEKEND'),
//   ];
//   TabController? _tabController;

//   @override void initState() {super.initState(); _tabController =
//   TabController(vsync: this, length: shuttleTabs.length);
//   _tabController!.addListener(_handleTabSelection);
//   }

//   void _handleTabSelection() {setState(() {});
//   }

//   Color _getTabColor(TabController tc) {if (tc.index == 0) {return
//     Colors.green;} else if (tc.index == 1) {return Colors.red;} else if
//     (tc.index == 2) {return Colors.blue;} else {return Colors.orange;
//     }
//   }

//   @override void dispose() {_tabController!.dispose(); super.dispose();
//   }

//   @override Widget build(BuildContext context) {return Material(child:
//   Column(children: <Widget>[TabBar(indicatorColor:
//   _getTabColor(_tabController!), isScrollable: true, tabs: shuttleTabs, //
//   unselectedLabelColor: Colors.white.withOpacity(0.3), labelColor:
//   Theme.of(context).brightness == Brightness.light? Colors.black : null,
//   unselectedLabelColor: Theme.of(context).brightness == Brightness.light?
//   Colors.black : null, controller: _tabController,
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.7,
//           child: TabBarView(
//             controller: _tabController,
//             children: <Widget>[
//               shuttleList(0, widget.containsFilter, widget.jumpMap),
//               shuttleList(1, widget.containsFilter, widget.jumpMap),
//               shuttleList(2, widget.containsFilter, widget.jumpMap),
//               shuttleList(3, widget.containsFilter, widget.jumpMap),
//             ],
//           ),
//         )
//       ]),
//     );
//   }
// }

// Widget shuttleList(int idx, Function? _containsFilter, Function? _jumpMap)
//   {final curStopList = shuttleStopLists[idx]; return Scaffold(body:
//   SingleChildScrollView(scrollDirection: Axis.horizontal, child:
//   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const
//   SizedBox(height: 5,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: List.generate(
//               shuttleStopLists[idx].length,
//               (index) => Container(
//                   alignment: Alignment.center,
//                   width: 98,
//                   height: 30,
//                   child: SizedBox(
//                     child: Text(
//                       curStopList[index % curStopList.length][0],
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   )),
//             ),
//           ),
//           Flexible(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: DataTable(
//                 columnSpacing: 50,
//                 columns: List<DataColumn>.generate(
//                     shuttleStopLists[idx].length,
//                     (index) => const DataColumn(
//                           label: Flexible(child: Text('6:30pm')),
//                         )),
//                 rows: List<DataRow>.generate(
//                   (shuttleTimeLists[idx].length / shuttleStopLists[idx].length +
//                           1)
//                       .truncate(),
//                   (index) => DataRow(
//                     cells: List<DataCell>.generate(
//                       shuttleStopLists[idx].length,
//                       (datIdx) => const DataCell(
//                         Text('6:30pm'),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
