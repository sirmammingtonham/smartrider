<<<<<<< HEAD
// ui stuff
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

// settings and login stuff
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/blocs/authentication/data/authentication_repository.dart';

// bloc stuff
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

//showcase stuff
// import 'package:smartrider/ui/home.dart';
// import 'package:showcaseview/showcaseview.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // adding placeholder vars for now, replace these with sharedprefs
  Map<String, bool>? prefsData;

  AuthenticationRepository auth = AuthenticationRepository.create();

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
    return BlocBuilder<PrefsBloc, PrefsState>(builder: (context, state) {
      if (state is PrefsLoadingState) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state is PrefsLoadedState) {
        return SettingsWidget(
            state: state, auth: auth, setState: () => setState(() {}));
      } else if (state is PrefsSavingState) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const Center(child: Text('uh oh'));
      }
    });
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    Key? key,
    required this.state,
    required this.auth,
    required this.setState,
  }) : super(key: key);
  final PrefsLoadedState state;
  final AuthenticationRepository auth;
  final VoidCallback setState;

  /*
  A function that builds a rounded box that contains a list of
  keys from a given map to change a boolean variable.
  */
  Widget cardBuilder(List<Widget> switchList) {
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
            child: Column(children: switchList),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        ),
        body: ListView(children: <Widget>[
          // GENERAL SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    'General',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.5.sp),
                  )),
            ),
          ),
          cardBuilder([
            SwitchListTile(
              title:
                  Text('Push Notifications', style: TextStyle(fontSize: 12.sp)),
              value: state.prefs.getBool('pushNotifications')!,
              onChanged: (bool value) {
                state.prefs.setBool('pushNotifications', value);
                setState();
              },
              secondary: const Icon(Icons.notifications),
            ),
            Builder(
                builder: (context) => SwitchListTile(
                      // activeColor: Theme.of(context).toggleableActiveColor,
                      title:
                          Text('Lights Out', style: TextStyle(fontSize: 12.sp)),
                      value: state.prefs.getBool('darkMode')!,
                      onChanged: (bool value) {
                        state.prefs.setBool('darkMode', value);
                        BlocProvider.of<PrefsBloc>(context)
                            .add(ThemeChangedEvent(value));
                        setState();
                      },
                      secondary: const Icon(Icons.lightbulb_outline),
                    ))
          ]),
          // SHUTTLE SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Shuttle Settings',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.5.sp),
              ),
            ),
          ),
          if (state.shuttles.keys.isEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                    child: Text(
                      'Shuttles are not loaded, try switching views to load',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11.sp),
                    ),
                  ),
                ),
              ),
            ),
          cardBuilder(state.shuttles.keys
              .map((key) => SwitchListTile(
                    title: Text(key),
                    value: state.shuttles[key]!,
                    onChanged: (bool value) {
                      state.shuttles[key] = value;
                      BlocProvider.of<PrefsBloc>(context)
                          .add(SavePrefsEvent(key, value));
                      setState();
                    },
                    secondary: const Icon(Icons.directions_bus),
                  ))
              .toList()),

          // BUS SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Bus Settings',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.5.sp),
              ),
            ),
          ),
          cardBuilder(state.buses.keys
              .map((key) => SwitchListTile(
                    title: Text(PrefsBloc.busIdMap[key]!,
                        style: TextStyle(fontSize: 12.sp)),
                    value: state.buses[key]!,
                    onChanged: (bool value) {
                      state.buses[key] = value;
                      BlocProvider.of<PrefsBloc>(context)
                          .add(SavePrefsEvent(key, value));
                      setState();
                    },
                    secondary: const Icon(Icons.directions_bus),
                  ))
              .toList()),

          // SAFE RIDE SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Safe Ride Settings',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.5.sp),
              ),
            ),
          ),
          SizedBox(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          AuthenticationSignOutEvent(),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      child: const Text(
                        'SIGN OUT',
                        // style: Theme.of(context).textTheme.button,
                      )),
                ),
              ],
            ),
          )
        ]));
  }
}
=======
// ui stuff
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:sizer/sizer.dart';

// settings and login stuff
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/blocs/authentication/data/authentication_repository.dart';

// bloc stuff
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

import 'package:smartrider/ui/issue_request.dart';

