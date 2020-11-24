// ui stuff
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    // CupertinoNavigationBar(brightness: Theme.of(context).brightness);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight, //background of entire sheet
        appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0),
          ),
        ),
          backgroundColor: Theme.of(context).bottomAppBarColor,
          centerTitle: true,
          // first down arrow
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).primaryColor,
            tooltip: 'Go back',
            onPressed: () {
              Navigator.pop(context);
            },
          )),
                        
                        
            /*IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).primaryColor,
            tooltip: 'Go back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),*/
          // title
          title: Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 32),
          ),
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text(
                    'General',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor, fontSize: 24),
                  )),
                ),
              ),
              cardBuilder([
                SwitchListTile(
                  activeColor: Theme.of(context).toggleableActiveColor,
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
                      activeColor: Theme.of(context).toggleableActiveColor,
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
                      activeColor: Theme.of(context).toggleableActiveColor,
                        title: Text(key),
                        value: state.shuttles[key],
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
                      activeColor: Theme.of(context).toggleableActiveColor,
                        title: Text(key),
                        value: state.buses[key],
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
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Center(
                  child: Text(
                    'Safe Ride Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              /*
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
              )*/
            ])));
  }
}
