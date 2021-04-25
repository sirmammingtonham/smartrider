// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/pages/profile.dart';
import 'package:smartrider/widgets/icons.dart';
import 'dart:io' show Platform;

// auth bloc import
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';
// import map background
import 'package:smartrider/pages/settings.dart';

// import places api
import 'package:google_maps_webservice/places.dart';
import 'package:smartrider/widgets/autocomplete.dart';

import 'dart:io';

String computeUsername(String name) {
  //compute initials to be displayed on search bar
  var counter = 1;
  while (double.tryParse(name[name.indexOf('@') - counter]) != null)
    counter += 1;

  return (name[name.indexOf('@') - counter] + name[0]).toUpperCase();
}

class SearchBar extends StatefulWidget {
  SearchBar();
  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  String name;
  String role;

  SearchBarState();

  @override
  Widget build(BuildContext context) {
    var topBarDist; //Distance between top of phone bezel & top search bar
    if (Platform.isAndroid) {
      topBarDist = 30.0;
    } else {
      topBarDist = 45.0;
    }
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          name = state.displayName;
          role = state.role;
          return Positioned(
            top: topBarDist,
            right: 15,
            left: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: 55,
              child: Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10.0),
                elevation: 6.0,
                child: Row(
                  children: <Widget>[
                    IconButton( 
                       icon: Icon(Icons.settings,
                           color: Theme.of(context).accentColor),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          // BlocProvider.of<PrefsBloc>(context).add(LoadPrefsEvent());
                          return SettingsPage();
                        }));
                      },
                    ),
                    Expanded(
                        // creates the autocomplete field (requires strings.dart in the utils folder to contain the api key)
                        child: PlacesAutocompleteField(
                      apiKey: Platform.environment['MAPS_API_KEY'],
                      hint: "Need a Safe Ride?",
                      location: Location(
                          42.729980, -73.676682), // location of union as center
                      radius:
                          1000, // 1km from union seems to be a good estimate of the bounds on safe ride's website
                      language: "en",
                      components: [Component(Component.country, "us")],
                      strictbounds: true,
                      sessionToken: Uuid().generateV4(),
                      inputDecoration: null,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        child: IconButton(
                          icon: Text(computeUsername(name),
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          title: computeUsername(name),
                                          name: null,
                                          role: role,
                                          email: name,
                                        )));
                          },
                        ),
                        //Text('JS', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          print("something's wrong with auth bloc");
          return Positioned(
              child: Container(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
