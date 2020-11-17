import 'package:flutter/material.dart';
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Used to display the profile options.
abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

/// Represents the profile page.
class ProfilePage extends StatefulWidget {
  final String role; // What type of rider is the app user
  final String email; // The user's email
  final String name; // The user's name.
  ProfilePage(
      {this.title,
      @required this.name,
      @required this.role,
      @required this.email});
  final String title;

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

/// Represents the current state of the Profile Page
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
                        borderRadius: new BorderRadius.circular(10.0)))
              ]),

              Container(
                color: Theme.of(context).buttonColor,
                width: double.infinity,
                height: 175.0,
                child: Center(
                    child: Text(
                  'Hello, ' + widget.role,
                  style: TextStyle(color: Colors.white70, fontSize: 50),
                )),
              ),

              Expanded(
                child: SizedBox(
                  height: 150,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text("Status"),
                        subtitle: Text('online'),
                        leading: Icon(Icons.person),
                      ),
                      ListTile(
                          title: Text("Role"),
                          subtitle: Text(widget.role),
                          leading: this.determinerole(widget.role)
                              ? Icon(Icons.book)
                              : Icon(Icons.drive_eta)),
                      ListTile(
                        title: Text("email"),
                        leading: Icon(Icons.email),
                        subtitle: Text(widget.email),
                      )
                    ],
                  ),
                ),
              ),
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
                      borderRadius: new BorderRadius.circular(20.0))),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ), // adds space between button and lower bezel
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
