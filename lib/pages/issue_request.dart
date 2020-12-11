import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final String title;
  final String body;
  final String labels;

  Post({this.title, this.body, this.labels});

  factory Post.fromJson(Map json) {
    return Post(
      title: json['title'],
      body: json['body'],
      labels: json['labels'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["title"] = title;
    map["body"] = body;
    map["labels"] = labels;

    return map;
  }
}

Future createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      print(statusCode);
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

/// The IssueRequest page lets the user enter
class IssueRequest extends StatefulWidget {
  IssueRequest();

  /// Sets the state of the issue request page.
  @override
  _IssueRequestState createState() => new _IssueRequestState();
}

class _IssueRequestState extends State<IssueRequest> {
  bool valuefirst = false; // for checkbox
  String dropdownValue = ""; // for dropdown
  Future post; // http post held in here.
  String postUrl =
      "https://github.com/repos/:sirmammingtonham/:smartrider/issues";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
          child: Column(children: [
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ), // adds space between button and lower bezel
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('< BACK', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple[600])),
            )
          ],
        ),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Text("Title:", style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
            ),
            Text("Enter a brief description of your request.",
                style: TextStyle(fontSize: 15.0, color: Colors.white)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
        ),
        Container(
            width: 330.0,
            height: 50.0,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              ),
            )),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Text("Description:",
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
            ),
            Text("Summarize your request.",
                style: TextStyle(color: Colors.white)),
          ],
        ),
        Container(
            width: 330.0,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              ),
              maxLines: null,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
        ),
        Text("This is a:", style: TextStyle(color: Colors.white)),
        new DropdownButton<String>(
            value: dropdownValue,
            items: <String>['', 'Bug', 'Feature', 'Other'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            }),
        Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Container(
              width: 300.0,
              child: Text(
                'By selecting the checkmark, you give the developers of SmartRider' +
                    ' permission to contact you using your entered email address if a follow-up ' +
                    'is necessary. Any other identifying information is to remain' +
                    ' anonymous.',
                style: TextStyle(fontSize: 17.0, color: Colors.white),
              ),
            ),
            Checkbox(
              checkColor: Colors.purple[400],
              activeColor: Colors.grey[500],
              focusColor: Colors.grey[500],
              value: valuefirst,
              onChanged: (bool value) {
                setState(() {
                  valuefirst = value;
                });
              },
            ),
          ],
        ),
        Container(
          width: 350.0,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple[600])),
            child: Text(
              'SUBMIT REQUEST',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              // These values should be changed to include the information from
              // the front-end.
              Post newPost = new Post(
                  title: "123", body: "test", labels: ["hello"].toString());
              Post p = await createPost(postUrl, body: newPost.toMap());
              print(p.title);
            },
          ),
        )
      ])),
    ));
  }
}
