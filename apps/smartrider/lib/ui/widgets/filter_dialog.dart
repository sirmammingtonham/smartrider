import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key, this.stops, this.controller}) : super(key: key);
  final List<List<String>>? stops;
  final TextEditingController? controller;

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? searchQuery;

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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Stack(children: <Widget>[
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      height: 64,
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 5.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const IconButton(
                              icon: Icon(Icons.search),
                              onPressed: null,
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextField(
                                controller: widget.controller,
                                autofocus: false,
                                onSubmitted: (query) {
                                  Navigator.pop(context);
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Filter Results'),
                              ),
                            )),
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                widget.controller!.text = '';
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget.stops!.length + 1,
                          itemBuilder: (context, index) {
                            // hack that allows us to show the last list item
                            // without clipping
                            if (index == widget.stops!.length) {
                              return const SizedBox(height: 20);
                            }
                            final stopName = widget.stops![index][0];
                            return ListTile(
                              leading: const Icon(Icons.departure_board),
                              title: Text(stopName),
                              trailing: const Icon(Icons.search),
                              onTap: () {
                                widget.controller!.text = stopName;
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
                    child: const Icon(Icons.arrow_back),
                  )),
            ])));
  }
}
