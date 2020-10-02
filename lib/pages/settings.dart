// ui stuff
import 'package:flutter/material.dart';

// settings and login stuff
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';

// bloc stuff
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // adding placeholder vars for now, replace these with sharedprefs!
  Map<String, bool> prefsData;

  AuthRepository auth = AuthRepository();

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
      // print(state);
      if (state is PrefsLoadingState) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state is PrefsLoadedState) {
        // var prefs = state.prefs.getMapping;
        return SettingsWidget(
            state: state, auth: auth, setState: () => setState(() {}));
      } else if (state is PrefsSavingState) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Center(child: Text("uh oh"));
      }
    });
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    @required this.state,
    @required this.auth,
    @required this.setState,
  }) : super();
  final PrefsLoadedState state;
  final AuthRepository auth;
  final VoidCallback setState;

  Widget cardBuilder(switchList) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
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
          centerTitle: true,
          // first down arrow
          leading: IconButton(
            icon: Icon(Icons.arrow_downward),
            tooltip: 'Go back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // title
          title: Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          // second down arrow
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_downward),
              tooltip: 'Go back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: NotificationListener<OverscrollNotification>(
            onNotification: (t) {
              if (t.overscroll < -15) {
                Navigator.pop(context);
                return true;
              }
              return false;
            },
            child: ListView(children: <Widget>[
              // GENERAL SETTINGS
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Center(
                  child: Text(
                    'General',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              cardBuilder([
                SwitchListTile(
                  title: Text('Push Notifications'),
                  value: state.prefs.getBool('pushNotifications'),
                  onChanged: (bool value) {
                    state.prefs.setBool('pushNotifications', value);
                    setState();
                  },
                  secondary: const Icon(Icons.notifications),
                ),
                Builder(
                    builder: (context) => SwitchListTile(
                          title: Text('Lights Out'),
                          value: state.prefs.getBool('darkMode'),
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
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Center(
                  child: Text(
                    'Shuttle Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              cardBuilder(state.shuttles.keys
                  .map((key) => SwitchListTile(
                        title: Text(key),
                        value: state.shuttles[key],
                        onChanged: (bool value) {
                          state.shuttles[key] = value;
                          setState();
                        },
                        secondary: const Icon(Icons.directions_bus),
                      ))
                  .toList()),

              // BUS SETTINGS
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Center(
                  child: Text(
                    'Bus Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              cardBuilder(state.buses.keys
                  .map((key) => SwitchListTile(
                        title: Text(key),
                        value: state.buses[key],
                        onChanged: (bool value) {
                          state.buses[key] = value;
                          setState();
                        },
                        secondary: const Icon(Icons.directions_bus),
                      ))
                  .toList()),

              // SAFE RIDE SETTINGS
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Center(
                  child: Text(
                    'Safe Ride Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: RaisedButton(
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
                              borderRadius: new BorderRadius.circular(20.0))),
                    ),
                  ],
                ),
              )
            ])));
  }
}
