// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/foundation.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:shared/util/messages.dart';
import 'package:shared/util/multi_bloc_builder.dart';

import 'package:smartrider/pages/profile.dart';
import 'package:smartrider/widgets/icons.dart';

// auth bloc import
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';

// import map background
import 'package:smartrider/pages/settings.dart';

// import places api
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

// import 'dart:io';
import 'package:shared/util/strings.dart';
import 'package:smartrider/pages/home.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

String computeUsername(String name) {
  //compute initials to be displayed on search bar
  var counter = 1;
  while (double.tryParse(name[name.indexOf('@') - counter]) != null) {
    counter += 1;
  }

  return (name[name.indexOf('@') - counter] + name[0]).toUpperCase();
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

late String username;
String? email;

class SearchBarState extends State<SearchBar> {
  SearchBarState();
  String? name;
  String? role;
  final places = GoogleMapsPlaces(apiKey: googleApiKey);

  @override
  void initState() {
    super.initState();
  }

  void _showAutocomplete(String message, {required bool isPickup}) async {
    // TODO: rework this to be less hardcoded...
    await showDialog<Widget>(
        context: context,
        builder: (context) {
          return Align(
            alignment: const Alignment(0, -0.98),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  elevation: 6.0,
                  child: TypeAheadField(
                    hideOnLoading: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: message)),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) {
                        return const Iterable<Prediction>.empty();
                      }
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
                        leading: const Icon(Icons.location_on),
                        title: Text(suggestion.description!),
                        // subtitle: Text('${suggestion.distanceMeters!} m
                        // away'),
                      );
                    },
                    onSuggestionSelected: (Prediction suggestion) {
                      BlocProvider.of<SaferideBloc>(context).add(isPickup
                          ? SaferideSelectingEvent(pickupPrediction: suggestion)
                          : SaferideSelectingEvent(
                              dropoffPrediction: suggestion));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget searchField(SaferideState saferideState) {
    switch (saferideState.runtimeType) {
      case SaferideNoState:
        // This only calls dateTime.now() once when everything is built
        // so if a user starts the app before 7 and is on it after 7,
        // it will not update.
        // This can be changed in the multiblocprovider, but it may be
        // inefficient
        if (kReleaseMode && DateTime.now().hour < 19) {
          return const TextField(
            enabled: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Saferide starts at 7 p.m.'),
          );
        } else {
          // creates the autocomplete field (requires strings.dart in
          // the utils folder to contain the api key)
          return TypeAheadField(
            hideOnLoading: true,
            textFieldConfiguration: const TextFieldConfiguration(
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Need a safe ride?')),
            suggestionsCallback: (pattern) async {
              if (pattern.isEmpty) {
                return const Iterable<Prediction>.empty();
              }
              return (await places.autocomplete(pattern,
                      location: Location(lat: 42.729980, lng: -73.676682),
                      radius: 1000,
                      strictbounds: true,
                      language: 'en'))
                  .predictions;
            },
            itemBuilder: (context, Prediction suggestion) {
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(suggestion.description!),
                // subtitle: Text('${suggestion.distanceMeters!} m
                // away'),
              );
            },
            onSuggestionSelected: (Prediction suggestion) {
              BlocProvider.of<SaferideBloc>(context)
                  .add(SaferideSelectingEvent(dropoffPrediction: suggestion));
            },
          );
        }
      case SaferideWaitingState:
        // TODO: add destination info to state
        // we can probably have some easter eggs or something here
        return const TextField(
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Waiting for an available driver!',
            ));
      case SaferidePickingUpState:
        return const TextField(
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Driver is on their way!',
            ));
      case SaferideDroppingOffState:
        return const TextField(
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Have a safe ride 😄',
            ));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget searchBar(SaferideState saferideState, PrefsState prefsState) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 7.5.h,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Showcase(
                  key: showcaseSettings,
                  description: settingsShowcaseMessage,
                  shapeBorder: const RoundedRectangleBorder(),
                  child: IconButton(
                    icon: const Icon(SmartriderIcons.settingsIcon),
                    onPressed: () {
                      Navigator.push<SettingsPage>(context,
                          MaterialPageRoute(builder: (context) {
                        return const SettingsPage();
                      }));
                    },
                  )),
              Showcase(
                key: showcaseSearch,
                description: searchbarShowcaseMessage,
                shapeBorder: const RoundedRectangleBorder(),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
                    child: searchField(saferideState)),
              ),
              Showcase(
                key: showcaseProfile,
                description: profileShowcaseMessage,
                shapeBorder: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).buttonColor,
                  child: IconButton(
                    icon: Text(computeUsername(name!),
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70)),
                    onPressed: () {
                      Navigator.push<ProfilePage>(
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
      );

  Widget saferideSelectionWidget(
          BuildContext context, SaferideSelectingState saferideState) =>
      Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 6.0,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              ListTile(
                leading: const SizedBox(
                  height: double.infinity,
                  child: Icon(Icons.add_location_alt_rounded),
                ),
                title: Text(saferideState.pickupDescription),
                subtitle: const Text('Pickup location'),
                onTap: () {
                  _showAutocomplete('Enter pickup address', isPickup: true);
                },
              ),
              const Divider(height: 0),
              ListTile(
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.wrong_location_rounded)),
                title: Text(saferideState.dropDescription),
                subtitle: const Text('Dropoff location'),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    BlocProvider.of<SaferideBloc>(context)
                        .add(SaferideNoEvent());
                  },
                ),
                onTap: () {
                  _showAutocomplete('Enter dropoff address', isPickup: false);
                },
              )
            ]),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: MultiBlocBuilder(
          blocs: [
            BlocProvider.of<SaferideBloc>(context),
            BlocProvider.of<AuthenticationBloc>(context),
            BlocProvider.of<PrefsBloc>(context),
          ],
          builder: (context, states) {
            final saferideState = states.get<SaferideState>();
            final authState = states.get<AuthenticationState>();
            final prefState = states.get<PrefsState>();

            name =
                authState is AuthenticationSuccess ? authState.displayName : '';
            role = authState is AuthenticationSuccess ? authState.role : '';
            switch (saferideState.runtimeType) {
              case SaferideNoState:
              case SaferideWaitingState:
              case SaferidePickingUpState:
              case SaferideDroppingOffState:
                return searchBar(saferideState, prefState);
              case SaferideSelectingState:
                return saferideSelectionWidget(
                    context, saferideState as SaferideSelectingState);
              case SaferideCancelledState:
              case SaferideErrorState:
                return const Placeholder(); //TODO: fill out these widgets
              default:
                return const Text('saferide state type error');
            }
          },
        ),
      ),
    );
  }
}
