import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Represents an HTTP POST to send to GitHub
class Post {
  final String title; // Title of the issue.
  final String body; // Issue description.
  final String
      labels; // Tags for the issue (should make it userBug or userFeature). NEEDS TO BE A LIST

  /// Constructor.
  Post({this.title, this.body, this.labels});

  /// Translates json post from JSON-format to dart object Post (above)
  factory Post.fromJson(Map json) {
    return Post(
      title: json['title'],
      body: json['body'],
      labels: json['labels'],
    );
  }

  /// Translates POST object to Map, which is the data structure needed to make
  /// the HTTP POST request.
  Map toMap() {
    var map = new Map();
    map["title"] = title;
    map["body"] = body;
    map["labels"] = labels;

    return map;
  }
}

/// Contains the HTTP POST request, given our URL and the Map, which represents
/// the contents within the POST request.
Future createPost(String url, {Map body}) async {
  //Instantiate the GitHub client
OAuth2Client client = GitHubOAuth2Client(
    //Corresponds to the android:scheme attribute
    customUriScheme: 'smartrider.app',
    //The scheme must match the customUriScheme parameter!
    redirectUri: 'smartrider.app://oauth2redirect'
);

//Require an Access Token with the Authorization Code grant
AccessTokenResponse tknResp = await client.getTokenWithAuthCodeFlow(
    clientId: 'be5f78f24f2b3ede9699', 
    clientSecret: '3aa9cbefaa679024014822c9b06614e17de13876',
    scopes: ['repo']);

//From now on you can perform authenticated HTTP requests
httpClient = http.Client()
http.Response resp = await httpClient.post(url,
    headers: {'Authorization': 'Bearer ' + tknResp.accessToken});

  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      print(statusCode);
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

/// The IssueRequest page lets the user enter a bug/feature request through the
/// app, rather than through the GitHub issue page. It can also allow us to
/// add more options that separates the user's bug/feature requests from the
/// developer's bug/feature requests.
class IssueRequest extends StatefulWidget {
  IssueRequest();

  /// Sets the state of the issue request page.
  @override
  _IssueRequestState createState() => new _IssueRequestState();
}

/// Represents the current state of the Issue Request Page.
class _IssueRequestState extends State<IssueRequest> {
  bool valuefirst = false; // for checkbox
  String dropdownValue = "Bug"; // for dropdown
  Future post; // http post held in here.
  String title = "";
  String description = "";

  // Below is the POST URL, which links the POST message to the smartrider
  // GitHub Repository.
  String postUrl =
      "https://api.github.com/repos/:sirmammingtonham/:smartrider/issues";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.grey[800], // Background color of app.
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
              // Style should be replaced with theme.
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
        // Contains TextField and styling for the issue title.
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
              style: TextStyle(color: Colors.white),
              onSubmitted: (value){
                title = value;
              }
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
        // Contains TextField and styling for the issue title.
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
              style: TextStyle(color: Colors.white),
              onChanged: (value){
                description = value;
              }
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
        ),
        Text("This is a:", style: TextStyle(color: Colors.white)),
        // Represents the labels for the issue.
        // FUTURE: Make the selection prettier, maybe checkboxes or stylish tags?
        new DropdownButton<String>(
            value: dropdownValue,
            items: <String>['Bug', 'Feature', 'Other'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            style: TextStyle(color: Colors.white),
            // Changes the Dropdown appearance to display the user's choice.
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
            // Submits the POST request to the GitHub repository to form an issue.
            onPressed: () async {
              // FUTURE: These values should be changed to include the information from
              // the front-end.
              Post newPost = new Post(
                  title: title, body: description, labels: dropdownValue);
              Post p = await createPost(postUrl, body: newPost.toMap());
              print(p.title);
            },
          ),
        )
      ])),
    ));
  }
}
