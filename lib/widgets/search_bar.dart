// ui imports
import 'package:flutter/material.dart';
import 'package:smartrider/widgets/icons.dart';

// import map background
import 'map_ui.dart';

class SearchBar extends StatefulWidget {
  const SearchBar();

  @override
  State<StatefulWidget> createState() => SearchBarState();
}
class SearchBarState extends State<SearchBar> {
  SearchBarState();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Replace this container with your Map widget
        ShuttleMap(),
        Positioned(
          top: 30,
          right: 15,
          left: 15,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: 50,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5.0,
                child: Row(
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(SR_Icons.Settings),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 18.0,
                        // height: 2.0,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Need a Safe Ride?"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text('JS'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
