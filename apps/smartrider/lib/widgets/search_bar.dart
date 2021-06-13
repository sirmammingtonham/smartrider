// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/util/messages.dart';
import 'package:smartrider/util/multi_bloc_builder.dart';

import 'package:smartrider/pages/profile.dart';
import 'package:smartrider/widgets/icons.dart';
import 'dart:io' show Platform;

// auth bloc import
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';

// import map background
import 'package:smartrider/pages/settings.dart';

// import places api
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smartrider/widgets/destination_autocomplete.dart';

// import 'dart:io';
import 'package:smartrider/util/strings.dart';
import 'package:smartrider/pages/home.dart';
import 'package:showcaseview/showcaseview.dart';

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

late String username;
String? email;

class SearchBarState extends State<SearchBar> {
  double?
      topBarDist; // Distance between top of phone bezel & top search bar //TODO: use fraction instead of hard coded value
  String? name;
  String? role;
  final places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);
  SearchBarState();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      topBarDist = 30.0;
    } else {
      topBarDist = 45.0;
    }
  }

  void _showAutocomplete(String message, {required bool isPickup}) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: GOOGLE_API_KEY,
      hint: message,
      location: Location(
          lat: 42.729980, lng: -73.676682), // location of union as center
      radius: 1000, // 1km decent estimate of the bounds on safe ride's website
      language: "en",
      components: [Component(Component.country, "us")],
      strictbounds: true,
    );

    if (p != null) {
      if (isPickup) {
        BlocProvider.of<SaferideBloc>(context)
            .add(SaferideSelectionEvent(pickupPrediction: p));
      } else {
        BlocProvider.of<SaferideBloc>(context)
            .add(SaferideSelectionEvent(dropoffPrediction: p));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocBuilder(
      blocs: [
        BlocProvider.of<SaferideBloc>(context),
        BlocProvider.of<AuthenticationBloc>(context),
        BlocProvider.of<PrefsBloc>(context),
      ],
      builder: (context, states) {
        final saferideState = states.get<SaferideState>();
        final authState = states.get<AuthenticationState>();
        final prefState = states.get<PrefsState>();

        name = authState is AuthenticationSuccess ? authState.displayName : '';
        role = authState is AuthenticationSuccess ? authState.role : '';

        if (saferideState is SaferideSelectionState) {
          return Positioned(
              top: topBarDist,
              right: 15,
              left: 15,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                      elevation: 6.0,
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        ListTile(
                          leading: Container(
                            height: double.infinity,
                            child: Icon(Icons.my_location),
                          ),
                          title: Text(saferideState.pickupDescription!),
                          subtitle: const Text('Pickup location'),
                          onTap: () {
                            _showAutocomplete("Enter pickup address",
                                isPickup: true);
                          },
                        ),
                        Divider(height: 0),
                        ListTile(
                          leading: Container(
                              height: double.infinity,
                              child: Icon(Icons.place)),
                          title: Text(saferideState.dropDescription!),
                          subtitle: const Text('Dropoff location'),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              BlocProvider.of<SaferideBloc>(context)
                                  .add(SaferideNoEvent());
                            },
                          ),
                          onTap: () {
                            _showAutocomplete("Enter dropoff address",
                                isPickup: false);
                          },
                        )
                      ]))));
        } else if (saferideState is SaferideAcceptedState) {
          return Container();
        } else {
          return searchBar(prefState);
        }
      },
    );
  }

  Widget searchBar(PrefsState prefsState) => Positioned(
        top: topBarDist,
        right: 15,
        left: 15,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 55,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Row(
              children: <Widget>[
                Showcase(
                    key: showcaseSettings,
                    description: SETTINGS_SHOWCASE_MESSAGE,
                    shapeBorder: RoundedRectangleBorder(),
                    child: IconButton(
                      icon: Icon(SmartriderIcons.Settings),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SettingsPage();
                        }));
                      },
                    )),
                Showcase(
                  key: showcaseSearch,
                  description: SEARCHBAR_SHOWCASE_MESSAGE,
                  shapeBorder: RoundedRectangleBorder(),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 150,
                    // creates the autocomplete field (requires strings.dart in the utils folder to contain the api key)
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          // style: DefaultTextStyle.of(context)
                          //     .style
                          //     .copyWith(fontStyle: FontStyle.italic),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Need a safe ride?')),
                      suggestionsCallback: (pattern) async {
                        return (await places.autocomplete(pattern,
                                location:
                                    Location(lat: 42.729980, lng: -73.676682),
                                radius: 1000,
                                strictbounds: true,
                                language: 'en'))
                            .predictions;
                      },
                      itemBuilder: (context, Prediction suggestion) {
                        return ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text(suggestion.description!),
                          // subtitle: Text('${suggestion.distanceMeters!} m away'),
                        );
                      },
                      onSuggestionSelected: (Prediction suggestion) {
                        print(suggestion);
                      },
                    ),
                  ),
                ),
                Showcase(
                  key: showcaseProfile,
                  description: PROFILE_SHOWCASE_MESSAGE,
                  shapeBorder: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).buttonColor,
                    child: IconButton(
                      icon: Text(computeUsername(name!),
                          style:
                              TextStyle(fontSize: 15, color: Colors.white70)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      title: computeUsername(name!),
                                      name: null,
                                      role: role,
                                      email: name,
                                    )));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
