import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');
  Future<List> testCollection() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _ordersCollection
            .orderBy('created_at', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("no data??");
          final list = snapshot.data?.docs
              .map((doc) => ListTile(
                    title: Text('${doc['rider']}'),
                    subtitle: Text('${doc['status']}'),
                    trailing: Icon(Icons.adb),
                  ))
              .toList();
          return ListView(
            children: list ?? [],
          );
        },
      ),
// FutureBuilder(
//           future: testCollection(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             return Center(child: ListView.builder(itemBuilder: (context, idx) {
//               return Container();
//             }));
//           }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
