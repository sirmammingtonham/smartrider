// ui stuff
import 'package:flutter/material.dart';

// settings and login stuff
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:smartrider/data/repository/authentication_repository.dart';

// bloc stuff
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/main.dart';

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
        var prefs = state.prefs.getMapping;
        return SettingsWidget(
            bloc: BlocProvider.of<PrefsBloc>(context),
            prefs: prefs,
            auth: auth,
            setState: () => setState(() {}));
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
    Key key,
    @required PrefsBloc bloc,
    @required this.prefs,
    @required this.auth,
    @required this.setState,
  })  : _bloc = bloc,
        super(key: key);

  final PrefsBloc _bloc;
  final Map<String, bool> prefs;
  final AuthRepository auth;
  final VoidCallback setState;

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
              _bloc.add(SavePrefsEvent(prefData: prefs));
              // mapState.currentState.setPolylines();
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
                _bloc.add(SavePrefsEvent(prefData: prefs));
                // mapState.currentState.setPolylines();
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
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title: Text('Push Notifications'),
                            value: prefs['pushNotifications'],
                            onChanged: (bool value) {
                              prefs['pushNotifications'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.notifications),
                          ),
                          Builder(
                              builder: (context) => SwitchListTile(
                                    title: Text('Lights Out'),
                                    value: prefs['darkMode'],
                                    onChanged: (bool value) {
                                      prefs['darkMode'] = value;
                                      _bloc.add(ThemeChangedEvent(value));
                                      setState();
                                      final SnackBar snackbar = SnackBar(
                                          content: Text(
                                        'Press the back arrows to save your changes!',
                                        textAlign: TextAlign.center,
                                      ));
                                      Scaffold.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                    secondary:
                                        const Icon(Icons.lightbulb_outline),
                                  )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title: Text('North Route'),
                            value: prefs['NEW North Route'],
                            onChanged: (bool value) {
                              prefs['NEW North Route'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                          SwitchListTile(
                            title: Text('South Route'),
                            value: prefs['NEW South Route'],
                            onChanged: (bool value) {
                              prefs['NEW South Route'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                          SwitchListTile(
                            title: Text('West Route'),
                            value: prefs['NEW West Route'],
                            onChanged: (bool value) {
                              prefs['NEW West Route'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                          SwitchListTile(
                            title: Text('Weekend Express'),
                            value: prefs['Weekend Express'],
                            onChanged: (bool value) {
                              prefs['Weekend Express'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

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
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title: Text('87 Route'),
                            value: prefs['route87'],
                            onChanged: (bool value) {
                              prefs['route87'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.directions_bus),
                          ),
                          SwitchListTile(
                            title: Text('286 Route'),
                            value: prefs['route286'],
                            onChanged: (bool value) {
                              prefs['route286'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.directions_bus),
                          ),
                          SwitchListTile(
                            title: Text('289 Route'),
                            value: prefs['route289'],
                            onChanged: (bool value) {
                              prefs['route289'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.directions_bus),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

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
              Container(
                margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title: Text('Placeholder'),
                            value: prefs['placeholder1'],
                            onChanged: (bool value) {
                              // setState(() {
                              prefs['placeholder1'] = value;
                              setState();
                              // });
                            },
                            secondary: const Icon(Icons.local_taxi),
                          ),
                          SwitchListTile(
                            title: Text('Placeholder'),
                            value: prefs['placeholder2'],
                            onChanged: (bool value) {
                              prefs['placeholder2'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.local_taxi),
                          ),
                        ],
                      ),
                    ),
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => SmartRider()),
                            // );
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