//showcase stuff
// import 'package:smartrider/ui/home.dart';
// import 'package:showcaseview/showcaseview.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // adding placeholder vars for now, replace these with sharedprefs
  Map<String, bool>? prefsData;

  AuthenticationRepository auth = AuthenticationRepository.create();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// TODO: add bloclistener for authentication, model on profile.dart
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrefsBloc, PrefsState>(builder: (context, state) {
      if (state is PrefsLoadingState) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state is PrefsLoadedState) {
        return SettingsWidget(
            state: state, auth: auth, setState: () => setState(() {}));
      } else if (state is PrefsSavingState) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const Center(child: Text('uh oh'));
      }
    });
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    Key? key,
    required this.state,
    required this.auth,
    required this.setState,
  }) : super(key: key);
  final PrefsLoadedState state;
  final AuthenticationRepository auth;
  final VoidCallback setState;

  /*
  A function that builds a rounded box that contains a list of
  keys from a given map to change a boolean variable.
  */
  Widget cardBuilder(List<Widget> switchList) {
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
            child: Column(children: switchList),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: ListView(children: <Widget>[
          // GENERAL SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    'General',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  )),
            ),
          ),
          cardBuilder([
            SwitchListTile(
              title: Text('Push Notifications', style: TextStyle(fontSize: 16)),
              value: state.prefs.getBool('pushNotifications')!,
              onChanged: (bool value) {
                state.prefs.setBool('pushNotifications', value);
                setState();
              },
              secondary: const Icon(Icons.notifications),
            ),
            Builder(
                builder: (context) => SwitchListTile(
                      // activeColor: Theme.of(context).toggleableActiveColor,
                      title: Text('Lights Out', style: TextStyle(fontSize: 12)),
                      value: state.prefs.getBool('darkMode')!,
                      onChanged: (bool value) {
                        state.prefs.setBool('darkMode', value);
                        BlocProvider.of<PrefsBloc>(context)
                            .add(ThemeChangedEvent(value));
                        setState();
                      },
                      secondary: const Icon(Icons.lightbulb_outline),
                    ))
          ]),
          // SHUTTLE SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Shuttle Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          if (state.shuttles.keys.isEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                    child: Text(
                      'Shuttles are not loaded, try switching views to load',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          cardBuilder(state.shuttles.keys
              .map((key) => SwitchListTile(
                    title: Text(key),
                    value: state.shuttles[key]!,
                    onChanged: (bool value) {
                      state.shuttles[key] = value;
                      BlocProvider.of<PrefsBloc>(context)
                          .add(SavePrefsEvent(key, value));
                      setState();
                    },
                    secondary: const Icon(Icons.directions_bus),
                  ))
              .toList()),

          // BUS SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Bus Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          cardBuilder(state.buses.keys
              .map((key) => SwitchListTile(
                    title: Text(PrefsBloc.busIdMap[key]!,
                        style: TextStyle(fontSize: 12)),
                    value: state.buses[key]!,
                    onChanged: (bool value) {
                      state.buses[key] = value;
                      BlocProvider.of<PrefsBloc>(context)
                          .add(SavePrefsEvent(key, value));
                      setState();
                    },
                    secondary: const Icon(Icons.directions_bus),
                  ))
              .toList()),

          // SAFE RIDE SETTINGS
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Safe Ride Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Center(
              child: Text(
                'Profile Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          cardBuilder([
            getButton(
              text: 'CHANGE PHONE NUMBER',
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
            ),
            getButton(
              text: 'CHANGE PASSWORD',
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
            ),
            // Report Bug Button
            getButton(
              text: 'REPORT BUG / REQUEST FEATURE',
              onPressed: () {
                // launch('https://github.com/sirmammingtonham/smartrider/issues/new?assignees=&labels=bug&template=bug-report---.md&title=%F0%9F%90%9B+Bug+Report%3A+%5BIssue+Title%5D');
                Navigator.push<IssueRequest>(
                  context,
                  MaterialPageRoute(builder: (context) => const IssueRequest()),
                );
              },
            ),
            // Delete Account Button
            getButton(
              text: 'DELETE ACCOUNT',
              onPressed: () {
                //Show a box to ask user if they really want to delete their
                //account
                showDialog<AlertDialog>(
                  context: context,
                  barrierDismissible: false, // user doesn't need to tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                          'Are you sure you want to delete your account?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              //If the user chooses yes, we will call the
                              //authentification delete function
                              BlocProvider.of<AuthenticationBloc>(context).add(
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
            ),
          ]),

          SizedBox(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          AuthenticationSignOutEvent(),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      child: const Text(
                        'SIGN OUT',
                        // style: Theme.of(context).textTheme.button,
                      )),
                ),
              ],
            ),
          )
        ]));
    
  }
  ElevatedButton getButton({
    required String text,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          // padding: const EdgeInsets.symmetric(horizontal: 95.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      child: Text(text),
    );
  }
}
>>>>>>> ab7bf516a6409dbc86fbdf48ab1bb06fe165ea64
