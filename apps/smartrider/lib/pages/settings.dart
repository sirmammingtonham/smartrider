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
// import 'package:smartrider/pages/home.dart';
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
