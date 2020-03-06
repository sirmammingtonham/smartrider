import 'package:flutter/material.dart';

class ShuttleSchedule extends StatefulWidget {
  @override
  _ShuttleScheduleState createState() => _ShuttleScheduleState();
}

class _ShuttleScheduleState extends State<ShuttleSchedule> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
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
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(40),
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Union to B-Lot', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.purple[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('B-Lot to LXA', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.purple[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('LXA to Tibitts/Orchard', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.purple[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Tibitts/Orchard to Polytech', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.purple[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Polytech to 15th/College', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.purple[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                ],
              ),
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(40),
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Union to Troy Crosswalk', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Troy Crosswalk to 9th St', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('9th St to Alumni House', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Alumni House to Jacob', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Jacob to Colonie', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Colonie to Georgian', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Colonie to Brinsmade', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Brinsmade to Sunset 1', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Sunset 1 to Sunset 2', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Sunset 2 to E-Lot', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('E-Lot to B-Lot', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('B-Lot to Union', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.blue[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                ],
              ),
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(40),
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Union to CBIS/AH', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('CBIS/AH to 15th/Off Commons', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('15th/Off Commons to 15th/Poly', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('15th/Poly to City Station', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('City Station to Blitman', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Blitman to Winslow', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Winslow to West', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('West to 87 Gym', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('87 Gym to Union', textScaleFactor: 1.15, textAlign: TextAlign.right),
                  ),
                  Container(
                    child: VerticalDivider(thickness: 15, color: Colors.orange[400])
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('[time]', textScaleFactor: 1.15),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
