// ui dependencies
import 'package:day_night_switch/day_night_switch.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// loading custom widgets and data
import 'package:smartrider/util/data.dart';
import 'package:smartrider/widgets/filter_dialog.dart';
import 'package:smartrider/widgets/shuttle_list.dart';
import 'package:smartrider/widgets/bus_list.dart';
import 'package:smartrider/widgets/map_ui.dart';

// ui imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartrider/data/repository/shuttle_repository.dart';

// bloc imports
import 'package:smartrider/blocs/shuttle/shuttle_bloc.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

// custom widget imports
import 'package:smartrider/widgets/map_ui.dart';
import 'package:smartrider/widgets/search_bar.dart';
import 'package:smartrider/pages/schedule.dart';

//***
//Natalia added
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';

Color darkGreen = Color(0xff2bae5d),
    lightGreen = Color(0xff49bf88),
    darkBlue = Color(0xff424a65);
List<Map<String, dynamic>> availableTickets = [];
//FORMATING DURATION
//TO FIX: does not work for time <0 (you missed it) or >=60 (more than an hour time)
//it also needs a way to refresh constantly or when prompted --> might add a button that also
//tells you the exact time you last refreshed.
format(Duration d) {
  d.toString().substring(2, 4);
}
//*******************************

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

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class test extends StatefulWidget {
  test({Key key}) : super(key: key);

  @override
  TicketContainer createState() => TicketContainer();
}

/*class _MyStatefulWidgetState extends State<test> {
  List<Item> _data = generateItems(8);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle: Text('To delete this panel, tap the trash can icon'),
              trailing: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
*/

class TicketContainer extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.symmetric(vertical: 15.0),
      //Background
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(25.0)),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Arriavl time
                      Text("Arrrives In:"),
                      SizedBox(
                        height: 5.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              //Text is in string
                              //FIX: need to count down the minutes currently using the refresh button.
                              //Right now the date and time of when the shuttle will arrive is hard coded.
                              //We need to pull the data from the schudle_database and have it be able to
                              //switch on command with the bus_database and the refresh button.
                              text: format(
                                  DateTime(2020, 10, 6, 17, 59, 50, 0, 0)
                                      .difference(DateTime.now())),
                              style: Theme.of(context).textTheme.display1,
                            ),
                            TextSpan(
                                text: "min",
                                style: Theme.of(context).textTheme.subtitle),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            //TO FIX: this is hard coded to be "Union". it should change as the
                            //schedule changes.
                            TextSpan(
                                text: "On Route to: ",
                                style: TextStyle(color: Colors.black87)),
                            TextSpan(
                                text: "Union",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*
                            Text(
                              DateFormat("HH:mm").format(
                                  DateTime(2020, 10, 4, 14, 59, 50, 0, 0)),
                              style: TextStyle(color: Colors.grey),
                            ),
                            */
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                //The Creation of the shuttle icon and shuttle name
                                children: [
                                  Icon(
                                    Icons.directions_bus,
                                    color: Colors.black54,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 9.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    //TO FIX: this only has North bus.
                                    //Ideally it would be smart have it as a list that should
                                    //go through the data instead of hard coding it in.
                                    child: Text(
                                      "NORTH",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          /*
                        SizedBox(width: 9),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat("HH:mm").format(
                                  DateTime(2020, 10, 4, 14, 59, 50, 0, 0)),
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_bus,
                                  color: Colors.black54,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 9.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  child: Text(
                                    "20",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                        */
                        ],
                      )
                    ],
                  ),
                ),
                /*
                Text(
                  //CURRENT CELL PHONE TIME
                  DateFormat("HH:mm").format(DateTime.now()),
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .apply(color: Colors.blue),
                ),
                */
                //TO FIX: this is the "refresh page" feature. It is needed in order for the
                //data to stay relevent.
                //At the moment, the only time the schedule is refreshed when the app
                //is restarted.
                RaisedButton.icon(
                  color: lightGreen,
                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text(
                    "Refresh",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .apply(color: Colors.white),
                  ),
                  //This is where it needs to refresh the 'page' instead of print("pressed")
                  onPressed: () => print("pressed"),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Row(
                      children: [
                        Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(.3),
                          border: Border.all(color: Colors.blue, width: 3.0),
                        ),
                      ),
                      
                        SizedBox(
                          width: 9.0,
                        ),
                        Text("RPI Union",
                            style: Theme.of(context).textTheme.subtitle),
                      ],
                    ),
                    
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.withOpacity(.3),
                        border: Border.all(color: Colors.orange, width: 3.0),
                      ),
                    ),
                    SizedBox(
                      width: 9.0,
                    ),
                    Text("TO: RPI Union",
                        style: Theme.of(context).textTheme.subtitle),
                  ],
                ),
                */
            //TO FIX: This feature should list all the stops the bus will be stopping
            //to. This is pretty much "what stops are next" list. It should update accordingly
            //after the shuttle reaches its stop.
            ExpansionTile(
              //The current stop
              title: Text("RPI Union",
                  style: Theme.of(context).textTheme.subtitle),
              children: <Widget>[
                //List of "next stops"
                ListTile(
                  title:
                      Text("DATA", style: Theme.of(context).textTheme.subtitle),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
