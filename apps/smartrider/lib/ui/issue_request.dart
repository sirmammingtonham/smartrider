import 'dart:async';
// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:oauth2_client/oauth2_helper.dart'; import
// 'package:oauth2_client/github_oauth2_client.dart'; import
// 'package:shared/util/strings.dart';

/// Represents an HTTP POST, structure implemented to send the info needed to
/// create a GitHub API Post Request, to create an issue on the Github
/// repository.
class Post {
  /// Creates a Post Request, represented as an object.
  Post({this.title, this.body, this.labels});

  /// Creates a Post Object, given the title, body, and label structured as a
  /// map (or a JSON format).
  factory Post.fromJson(Map json) {
    return Post(
      title: json['title'] as String?,
      body: json['body'] as String?,
      labels: json['labels'] as String?,
    );
  }

  /// Title of the issue.
  final String? title;

  /// Description of the issue.
  final String? body;

  /// Tags for the issue (either userBug or userFeature).
  final String? labels;

  /// Returns a new Map object using values from this Post object.
  Map toMap() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    map['labels'] = labels;
    return map;
  }
}

/// Creates an HTTP Post Request, given the POST url and a JSON-organized file.
/// TODO: Make the POST request work with the GitHub API.
// Future createPost(String url, {Map body}) async {/// Creates the GitHub
//   OAuth2Client provided by Flutter's OAuth2 library var client =
//   OAuth2Helper(GitHubOAuth2Client(// Corresponds with the Android Scheme
//   (located in AndroidManifest.xml) customUriScheme: 'smartrider.app', //
//   Handles redirect URI after authorization redirectUri:
//   'smartrider.app://oauth2redirect'));

//   /// Gets the response from authenticating the request.
//   client.setAuthorizationParams(grantType: OAuth2Helper.AUTHORIZATION_CODE,
//   clientId: 'be5f78f24f2b3ede9699', clientSecret: GITHUB_API_SECRET, scopes:
//   ['repo']);

//   /// The client used to submit the authenticated HTTP Post Request. Future
//   resp = client.post(url, body: body); resp.then((value) => print(value));

//   return resp;
// }

/// The IssueRequest page lets the user enter a bug/feature request through the
/// app, rather than through the GitHub issue page. It can also allow us to add
/// more options that separates the user's bug/feature requests from the
/// developer's bug/feature requests.
class IssueRequest extends StatefulWidget {
  const IssueRequest({Key? key}) : super(key: key);

  /// Sets the state of the issue request page.
  @override
  _IssueRequestState createState() => _IssueRequestState();
}

/// Represents the current state of the Issue Request Page.
class _IssueRequestState extends State<IssueRequest> {
  /// Value of the review checkbox
  bool? valuefirst = false;

  /// Value of the type-of-request dropdown
  String? dropdownValue = 'Bug';

  /// HTTP Post created once one is created.
  Future? post;

  /// Value of the title TextField. Represents the title of the bug/feature that
  /// the user is requesting.
  String title = '';

  /// Value of the description TextField. Represents the description of the
  /// bug/feature that the user is requesting.
  String description = '';

  // The POST URL that the GitHub API submits to.
  String postUrl =
      'https://api.github.com/repos/sirmammingtonham/smartrider/issues';

