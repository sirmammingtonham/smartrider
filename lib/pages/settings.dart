// ui stuff
import 'package:flutter/material.dart';

// settings and login stuff
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrider/pages/login.dart';
import 'package:smartrider/services/userauth.dart';

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

  // general setting vars
  bool _darkTheme, _pushNotifications;

  // shuttle vars
  bool _northRoute, _southRoute, _westRoute, _weekendExpress;

  // bus vars
  bool _87, _286, _289;

  // safe ride vars
  bool _placeholder1, _placeholder2;

  Authsystem auth = Authsystem();

  _updateSetting(String key, bool value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool(key, value);
  }

  _restoreSettings() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState (() {
      // general setting vars
      _pushNotifications = (sharedPrefs.getBool('pushNotifications') ?? true);

      // shuttle vars
      _northRoute = (sharedPrefs.getBool('northRoute') ?? true);
      _southRoute = (sharedPrefs.getBool('southRoute') ?? true);
      _westRoute = (sharedPrefs.getBool('westRoute') ?? true);
      _weekendExpress = (sharedPrefs.getBool('weekendExpress') ?? false);

      // bus vars
      _87 = (sharedPrefs.getBool('87Route') ?? true);
      _286 = (sharedPrefs.getBool('286Route') ?? true);
      _289 = (sharedPrefs.getBool('289Route') ?? true);

      // safe ride vars
      _placeholder1 = (sharedPrefs.getBool('placeholder1') ?? true);
      _placeholder2 = (sharedPrefs.getBool('placeholder2') ?? true);
    });
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      // might have to change this so its only when they open the app for the first time on the weekend, 
      // maybe include this code somewhere else
      _updateSetting('northRoute', false);
      _updateSetting('southRoute', false);
      _updateSetting('westRoute', false);
      _updateSetting('weekendExpress', true);
    }
    _restoreSettings();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

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
        title: Text('Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32
            ),
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
        child: ListView(
          children: <Widget>[
            // GENERAL SETTINGS
            Container(
              margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Center(
                child: Text('General',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
              child:  Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10,left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title:  Text('Push Notifications'),
                            value: _pushNotifications,
                            onChanged: (bool value) {
                              setState(() {
                                _pushNotifications = value;
                              });
                              _updateSetting('pushNotifications', _pushNotifications);
                            },
                            secondary: const Icon(Icons.notifications),
                          ),
                          SwitchListTile(
                            title:  Text('Lights Out'),
                            value: _darkTheme,
                            onChanged: (val) {
                              setState(() {
                                _darkTheme = val;
                              });
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
                child: Text('Shuttle Settings',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10,left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          title:  Text('North Route'),
                          value: _northRoute,
                          onChanged: (bool value) {
                            setState(() {
                              _northRoute = value;
                            });
                            _updateSetting('northRoute', _northRoute);
                          },
                          secondary: const Icon(Icons.airport_shuttle),
                        ),
                        SwitchListTile(title:  Text('South Route'),
                          value: _southRoute,
                          onChanged: (bool value) {
                            setState(() {
                              _southRoute = value;
                            });
                            _updateSetting('southRoute', _southRoute);
                          },
                          secondary: const Icon(Icons.airport_shuttle),
                        ),
                        SwitchListTile(
                          title:  Text('West Route'),
                          value: _westRoute,
                          onChanged: (bool value) {
                            setState(() {
                              _westRoute = value;
                            });
                            _updateSetting('westRoute', _westRoute);
                          },
                          secondary: const Icon(Icons.airport_shuttle),
                        ),
                        SwitchListTile(
                          title:  Text('Weekend Express'),
                          value: _weekendExpress,
                          onChanged: (bool value) {
                            setState(() {
                              _weekendExpress = value;
                            });
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
                child: Text('Bus Settings',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10,left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          title:  Text('87 Route'),
                          value: _87,
                          onChanged: (bool value) {
                            setState(() {
                              _87 = value;
                            });
                            _updateSetting('87Route', _87);
                          },
                          secondary: const Icon(Icons.directions_bus),
                        ),
                        SwitchListTile(
                          title:  Text('286 Route'),
                          value: _286,
                          onChanged: (bool value) {
                            setState(() {
                              _286 = value;
                            });
                            _updateSetting('286Route', _286);
                          },
                          secondary: const Icon(Icons.directions_bus),
                        ),
                        SwitchListTile(
                          title:  Text('289 Route'),
                          value: _289,
                          onChanged: (bool value) {
                            setState(() {
                              _289 = value;
                            });
                            _updateSetting('289Route', _289);
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
                child: Text('Safe Ride Settings',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.only(right: 10,left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          title:  Text('Placeholder'),
                          value: _placeholder1,
                          onChanged: (bool value) {
                            setState(() {
                              _placeholder1 = value;
                            });
                            _updateSetting('placeholder1', _placeholder1);
                          },
                          secondary: const Icon(Icons.local_taxi),
                        ), 
                        SwitchListTile(
                          title:  Text('Placeholder'),
                          value: _placeholder2,
                          onChanged: (bool value) {
                            setState(() {
                              _placeholder2 = value;
                            });
                            _updateSetting('placeholder2', _placeholder2);
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
                      Navigator.push( context,
                        MaterialPageRoute(builder: (context) => Loginpage()),
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
  (value)
    ? themeNotifier.setTheme(darkTheme)
    : themeNotifier.setTheme(lightTheme);
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('darkMode', value);
}