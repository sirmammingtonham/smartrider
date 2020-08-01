// // ui imports
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
// import 'package:smartrider/widgets/icons.dart';

// // import map background
// import 'package:smartrider/pages/settings.dart';

// // import places api
// import 'package:google_maps_webservice/places.dart';
// import 'package:smartrider/widgets/autocomplete.dart';
// import 'package:smartrider/util/strings.dart';

// class SearchBar extends StatefulWidget {
//   const SearchBar();

//   @override
//   State<StatefulWidget> createState() => SearchBarState();
// }

// class SearchBarState extends State<SearchBar> {
//   SearchBarState();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 30,
//       right: 15,
//       left: 15,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10.0),
//         height: 50,
//         child: Material(
//           borderRadius: BorderRadius.circular(10.0),
//           elevation: 5.0,
//           child: Row(
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(SR_Icons.Settings),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     // BlocProvider.of<PrefsBloc>(context).add(LoadPrefsEvent());
//                     return SettingsPage();
//                   }));
//                 },
//               ),
//               Expanded(
//                   // creates the autocomplete field (requires strings.dart in the utils folder to contain the api key)
//                   child: PlacesAutocompleteField(
//                 apiKey: google_api_key,
//                 hint: "Need a Safe Ride?",
//                 location: Location(
//                     42.729980, -73.676682), // location of union as center
//                 radius:
//                     1000, // 1km from union seems to be a good estimate of the bounds on safe ride's website
//                 language: "en",
//                 components: [Component(Component.country, "us")],
//                 strictbounds: true,
//                 sessionToken: Uuid().generateV4(),
//                 inputDecoration: null,
//               )),
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: CircleAvatar(
//                   backgroundColor: Theme.of(context).buttonColor,
//                   child: Text('JS', style: TextStyle(color: Colors.white70)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
