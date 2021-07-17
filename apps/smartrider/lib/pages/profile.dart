// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:smartrider/widgets/search_bar.dart';

// import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
// import 'package:image_picker/image_picker.dart'; // For Image Picker
// import 'package:path/path.dart' as Path;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'dart:io';
import 'package:smartrider/pages/issue_request.dart';

/// Used to display the profile options.
abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

/// Represents the physical profile page.
class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key,
      this.title,
      required this.name,
      required this.role,
      required this.email})
      : super(key: key);

  final String? role; // Decides what role the user has (student, etc.)
  final String? email; // The user's email that is linked to their account.
  final String? name; // Name of the user.
  final String? title;

  /// Sets the state of the profile page.
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// Represents the current state of the Profile Page
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

    // FOR THE FUTURE: The easiest way so far to load the background image as
    // a URL. For now, I have hardcoded a profile picture just for the value.
    // The user's profile picture should be stored in FireBase. Then, after it
    // is stored, whenever the profile page is clicked, there should be a call
    // to the database with the link of the profile pic. Replace _profilePic
    // with that result.

    var _profilePic = '';
    return MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ), // adds space between button and lower bezel
              Row(children: <Widget>[
                // Back button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  child: Text(
                    '< BACK',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),

                // Adds space between BACK button and SIGN OUT button.
                const Padding(
                  /// WARNING: padding should be fixed to adjust to screen width.
                  padding: EdgeInsets.symmetric(horizontal: 100.0),
                ),
                // Sign Out button
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationLoggedOut(),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  child: Text(
                    'SIGN OUT',
                    style: Theme.of(context).textTheme.button,
                  ),
                )
              ]),
              // Space between row buttons and profile header
              const Padding(
                /// WARNING: padding should be fixed to adjust to screen width.
                padding: EdgeInsets.symmetric(vertical: 40.0),
              ),

              // Controls overflow between profile pic and container.
              Stack(clipBehavior: Clip.none, children: <Widget>[
                // Profile Header
                Container(
                    color: Theme.of(context).hoverColor,
                    width: double.infinity,
                    height: 175.0,
                    child: Column(
                      children: [
                        // Spacing below text
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 45.0)),
                        // Profile greeting text
                        Center(
                            child: Text(
                          'Hello, ${widget.role!}',
                          style: Theme.of(context).textTheme.headline3,
                        )),
                      ],
                    )),
                // Controls where the profile picture is compare to the profile
                // greeting.
                Positioned(
                  left: 130.0,
                  bottom: 110,
                  // Profile picture.
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).backgroundColor,
                      backgroundImage: NetworkImage(_profilePic),
                      child: (_profilePic == '')
                          ? Text(username,
                              style: TextStyle(
                                  fontSize: 60,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color))
                          : null),
                ),
              ]),
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
                          title: const Text('Role'),
                          subtitle: Text(widget.role!),
                          leading: determinerole(widget.role!)
                              ? const Icon(Icons.book)
                              : const Icon(Icons.drive_eta)),
                      // Describes the user's email
                      ListTile(
                        title: const Text('Email'),
                        leading: const Icon(Icons.email),
                        subtitle: Text(widget.email!),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ), // adds space between attributes and action buttons
              // Change Password Button
              ElevatedButton(
                  onPressed: () {
                    //Send an email to the user to request a password change
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthentificationResetPass(email),
                    );
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationLoggedOut(),
                    );
                    Navigator.of(context).pop();
                    // Will show a small pop up to tell users the email has been sent
                    showDialog<AlertDialog>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text('Email has been sent'),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 95.0),
                  ),
                  child: Text(
                    'CHANGE PASSWORD',
                    style: Theme.of(context).textTheme.button,
                  )),
              // Report Bug Button
              ElevatedButton(
                  onPressed: () {
                    // launch(
                    //'https://github.com/sirmammingtonham/smartrider/issues/new?assignees=&labels=bug&template=bug-report---.md&title=%F0%9F%90%9B+Bug+Report%3A+%5BIssue+Title%5D');
                    Navigator.push<IssueRequest>(
                      context,
                      MaterialPageRoute(builder: (context) => IssueRequest()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 53.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  child: Text(
                    'REPORT BUG / REQUEST FEATURE',
                    style: Theme.of(context).textTheme.button,
                  )),
              // Delete Account Button
              ElevatedButton(
                  onPressed: () {
                    //Show a box to ask user if they really want to delete their account
                    showDialog<AlertDialog>(
                      context: context,
                      barrierDismissible:
                          false, // user doesn't need to tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete your account?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  //If the user chooses yes, we will call the authentification delete function
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    AuthenticationDelete(),
                                  );
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  showDialog<AlertDialog>(
                                    context: context,
                                    barrierDismissible:
                                        true, // user must tap button!
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text('Account has been deleted'),
                                      );
                                    },
                                  );
                                },
                                child: const Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'))
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 102.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  child: Text(
                    'DELETE ACCOUNT',
                    style: Theme.of(context).textTheme.button,
                  )),
              // Adds space between action buttons and bottom of screen.
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
            ],
          ),
        ),
        theme: Theme.of(context));
  }

  /// Determines the assigned role that the user has.
  bool determinerole(String r) {
    if (r[0] == 'S') {
      return true;
    } else {
      return false;
    }
  }
}
