import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class ProfilePage extends StatefulWidget {
  final String role;
  final String email;
  final String name;
  ProfilePage(
      {this.title,
      @required this.name,
      @required this.role,
      @required this.email});
  final String title;

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ), // adds space between button and lower bezel
              Row(children: <Widget>[
                RaisedButton(
                    child: Text(
                      '< BACK',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0))),
                new Padding(
                  /// WARNING: padding should be fixed to adjust to screen width.
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                ), // adds space between button and lower bezel
                RaisedButton(
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
                        borderRadius: new BorderRadius.circular(10.0)))
              ]),
              new Padding(
                /// WARNING: padding should be fixed to adjust to screen width.
                padding: const EdgeInsets.symmetric(vertical: 40.0),
              ),

              /// FORMED TOP OF SCREEN
              new Stack(
                children: <Widget>[
                  Container(
                      color: Theme.of(context).buttonColor,
                      width: double.infinity,
                      height: 175.0,
                      child: Column(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 45.0)),
                          Center(
                              child: Text(
                            'Hello, ' + widget.role,
                            style:
                                TextStyle(color: Colors.grey[50], fontSize: 50),
                          )),
                        ],
                      )),
                  new Positioned(
                    left: 120.0,
                    bottom: 100,
                    child: CircularProfileAvatar(
                      'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
                      child: FlutterLogo(),
                      borderColor: Colors.purpleAccent,
                      borderWidth: 5,
                      elevation: 2,
                      radius: 70,
                    ),
                  ),
                ],
                overflow: Overflow.visible,
              ),

              Expanded(
                child: SizedBox(
                  height: 150,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                          title: Text("Role"),
                          subtitle: Text(widget.role),
                          leading: this.determinerole(widget.role)
                              ? Icon(Icons.book)
                              : Icon(Icons.drive_eta)),
                      ListTile(
                        title: Text("Email"),
                        leading: Icon(Icons.email),
                        subtitle: Text(widget.email),
                      )
                    ],
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ), // adds space between button and lower bezel
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 95.0),
                  child: Text(
                    'CHANGE PASSWORD',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 119.0),
                  child: Text(
                    'REPORT BUG',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Text(
                    'REQUEST FEATURE',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 102.0),
                  child: Text(
                    'DELETE ACCOUNT',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),
            ],
          ),
        ),
        theme: Theme.of(context));
  }

  determinerole(String r) {
    if (r[0] == 'S') {
      return true;
    } else
      return false;
  }
}
