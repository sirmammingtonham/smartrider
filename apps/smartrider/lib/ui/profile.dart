// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:smartrider/ui/widgets/search_bar.dart';

// import 'package:firebase_storage/firebase_storage.dart'; // For File Upload
// To Firestore import 'package:image_picker/image_picker.dart'; // For Image
// Picker import 'package:path/path.dart' as Path; import
// 'package:cloud_firestore/cloud_firestore.dart'; import
// 'package:url_launcher/url_launcher.dart';
// import 'package:sizer/sizer.dart';

// import 'dart:io';
import 'package:smartrider/ui/issue_request.dart';

/// Used to display the profile options.
abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}
// TODO: change phone number, verify phone number
// TODO: Remove phone number from login, have saferide search bar locked until they put in phone, verify

/// Represents the physical profile page.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.initials,
  }) : super(key: key);

  final String initials;

  /// Sets the state of the profile page.
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

Widget cardBuilder(List<Widget> buttonList) {
  return Container(
    margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
    child: Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Center(
          child: Column(children: buttonList),
        ),
      ),
    ),
  );
}

// TODO: use sizer to fix button layout/sizes
// TODO: fix background colors/shading
/// Represents the current state of the Profile Page
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<AuthenticationBloc>(context),
        listener: (context, state) async {
          if (state is AuthenticationVerifyPhoneState) {
            await showDialog<Dialog>(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      child: Card(
                          child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter SMS Code',
                        hintText: 'Enter SMS Code'),
                    onFieldSubmitted: (String str) {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                          AuthenticationPhoneSMSCodeEnteredEvent(
                              verificationId: state.verificationId, sms: str));
                      Navigator.pop(context);
                    },
                  )));
                });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15.0),
              ),
            ),
            centerTitle: true,
            // first down arrow
            leading: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  tooltip: 'Go back',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            // title
            title: Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ), // adds space between button and lower bezel

              // Adds space between BACK button and SIGN OUT button.
              Padding(
                /// WARNING: padding should be fixed to adjust to screen
                /// width.
                padding: EdgeInsets.symmetric(horizontal: 82),
              ),
              // Sign Out button

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
                          'Email',
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
                  child: Hero(
                    tag: 'circleAvatar',
                    child: CircleAvatar(
                        radius: 60,
                        child: Text(widget.initials,
                            style: TextStyle(
                                fontSize: 60,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color))),
                  ),
                ),
              ]),
              // List of attributes on the user's profile
              // Change Password Button
              ElevatedButton(
                  onPressed: () async {
                    await showDialog<Dialog>(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Card(
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter Phone Number',
                                      hintText: 'Enter Phone Number'),
                                  onFieldSubmitted: (String str) {
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(AuthenticationResetPhoneEvent(
                                            newPhoneNumber: str));
                                  }),
                            ),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 95.0),
                  ),
                  child: Text(
                    'CHANGE PHONE NUMBER',
                    style: Theme.of(context).textTheme.button,
                  )),
              ElevatedButton(
                  onPressed: () {
                    //Send an email to the user to request a password change
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationResetPasswordEvent(),
                    );
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationSignOutEvent(),
                    );
                    Navigator.of(context).pop();
                    // Will show a small pop up to tell users the email has been
                    // sent
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
                    // launch('https://github.com/sirmammingtonham/smartrider/issues/new?assignees=&labels=bug&template=bug-report---.md&title=%F0%9F%90%9B+Bug+Report%3A+%5BIssue+Title%5D');
                    Navigator.push<IssueRequest>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IssueRequest()),
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
                    //Show a box to ask user if they really want to delete their
                    //account
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
                                  //If the user chooses yes, we will call the
                                  //authentification delete function
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    AuthenticationDeleteEvent(),
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
        ));
  }

  /// Determines the assigned role that the user has.
  bool determinerole(String r) {
    return r[0] == 'S';
    // if (r[0] == 'S') {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
