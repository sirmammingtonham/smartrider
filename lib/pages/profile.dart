import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

abstract class ListItem {

  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}


class ProfilePage extends StatefulWidget {

  final String role;
  final String email;
  ProfilePage({this.title,@required this.role, @required this.email});
  final String title;

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: Column(
        children: <Widget>[
         Container(
           color: Theme.of(context).buttonColor,
           width:double.infinity,
           height:250.0,
           child: Center(child: Text(widget.title,style: TextStyle(color:Colors.white70,fontSize: 80),)),
         ),
         Expanded(
                    child: SizedBox(
                      height: 200,
                                          child: ListView(children: <Widget>[
             ListTile(title: Text("Status"),
             subtitle: Text('online'),leading: Icon(Icons.person),),
             ListTile(title: Text("Role"),
             subtitle: Text(widget.role),leading: this.determinerole(widget.role) ? Icon(Icons.book): Icon(Icons.drive_eta)),
             ListTile(title: Text("email"),leading: Icon(Icons.email),
             subtitle: Text(widget.email),)
           ],),
                    ),
         )
        ],
      ),
    ),theme: Theme.of(context));
  }
  determinerole(String r){
    if(r[0]=='S'){
      return true;
    }
    else return false;
  }

}