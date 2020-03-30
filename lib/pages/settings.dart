import 'package:flutter/material.dart';
import 'home.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool configDarkMode = false, configPush = true, configTest2 = true, configTest3 = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        // first down arrow
        leading: IconButton(
          icon: Icon(Icons.arrow_downward),
          color: Theme.of(context).accentColor,
          tooltip: 'Go back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // title
        title: Text('Settings',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 32
            ),
        ),
        // second down arrow 
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_downward),
            color: Theme.of(context).accentColor,
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
                    color: Theme.of(context).accentColor,
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
                      color: Colors.white,
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
                                  value: configDarkMode,
                                  onChanged: (bool value) {
                                    setState(() {
                                      configDarkMode = value;
                                    });
                                  },
                                  secondary: const Icon(Icons.lightbulb_outline),
                                )
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
                    color: Theme.of(context).accentColor,
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
                        color: Colors.white,
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
                    color: Theme.of(context).accentColor,
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
                        color: Colors.white,
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
                      color: Theme.of(context).primaryColor,
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
          // Card 1
         
        ],
      ),
    );
  }
}