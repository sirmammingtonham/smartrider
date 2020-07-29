// ui stuff
import 'package:flutter/material.dart';

// settings and login stuff
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrider/pages/login.dart';
import 'package:smartrider/services/userauth.dart';
import 'package:smartrider/widgets/map_ui.dart';

// bloc stuff
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';

// theme stuff
import 'package:smartrider/util/theme_notifier.dart';
import 'package:smartrider/util/theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // adding placeholder vars for now, replace these with sharedprefs!
  Map<String, bool> prefsData;

  Authsystem auth = Authsystem();

  PrefsBloc _bloc;

  @override
  void initState() {
    super.initState();
    // var now = DateTime.now();
    // if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
    // might have to change this so its only when they open the app for the first time on the weekend,
    // maybe include this code somewhere else
    // _updateSetting('northRoute', false);
    // _updateSetting('southRoute', false);
    // _updateSetting('westRoute', false);
    // _updateSetting('weekendExpress', true);
    // }
    _bloc = BlocProvider.of<PrefsBloc>(context);
    _bloc.add(LoadPrefsEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return BlocBuilder<PrefsBloc, PrefsState>(builder: (context, state) {
      if (state is PrefsLoadingState) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state is PrefsLoadedState) {
        var prefs = state.prefs.getMapping;
        return SettingsWidget(
            bloc: _bloc,
            prefs: prefs,
            themeNotifier: themeNotifier,
            auth: auth,
            setState: () => setState(() {}));
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
    @required this.themeNotifier,
    @required this.auth,
    @required this.setState,
  })  : _bloc = bloc,
        super(key: key);

  final PrefsBloc _bloc;
  final Map<String, bool> prefs;
  final ThemeNotifier themeNotifier;
  final Authsystem auth;
  final VoidCallback setState;

  @override
  Widget build(BuildContext context) {
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
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
                          SwitchListTile(
                            title: Text('Lights Out'),
                            value: _darkTheme,
                            onChanged: (val) {
                              _darkTheme = val;
                              setState();
                              onThemeChanged(val, themeNotifier);
                            },
                            secondary: const Icon(Icons.lightbulb_outline),
                          ),
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
                            value: prefs['northRoute'],
                            onChanged: (bool value) {
                              prefs['northRoute'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                          SwitchListTile(
                            title: Text('South Route'),
                            value: prefs['southRoute'],
                            onChanged: (bool value) {
                              prefs['southRoute'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                          SwitchListTile(
                            title: Text('West Route'),
                            value: prefs['westRoute'],
                            onChanged: (bool value) {
                              prefs['westRoute'] = value;
                              setState();
                            },
                            secondary: const Icon(Icons.airport_shuttle),
                          ),
                          SwitchListTile(
                            title: Text('Weekend Express'),
                            value: prefs['weekendExpress'],
                            onChanged: (bool value) {
                              prefs['weekendExpress'] = value;
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
                          onPressed: () async {
                            await auth.signout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()),
                            );
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

void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
  (value)
      ? themeNotifier.setTheme(darkTheme)
      : themeNotifier.setTheme(lightTheme);
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('darkMode', value);
}
