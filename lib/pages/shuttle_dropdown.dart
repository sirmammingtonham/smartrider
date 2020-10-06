// ui dependencies
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

/*
-==-=--=-=--==-=-=-=-=-=-=-=-=
LOOK HERE LOOK HERE LOOK HERE
-=-=-=-=-=-=-=-=-=-=--=--=---=

For people in the UI improvement team, we are trying to implement this
panel system into our current schedule slider.
To better understand this look at home.dart under pages and change line 93 
from "panel: test())," to "panel: main()),". And rerun your andriod emulator
to see what is the current schuedle UI.
Looking at the current scheduele UI we have a top section that has each individual
shuttle and bus. Clicking on this allows us to see each shuttles stop. Right now 
all we have is the bus's stops looping over and over again in a list.
We are trying to change this to a panel system. Where each stop under a given bus has 
a panel listing out the times when the bus should be at said stop.

To implement we first should work to understand flutter and this panel system. Then
we should work to implement this into the schedule.dart file.

Remember that this panel systme should be sub system under each shuttle at the top.

NOTE: Remember to switch back to the testing file in the home.dart file.
*/

class test extends StatefulWidget {
  test({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/*The class item is each panel or item and what information is inside of it
headValue is in the example Panel #. expandedValue is only seen when a penel
is expanded, this can be used as a description for each shuttle pr stop*/
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

/*Creates each item in this function*/
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      //Each stop should be the headerValue
      headerValue: 'Panel $index',

      //Each stop descrition should be expandedValue
      expandedValue: 'This is item number $index',
    );
  });
}

class _MyStatefulWidgetState extends State<test> {
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

          /*This is all the information when we expand the item*/
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle: Text('Delete icon'),

              /*Maybe we can add a report function here instead a delete function
              the report function allows us to create a real time tracker for 
              the bus*/
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
