import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/saferide/order.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _ordersCollection =
      FirebaseFirestore.instance.collection('orders_test');
  Future<List> testCollection() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // might have to wrap in blocbuilder to react to acceptance but idk if we want to do that here
      body: StreamBuilder(
          //TODO: move stream and logic into orders bloc
          stream: _ordersCollection
              .where('status', isEqualTo: 'WAITING')
              .orderBy('updated_at', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
              return Text('no data??');
            Order latestOrder = Order.fromSnapshot(snapshot.data!.docs[0]);
            final queueList = snapshot.data!.docs
                .skip(1)
                .map((doc) => ListTile(
                      title: Text('${(doc['rider'] as DocumentReference).id}'),
                      subtitle: Text('${doc['status']}'),
                      trailing: Icon(Icons.adb),
                    ))
                .toList();
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.h),
                child: Column(
                  children: [
                    /// card showing the most recent order they can accept
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 3.h),
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Text(
                                'New Rider Waiting!',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: -4),
                              leading: Icon(Icons.face),
                              title: Text('Ethan'),
                              subtitle: Text('Rider\'s name'),
                            ),
                            ListTile(
                              leading: Icon(Icons.add_location_alt_rounded),
                              title: Text(latestOrder.pickupAddress),
                              subtitle: Text('Pickup'),
                            ),
                            ListTile(
                              leading: Icon(Icons.wrong_location_rounded),
                              title: Text(latestOrder.dropoffAddress),
                              subtitle: Text('Dropoff'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('ACCEPT'),
                                  onPressed: () {
                                    /* do the bloc event stuff here */
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () async {
                                    /* we have to make them give a reason for cancellation */
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                              child: Card(
                                                  child: TextFormField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    'Reason for cancellation.',
                                                hintText:
                                                    'Reason for cancellation.'),
                                            onFieldSubmitted: (String? str) {},
                                          )));
                                        });
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// spacer
                    Container(height: 1.h),

                    Center(
                      child: Text(
                        'Riders in Queue: ${0}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),

                    /// A list of future orders
                    ListView(
                      shrinkWrap: true,
                      children: queueList,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
