import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:smartrider/util/strings.dart';

/// Represents an HTTP POST, structures to send the info needed
/// to create a GitHub API Post Request to create an issue.
class Post {
  /// Title of the issue.
  final String title;

  /// Description of the issue.
  final String body;

  /// Tags for the issue (should make it userBug or userFeature).
  final String labels;

  /// Creates a Post Request, represented as an object.
  Post({this.title, this.body, this.labels});

  /// Creates a Post Object, given the title, body, and label structured as
  /// a map (or a JSON format).
  factory Post.fromJson(Map json) {
    return Post(
      title: json['title'],
      body: json['body'],
      labels: json['labels'],
    );
  }

  /// Returns a new Map object using values in this Post object.
  Map toMap() {
    Map map = new Map();
    map["title"] = title;
    map["body"] = body;
    map["labels"] = labels;
    return map;
  }
}

/// Creates an HTTP Post Request, given the POST url and a JSON-organized file.
Future createPost(String url, {Map body}) async {
  /// Creates the GitHub OAuth2Client provided by Flutter's OAuth2 library
  var client = OAuth2Helper(GitHubOAuth2Client(
      // Corresponds with the Android Scheme (located in AndroidManifest.xml)
      customUriScheme: 'smartrider.app',
      // Handles redirect URI after authorization
      redirectUri: 'smartrider.app://oauth2redirect'));

  /// Gets the response from authenticating the request.
  client.setAuthorizationParams(
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: 'be5f78f24f2b3ede9699',
      clientSecret: github_api_secret,
      scopes: ['repo']);

  /// The client used to submit the authenticated HTTP Post Request.
  Future resp = client.post(url, body: body);
  resp.then((value) => print(value));

  return resp;
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
  /// Value of the review checkbox
  bool valuefirst = false;

  /// Value of the type-of-request dropdown
  String dropdownValue = "Bug";

  /// HTTP Post created once one is created.
  Future post;

  /// Value of the title TextField. Represents the title of the bug/feature
  /// that the user is requesting.
  String title = "";

  /// Value of the description TextField. Represents the description of the
  /// bug/feature that the user is requesting.
  String description = "";

  // The POST URL that the GitHub API submits to.
  String postUrl =
      "https://api.github.com/repos/sirmammingtonham/smartrider/issues";

  /// Builds the IssueRequest page.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      // Background color of app.
      backgroundColor: Theme.of(context).backgroundColor,
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
                child:
                    Text('< BACK', style: Theme.of(context).textTheme.button)),
          ],
        ),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Text("Title:", style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
            ),
            Text("Enter a brief description of your request.",
                style: Theme.of(context).textTheme.bodyText1),
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
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.bodyText1.color),
                onSubmitted: (value) {
                  title = value;
                })),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Text(
              "Description:",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
        Row(
          children: [
            new Padding(
              /// WARNING: padding should be fixed to adjust to screen width.
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
            ),
            Text("Summarize your request.",
                style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
        // Contains TextField and styling for the issue title.
        Container(
            width: 330.0,
            child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                maxLines: null,
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.bodyText1.color),
                onChanged: (value) {
                  description = value;
                })),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
        ),
        Text("This is a:",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
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
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
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
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Checkbox(
              checkColor: Theme.of(context).buttonColor,
              activeColor: Theme.of(context).focusColor,
              focusColor: Theme.of(context).focusColor,
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
            child: Text(
              'SUBMIT REQUEST',
              style: Theme.of(context).textTheme.button,
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
