// ui imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/foundation.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:shared/util/messages.dart';
import 'package:shared/util/multi_bloc_builder.dart';

import 'package:smartrider/ui/profile.dart';
import 'package:smartrider/ui/widgets/icons.dart';

// auth bloc import
import 'package:smartrider/blocs/authentication/authentication_bloc.dart';

// import map background
import 'package:smartrider/ui/settings.dart';

// import places api
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

// import 'dart:io';
import 'package:shared/util/strings.dart';
import 'package:smartrider/ui/home.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:sizer/sizer.dart';

// compute initials to be displayed on search bar
String computeInitials(String email) {
  var counter = 1;
  while (int.tryParse(email[email.indexOf('@') - counter]) != null) {
    counter += 1;
  }
  return (email[email.indexOf('@') - counter] + email[0]).toUpperCase();
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  SearchBarState();
  late String initials;
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
                            border: const UnderlineInputBorder(),
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

  Widget searchField(
    AuthenticationSignedInState authState,
    SaferideState saferideState,
  ) {
    if (!authState.phoneVerified) {
      return TextField(
          readOnly: true,
          onTap: () {
            Navigator.push<ProfilePage>(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          initials: initials,
                        )));
          },
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Verify phone to use safe ride!',
          ));
    }
    switch (saferideState.runtimeType) {
      case SaferideNoState:
        // This only calls dateTime.now() once when everything is built
        // so if a user starts the app before 7 and is on it after 7,
        // it will not update.
        // This can be changed in the multiblocprovider, but it may be
        // inefficient
        if (kReleaseMode &&
            (saferideState as SaferideNoState).serverTimeStamp != null &&
            saferideState.serverTimeStamp!.hour < 19) {
          return const TextField(
            enabled: false,
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Saferide starts at 7 p.m.'),
          );
        } else {
          // creates the autocomplete field (requires strings.dart in
          // the utils folder to contain the api key)
          return TypeAheadField(
            hideOnLoading: true,
            textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
              border: UnderlineInputBorder(),
              hintText: 'Waiting for an available driver!',
            ));
      case SaferidePickingUpState:
        return const TextField(
            enabled: false,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Driver is on their way!',
            ));
      case SaferideDroppingOffState:
        return const TextField(
            enabled: false,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Have a safe ride 😄',
            ));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget searchBar(SaferideState saferideState, PrefsState prefsState,
          AuthenticationState authState) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 75,
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
                  child: searchField(
                    authState as AuthenticationSignedInState,
                    saferideState,
                  ),
// TODO: phone verification button
                ),
              ),
              Showcase(
                key: showcaseProfile,
                description: profileShowcaseMessage,
                shapeBorder: const CircleBorder(),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push<ProfilePage>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  initials: initials,
                                )));
                  },
                  child: Hero(
                    tag: 'circleAvatar',
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
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
        padding: const EdgeInsets.only(top: 15),
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

            assert(authState is AuthenticationSignedInState);
            initials = computeInitials(
              (authState as AuthenticationSignedInState).user.email!,
            );

            switch (saferideState.runtimeType) {
              case SaferideNoState:
              case SaferideWaitingState:
              case SaferidePickingUpState:
              case SaferideDroppingOffState:
                return searchBar(saferideState, prefState, authState);
              case SaferideSelectingState:
                return saferideSelectionWidget(
                    context, saferideState as SaferideSelectingState);
              case SaferideCancelledState:
              case SaferideErrorState:
                return const Placeholder(); //TODO: fill out these widgets
              default:
                return Text('saferide state type error, '
                    'type is ${saferideState.runtimeType}');
            }
          },
        ),
      ),
    );
  }
}
