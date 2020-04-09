import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// theme stuff
import 'package:smartrider/util/theme_notifier.dart';
import 'package:smartrider/util/theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool configDarkMode = false, configPush = true, configTest2 = true, configTest3 = true;
  var _darkTheme = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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

      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          ListView(
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
                                  title:  Text('Push Notifications',
                                  ),
                                  value: configPush,
                                  onChanged: (bool value) {
                                    setState(() {
                                      configPush = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.notifications),
                                ),
                                SwitchListTile(
                                  title:  Text('Lights Out',
                                  ),
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
                                    title:  Text('Placeholder',
                                    ),
                                    value: configTest2,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configTest2 = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
                                  ),
                                  SwitchListTile(
                                    title:  Text('Placeholder',
                                    ),
                                    value: configTest3,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configTest3 = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
                                  ),
                                  SwitchListTile(
                                    title:  Text('Placeholder',
                                    ),
                                    value: configTest2,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configTest2 = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
                                  ),
                                  SwitchListTile(
                                    title:  Text('Placeholder',
                                    ),
                                    value: configTest3,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configTest3 = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
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
                                    title:  Text('Dark Mode',
                                    ),
                                    value: configDarkMode,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configDarkMode = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
                                  ), SwitchListTile(
                                    title:  Text('Dark Mode',
                                    ),
                                    value: configDarkMode,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configDarkMode = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
                                  ),
                                   SwitchListTile(
                                    title:  Text('Dark Mode',
                                    ),
                                    value: configDarkMode,
                                    onChanged: (bool value) {
                                      setState(() {
                                        configDarkMode = value;
                                      });
                                    },
                                    secondary: const Icon(Icons.lightbulb_outline),
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
                        style: Theme.of(context).textTheme.button,),
                      onPressed: () {
                        print('pressed');
                      },
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))
                    ),
                ),
              ],
            ),
          )
              ],
            ),
        ],
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