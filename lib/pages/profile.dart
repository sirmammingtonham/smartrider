import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:smartrider/widgets/search_bar.dart';

import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

/// Represents the physical profile page.
class ProfilePage extends StatefulWidget {
  final String role; // Decides what role the user has (student, etc.)
  final String email; // The user's email that is linked to their account.
  final String name; // Name of the user.
  ProfilePage(
      {this.title,
      @required this.name,
      @required this.role,
      @required this.email});
  final String title;

  /// Sets the state of the profile page.
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //This is for the futre
    // File _image; // Used only if you need a single picture

    // Future<String> uploadFile(File _image) async {
    //   StorageReference storageReference = FirebaseStorage.instance
    //       .ref()
    //       .child('profiles/${Path.basename(_image.path)}');
    //   StorageUploadTask uploadTask = storageReference.putFile(_image);
    //   await uploadTask.onComplete;
    //   print('File Uploaded');
    //   String returnURL;
    //   await storageReference.getDownloadURL().then((fileURL) {
    //     returnURL = fileURL;
    //   });
    //   return returnURL;
    // }

    // Future getImage(bool gallery) async {
    //   ImagePicker picker = ImagePicker();
    //   PickedFile pickedFile;
    //   // Let user select photo from gallery
    //   if (gallery) {
    //     pickedFile = await picker.getImage(
    //       source: ImageSource.gallery,
    //     );
    //   }
    //   // Otherwise open camera to get new photo
    //   else {
    //     pickedFile = await picker.getImage(
    //       source: ImageSource.camera,
    //     );
    //   }

    //   setState(() {
    //     if (pickedFile != null) {
    //       _image =
    //           File(pickedFile.path); // Use if you only need a single picture
    //       uploadFile(_image);
    //     } else {
    //       print('No image selected.');
    //     }
    //   });
    // }

    return MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ), // adds space between button and lower bezel
              Row(children: <Widget>[
                // Back button
                RaisedButton(
                    child: Text(
                      '< BACK',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0))),

                // Adds space between BACK button and SIGN OUT button.
                new Padding(
                  /// WARNING: padding should be fixed to adjust to screen width.
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                ),
                // Sign Out button
                RaisedButton(
                    child: Text(
                      'SIGN OUT',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        AuthenticationLoggedOut(),
                      );
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)))
              ]),
              // Space between row buttons and profile header
              new Padding(
                /// WARNING: padding should be fixed to adjust to screen width.
                padding: const EdgeInsets.symmetric(vertical: 40.0),
              ),

              // Controls overflow between profile pic and container.
              new Stack(
                children: <Widget>[
                  // Profile Header
                  Container(
                      color: Theme.of(context).buttonColor,
                      width: double.infinity,
                      height: 175.0,
                      child: Column(
                        children: [
                          // Spacing below text
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 45.0)),
                          // Profile greeting text
                          Center(
                              child: Text(
                            'Hello, ' + widget.role,
                            style:
                                TextStyle(color: Colors.grey[50], fontSize: 50),
                          )),
                        ],
                      )),
                  // Controls where the profile picture is compare to the profile
                  // greeting.
                  new Positioned(
                    left: 130.0,
                    bottom: 110,
                    // Profile picture.
                    child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.purple,
                        child: Text(username,
                            style: TextStyle(fontSize: 60, color: Colors.white))
                        //Text('JS', style: TextStyle(color: Colors.white70)),
                        ),
                    // CircularProfileAvatar(
                    //   'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                    //   radius: 35, // sets radius, default 50.0
                    //   backgroundColor: Colors
                    //       .transparent, // sets background color, default Colors.white
                    //   //borderWidth: 5, // sets border, default 0.0
                    //   initialsText: Text(
                    //     "Change profile",
                    //     style: TextStyle(
                    //         fontSize: 12, color: Colors.white.withOpacity(0.8)),
                    //     textAlign: TextAlign.center,
                    //   ), // sets initials text, set your own style, default Text('')
                    //   borderColor:
                    //       Colors.black, // sets border color, default Colors.white
                    //   elevation:
                    //       5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                    //   foregroundColor: Colors.black.withOpacity(
                    //       0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                    //   cacheImage:
                    //       true, // allow widget to cache image against provided url
                    //   onTap: () {
                    //     getImage(false);
                    //   }, // sets on tap
                    //   showInitialTextAbovePicture:
                    //       true, // setting it true will show initials text above profile picture, default false
                    // )
                  ),
                ],
                // Profile pic overflows Stack. Keeps top portion of profile pic
                // visible to user.
                overflow: Overflow.visible,
              ),
              // List of attributes on the user's profile
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: ListView(
                    // Keeps list from scrolling (if more attributes are added,
                    // we should make the profile page scrollable and reveal
                    // the action buttons as the user scrolls down)
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    children: <Widget>[
                      // Describes the role
                      ListTile(
                          title: Text("Role"),
                          subtitle: Text(widget.role),
                          leading: this.determinerole(widget.role)
                              ? Icon(Icons.book)
                              : Icon(Icons.drive_eta)),
                      // Describes the user's email
                      ListTile(
                        title: Text("Email"),
                        leading: Icon(Icons.email),
                        subtitle: Text(widget.email),
                      )
                    ],
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ), // adds space between attributes and action buttons
              // Change Password Button
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 95.0),
                  child: Text(
                    'CHANGE PASSWORD',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    // TO DO: What to do when the user wants to change their
                    // password?
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              // Report Bug Button
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 119.0),
                  child: Text(
                    'REPORT BUG',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    launch(
                        'https://github.com/sirmammingtonham/smartrider/issues/new?assignees=&labels=bug&template=bug-report---.md&title=%F0%9F%90%9B+Bug+Report%3A+%5BIssue+Title%5D');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              // Request Feature Button
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Text(
                    'REQUEST FEATURE',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    launch(
                        'https://github.com/sirmammingtonham/smartrider/issues/new?assignees=&labels=enhancement&template=feature-request---.md&title=%F0%9F%92%A1+Feature+Request%3A+%5BRequest+Title%5D');
                    // TO DO: What to do when the user wants to request a
                    // feature for this app?
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              // Delete Account Button
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 102.0),
                  child: Text(
                    'DELETE ACCOUNT',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              "Are you sure you want to delete your account?"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Yes")),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No"))
                          ],
                        );
                      },
                    );
                    // TO DO: What to do when the user wants to delete their
                    // account?
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              // Adds space between action buttons and bottom of screen.
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),
            ],
          ),
        ),
        theme: Theme.of(context));
  }

  /// Determines the assigned role that the user has.
  determinerole(String r) {
    if (r[0] == 'S') {
      return true;
    } else
      return false;
  }
}