  /// Builds the IssueRequest page.
  @override
  Widget build(BuildContext context) {
    // The body of the Issue Request page form
    return MaterialApp(
        home: Scaffold(
      // Controls the background color of the graph
      backgroundColor: Theme.of(context).backgroundColor,

      body: SingleChildScrollView(
          // Contains all of the elements within our Issue Request form,
          // organized in a column for layout purposes.
          child: Column(children: [
        // Vertical margin for elements.
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
        ),
        // Organizes back button in a Row layout.
        Row(
          children: [
            // Horizonal left margin between screen and back button.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            // Back button
            ElevatedButton(
                // Navigates back to profile page when clicked
                onPressed: () {
                  Navigator.pop(context);
                },
                // The appearance of the back button.
                child:
                    Text('< BACK', style: Theme.of(context).textTheme.button)),
          ],
        ),
        // Container for the title label, used for layout purposes
        Row(
          children: [
            // Left margin between screen and Title label.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            // Controls appearance of the title label.
            Text('Title:', style: Theme.of(context).textTheme.headline6),
          ],
        ),
        // Container for the title description label, used for layout purposes.
        Row(
          children: [
            // Left margin between screen and title description.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.0),
            ),
            // Controls appearance of the title description label.
            Text('Enter a brief description of your request.',
                style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
        // Vertical margin between title description label and input field.
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
        ),
        // Container for the title TextField, in which the user enters a title.
        SizedBox(
            // Proportions of the text field
            width: 330.0,
            height: 50.0,
            // Text Field object: user enters the title for their request. Will
            // eventually be mapped to the title entry in the HTTP POST request
            child: TextField(
                // Controls appearance of title TextField.
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.bodyText1!.color),
                // When changed, the TextField will store the current TextField
                // value to our title variable (which will eventually be sent as
                // the issue title.)
                onChanged: (value) {
                  title = value;
                })),
        // Container for Description title, for layout purposes.
        Row(
          children: [
            // Left margin between edge of screen and description title.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            // The actual description title label
            Text(
              'Description:',
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
        // Container for the Description label's description. Created for layout
        // purposes.
        Row(
          children: [
            // Left margin between edge of screen and the Description label's
            // description.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.0),
            ),
            // The actual description for the description
            Text('Summarize your request.',
                style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
        // Container for the description textfield
        SizedBox(
            // Dimensions of the description textfield. No height specified
            // since the description textfield is multi-line, and will adjust
            // for the user to see everything they type. If the textbox extends
            // the screen, it will become scrollable.
            width: 330.0,
            // TextField object: User enters the description of their
            // bug/feature, which will eventually be sent as the description
            // when that issue is created on GitHub.
            child: TextField(
                // Controls the appearance of the description textfield.
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                // Box will expand to accomodate the user's response (if it's
                // multi-line).
                maxLines: null,
                // Also controls the appearance of the description textfield.
                style: TextStyle(
                    color: Theme.of(context).accentTextTheme.bodyText1!.color),
                // When the user makes an edit to the description textfield, the
                // value that they type will be stored in our description
                // string.
                onChanged: (value) {
                  description = value;
                })),
        // Vertical margin between the description textfield and the dropdown
        // prompt.
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
        ),
        // Prompts the user to select Bug/Feature/Other option in their
        // dropdown.
        Text('This is a:',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)),
        // Dropdown for the user to select the type of issue request they are
        // making
        DropdownButton<String>(
            value: dropdownValue,
            items: <String>['Bug', 'Feature', 'Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // Controls what the dropdown looks like.
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
            // Changes the Dropdown appearance to display the user's choice.
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            }),
        // For layout purposes, contains the text and the checkbox used to make
        // sure the user is okay with us reaching out to them to explain more of
        // the issue.
        Row(
          children: <Widget>[
            // Left margin from edge to the text.
            const SizedBox(
              width: 10,
            ),
            // Contains the text that gives us consent to contact them if we
            // have any questions about their request.
            SizedBox(
              width: 300.0,
              child: Text(
                'By selecting the checkmark, you give the developers of '
                'SmartRider permission to contact you using your '
                'entered email address if a follow-up is necessary. '
                'Any other identifying information is to remain anonymous.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            // The checkbox next to the statement.
            Checkbox(
              checkColor: Theme.of(context).buttonColor,
              activeColor: Theme.of(context).focusColor,
              focusColor: Theme.of(context).focusColor,
              value: valuefirst,
              onChanged: (bool? value) {
                setState(() {
                  valuefirst = value;
                });
              },
            ),
          ],
        ),
        // Container for the submit request button.
        SizedBox(
          // Contains the button in a box.
          width: 350.0,
          // The submit request button itself.
          child: ElevatedButton(
            onPressed: () async {
              // Post newPost = new Post(title: title, body: description,
              //     labels: dropdownValue); // Sends the POST request to GitHub
              //     API: Post p = await createPost(postUrl, body:
              //     newPost.toMap());

              // Once the POST is submitted, we can leave the Issue Request
              // page.
              Navigator.pop(context);
            },
            child: Text(
              'SUBMIT REQUEST',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        )
      ])),
    ));
  }
}
