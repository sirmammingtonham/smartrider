import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

// model imports
import 'package:smartrider/data/models/shuttle/shuttle_route.dart';

part 'prefs_event.dart';
part 'prefs_state.dart';

class PrefsBloc extends Bloc<PrefsEvent, PrefsState> {
  /// ShuttleBloc named constructor
  SharedPreferences _sharedPrefs;
  bool hideInactiveRoutes;
  Map<String, bool> _shuttles;
  Map<String, bool> _buses;

  static const Map<String, String> busIdMap = {
    '87-185': 'Route 87',
    '286-185': 'Route 286',
    '289-185': 'Route 289',
    '288-185': 'CDTA Express Shuttle',
  };

  PrefsBloc() : super(PrefsLoadingState());

  @override
  Stream<PrefsState> mapEventToState(PrefsEvent event) async* {
    if (event is LoadPrefsEvent) {
      hideInactiveRoutes = true;
      _shuttles = {};

      // placeholders for now
      _buses = {
        '87-185': true,
        '286-185': true,
        '289-185': true,
        '288-185': true,
      };
      _sharedPrefs = await SharedPreferences.getInstance();

      if (!_sharedPrefs.containsKey('firstTimeLoad')) {
        _sharedPrefs.setBool('firstTimeLoad', true);
      }
      if (!_sharedPrefs.containsKey('darkMode')) {
        _sharedPrefs.setBool('darkMode', false);
      }
      if (!_sharedPrefs.containsKey('pushNotifications')) {
        _sharedPrefs.setBool('pushNotifications', true);
      }
      // modify active routes on app launch
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else if (event is SavePrefsEvent) {
      yield PrefsSavingState();
      _sharedPrefs.setBool(event.name, event.val);
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else if (event is PrefsUpdateEvent) {
      yield PrefsChangedState();
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else if (event is InitActiveRoutesEvent) {
      // hide all inactive routes if first time launching app today
      if (hideInactiveRoutes) {
        hideInactiveRoutes = false;
        event.routes.forEach((route) {
          _shuttles[route.name] = route.active;
        });
      }
      yield PrefsChangedState();
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else if (event is ThemeChangedEvent) {
      yield PrefsChangedState();
      yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
    } else {
      yield PrefsErrorState(message: "something wrong with prefs_bloc");
    }
  }
}
