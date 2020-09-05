import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  List<List<String>> stops;
  TextEditingController controller;
  // ValueChanged<String> updateTime, updateStop;
  FilterDialog({Key key, this.stops, this.controller}) : super(key: key);
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String searchQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Stack(children: <Widget>[
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 64,
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 5.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: null,
                            ),
                            Expanded(
                                child: Padding(
                              child: TextField(
                                controller: widget.controller,
                                autofocus: false,
                                onSubmitted: (query) {
                                  Navigator.pop(context);
                                },
                                decoration:
                                    InputDecoration(hintText: "Filter Results"),
                              ),
                              padding: const EdgeInsets.only(right: 8.0),
                            )),
                            IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                widget.controller.text = '';
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 400,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget.stops.length + 1,
                          itemBuilder: (context, index) {
                            // hack that allows us to show the last list item without clipping
                            if (index == widget.stops.length) {
                              return SizedBox(height: 20);
                            }
                            String stop_name = widget.stops[index][0];
                            return ListTile(
                              leading: Icon(Icons.departure_board),
                              title: Text(stop_name),
                              trailing: Icon(Icons.search),
                              onTap: () {
                                widget.controller.text = stop_name;
                                Navigator.pop(context);
                              },
                            );
                          }),
                    ),
                  ]),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  )),
            ])));
  }
}
