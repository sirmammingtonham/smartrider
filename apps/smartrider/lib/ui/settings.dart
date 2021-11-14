import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/util/multi_bloc_builder.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/blocs/authentication/data/authentication_repository.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/ui/issue_request.dart';
import 'package:sms_autofill/sms_autofill.dart';

//showcase stuff
// import 'package:smartrider/ui/home.dart';
// import 'package:showcaseview/showcaseview.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  // adding placeholder vars for now, replace these with sharedprefs
  // final AuthenticationRepository auth = AuthenticationRepository.create();
  bool _loadingShuttle = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

/*
  A function that builds a rounded box that contains a list of
  keys from a given map to change a boolean variable.
  */
  Widget cardBuilder(List<Widget> widgets) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Column(children: widgets),
          ),
        ),
      ),
    );
  }

  ListTile getButton({
    required String text,
    required void Function() onPressed,
    required Icon icon,
  }) {
    return ListTile(
      onTap: onPressed,
      leading: icon,
      trailing: const Icon(Icons.chevron_right),
      title: Text(text),
    );
  }

  Future<AlertDialog?> changePhoneDialog() {
    final _formKey = GlobalKey<FormState>();
    final _textFieldController = TextEditingController();

    bool submit(String str) {
      if (_formKey.currentState!.validate()) {
        SmsAutoFill().listenForCode();
        BlocProvider.of<AuthenticationBloc>(
          context,
        ).add(
          AuthenticationResetPhoneEvent(
            newPhoneNumber: str.trim(),
          ),
        );
        return true;
      }
      return false;
    }

    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change/Verify Phone Number'),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
          actions: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '+x xxx-xxx-xxxx',
                  hintText: 'Enter Phone Number',
                ),
                validator: (String? value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (AuthenticationRepository.phoneRegex.hasMatch(value)) {
                    return null;
                  } else {
                    return 'Please enter a valid phone number';
                  }
                },
                controller: _textFieldController,
                onFieldSubmitted: submit,
              ),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  if (submit(_textFieldController.text)) {
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Future<AlertDialog?> deleteAccountDialog() {
  //   //Show a box to ask user if
  //   //they really want to delete their account
  //   return showDialog<AlertDialog>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Are you sure you want '
  //           'to delete your account?',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               //If the user chooses yes, we will call the authentification delete function
  //               BlocProvider.of<AuthenticationBloc>(
  //                 context,
  //               ).add(
  //                 AuthenticationDeleteEvent(),
  //               );
  //               Navigator.of(context).pop();
  //               showDialog<AlertDialog>(
  //                 context: context,
  //                 barrierDismissible: true, // user must tap button!
  //                 builder: (BuildContext context) {
  //                   return const AlertDialog(
  //                     title: Text(
  //                       'Account has been deleted',
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //             child: const Text('Yes'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('No'),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

// TODO: add bloclistener for authentication, model on profile.dart
  @override
  Widget build(BuildContext context) {
    void submit(String code, String verificationId) {
      BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationPhoneSMSCodeEnteredEvent(
          verificationId: verificationId,
          sms: code,
        ),
      );
      Navigator.pop(context);
    }

    final _textFieldController = TextEditingController();

    return BlocListener(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      listener: (context, state) async {
        if (state is AuthenticationVerifyPhoneState) {
          await showDialog<AlertDialog>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enter Verification Code'),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
                actions: [
                  PinFieldAutoFill(
                    controller: _textFieldController,
                    decoration: BoxLooseDecoration(
                      strokeColorBuilder: FixedColorBuilder(
                        Theme.of(context).colorScheme.onBackground,
                      ),
                      textStyle: Theme.of(context).textTheme.bodyText1,
                    ),
                    onCodeSubmitted: (String code) =>
                        submit(code, state.verificationId),
                  ),
                  TextButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      submit(_textFieldController.text, state.verificationId);
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } else if (state is AuthenticationFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Phone number verification failed. '
                'Code: ${(state.exception! as FirebaseAuthException).code}. '
                'Message: ${state.message}',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
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
            ),
          ),
          // title
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: MultiBlocBuilder(
          blocs: [
            BlocProvider.of<AuthenticationBloc>(context),
            BlocProvider.of<PrefsBloc>(context),
          ],
          builder: (context, states) {
            final authState = states.get<AuthenticationState>();
            final prefsState = states.get<PrefsState>();
            switch (prefsState.runtimeType) {
              case PrefsLoadingState:
                return const Center(child: CircularProgressIndicator());
              case PrefsLoadedState:
                return ListView(
                  children: <Widget>[
                    // Conditional verify phone number
                    if (authState is AuthenticationSignedInState &&
                        !authState.user.phoneVerified) ...[
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              'Verification',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      cardBuilder([
                        getButton(
                          text: 'Verify Phone Number',
                          icon: const Icon(Icons.mobile_friendly),
                          onPressed: changePhoneDialog,
                        ),
                      ]),
                    ],
                    // GENERAL SETTINGS
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    cardBuilder([
                      SwitchListTile(
                        title: const Text('Push Notifications'),
                        value: (prefsState as PrefsLoadedState)
                            .prefs
                            .getBool('pushNotifications')!,
                        onChanged: (bool value) {
                          prefsState.prefs.setBool('pushNotifications', value);
                          setState(() {});
                        },
                        secondary: const Icon(Icons.notifications),
                      ),
                    ]),
                    // // SAFE RIDE SETTINGS
                    // Container(
                    //   margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                    //   child: const Center(
                    //     child: Text(
                    //       'Safe Ride Settings',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold, fontSize: 28),
                    //     ),
                    //   ),
                    // ),
                    // cardBuilder([
                    //   SwitchListTile(
                    //     title: const Text('placeholder'),
                    //     value: true,
                    //     onChanged: (bool value) {
                    //       setState(() {});
                    //     },
                    //     secondary: const Icon(Icons.local_taxi),
                    //   ),
                    //   SwitchListTile(
                    //     title: const Text('placeholder'),
                    //     value: false,
                    //     onChanged: (bool value) {
                    //       setState(() {});
                    //     },
                    //     secondary: const Icon(Icons.local_taxi),
                    //   ),
                    // ]),
                    // BUS SETTINGS
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: const Center(
                        child: Text(
                          'Bus Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    cardBuilder(
                      prefsState.buses.keys
                          .map(
                            (key) => SwitchListTile(
                              title: Text(PrefsBloc.busIdMap[key]!),
                              value: prefsState.buses[key]!,
                              onChanged: (bool value) {
                                prefsState.buses[key] = value;
                                BlocProvider.of<PrefsBloc>(context)
                                    .add(SavePrefsEvent(key, value));
                                setState(() {});
                              },
                              secondary: const Icon(Icons.directions_bus),
                            ),
                          )
                          .toList(),
                    ),
                    // SHUTTLE SETTINGS
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: const Center(
                        child: Text(
                          'Shuttle Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    if (prefsState.shuttles.keys.isEmpty)
                      cardBuilder([
                        ListTile(
                          title: const Text('Tap to load shuttles'),
                          onTap: () {
                            BlocProvider.of<MapBloc>(context).add(
                              const MapViewChangeEvent(
                                newView: MapView.kShuttleView,
                              ),
                            );
                            _loadingShuttle = true;
                            setState(() {});
                          },
                          leading: const Icon(Icons.airport_shuttle),
                          trailing: _loadingShuttle
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.chevron_right),
                        )
                      ])
                    else
                      cardBuilder(
                        prefsState.shuttles.keys
                            .map(
                              (key) => SwitchListTile(
                                title: Text(key),
                                value: prefsState.shuttles[key]!,
                                onChanged: (bool value) {
                                  prefsState.shuttles[key] = value;
                                  BlocProvider.of<PrefsBloc>(context)
                                      .add(SavePrefsEvent(key, value));
                                  setState(() {});
                                },
                                secondary: const Icon(Icons.airport_shuttle),
                              ),
                            )
                            .toList(),
                      ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: const Center(
                        child: Text(
                          'Profile Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    cardBuilder([
                      getButton(
                        text: 'Change Phone Number',
                        icon: const Icon(Icons.phone),
                        onPressed: changePhoneDialog,
                      ),
                      // getButton(
                      //   text: 'Change Password',
                      //   icon: const Icon(Icons.password),
                      //   onPressed: () {
                      //     //Send an email to the user to request a password change
                      //     BlocProvider.of<AuthenticationBloc>(context).add(
                      //       AuthenticationResetPasswordEvent(),
                      //     );
                      //     BlocProvider.of<AuthenticationBloc>(context).add(
                      //       AuthenticationSignOutEvent(),
                      //     );
                      //     Navigator.of(context).pop();
                      //     // Will show a small pop up
                      //     //to tell users the email has been sent
                      //     showDialog<AlertDialog>(
                      //       context: context,
                      //       barrierDismissible: true, // user must tap button!
                      //       builder: (BuildContext context) {
                      //         return const AlertDialog(
                      //           title: Text('Email has been sent'),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // Report Bug Button
                      getButton(
                        text: 'Report Bug / Request Feature',
                        icon: const Icon(Icons.bug_report),
                        onPressed: () {
                          // launch('https://github.com/sirmammingtonham/smartrider/issues/new?assignees=&labels=bug&template=bug-report---.md&title=%F0%9F%90%9B+Bug+Report%3A+%5BIssue+Title%5D');
                          Navigator.push<IssueRequest>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IssueRequest(),
                            ),
                          );
                        },
                      ),
                      // // Delete Account Button
                      // getButton(
                      //   text: 'Delete Account',
                      //   icon: const Icon(Icons.delete),
                      //   onPressed: deleteAccountDialog,
                      // ),
                    ]),

                    SizedBox(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  AuthenticationSignOutEvent(),
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'SIGN OUT',
                                // style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              default:
                return const Center(child: Text('uh oh'));
            }
          },
        ),
      ),
    );
  }
}
