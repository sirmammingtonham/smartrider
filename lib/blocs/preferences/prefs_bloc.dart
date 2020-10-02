import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// model imports
import 'package:smartrider/data/models/shuttle/shuttle_route.dart';

part 'prefs_event.dart';
part 'prefs_state.dart';

class PrefsBloc extends Bloc<PrefsEvent, PrefsState> {
  /// ShuttleBloc named constructor
  SharedPreferences _sharedPrefs;
  // bool hideInactiveRoutes;
  Map<String, bool> _shuttles;
  Map<String, bool> _buses;

  PrefsBloc() : super(PrefsLoadingState());

  @override
  Stream<PrefsState> mapEventToState(PrefsEvent event) async* {
    if (event is LoadPrefsEvent) {
      // hideInactiveRoutes = true;
      _shuttles = new Map();

      // placeholders for now
      _buses = {
        '87 Route': true,
        '286 Route': true,
        '289 Route': true,
      };
      _sharedPrefs = await SharedPreferences.getInstance();
      // modify active routes on app launch
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses,
          modifyActiveRoutes: true);
    } else if (event is SavePrefsEvent) {
      // yield PrefsSavingState();

      _sharedPrefs.setBool(event.name, event.val);

      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else if (event is InitActiveRoutesEvent) {
      event.routes.forEach((route) {
        _shuttles[route.name] = route.active;
      });
      // hideInactiveRoutes = false;
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else if (event is ThemeChangedEvent) {
      yield PrefsThemeChangedState();
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else {
      yield PrefsErrorState(message: "something wrong with prefs_bloc");
    }
  }
}
