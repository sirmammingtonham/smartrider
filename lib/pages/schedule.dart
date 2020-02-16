import 'package:flutter/material.dart';

// TEMPORARY MOCKUP FILE TO HOUSE SHUTTLE SCHEDULE PAGE
// CURRENTLY home.dart has a bug concerning mapbox

class ShuttleSchedule extends StatefulWidget {
  @override
  _ShuttleScheduleState createState() => _ShuttleScheduleState();
}

class _ShuttleScheduleState extends State<ShuttleSchedule> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Text(
                  'SOUTH',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'NORTH',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'WEST',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            title: Text('Shuttle Schedules'),
          ),
          body: TabBarView(
            children: [
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Union',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'B-Lot',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'LXA',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Tibitts/Orchard',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Polytech',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      '15th/College',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Union',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Troy Crosswalk',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      '9th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Alumni House',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      'Jacob',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Colonie',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      'Georgian',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Brinsmade',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Sunset 1',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Sunset 2',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'E-Lot',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'B-Lot',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Union',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'CBIS/AH',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      '15th/Commons',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      '15th/Poly',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'City Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Blitman',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'Winslow',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      'West',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                    Icon(Icons.directions_transit),
                    Text(
                      '87 Gym',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                    Text(
                      '[time]',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
