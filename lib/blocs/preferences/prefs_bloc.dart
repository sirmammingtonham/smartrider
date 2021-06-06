import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  SharedPreferences? _sharedPrefs;
  late bool hideInactiveRoutes;
  Map<String?, bool?>? _shuttles;
  Map<String, bool>? _buses;

  static const Map<String, String> busIdMap = {
    '87': 'Route 87',
    '286': 'Route 286',
    '289': 'Route 289',
    '288': 'CDTA Express Shuttle',
  };

  PrefsBloc() : super(PrefsLoadingState());

  @override
  Stream<PrefsState> mapEventToState(PrefsEvent event) async* {
    switch (event.runtimeType) {
      case LoadPrefsEvent:
        {
          hideInactiveRoutes = true;
          _shuttles = {};

          // placeholders for now
          _buses = {
            '87': true,
            '286': true,
            '289': true,
            '288': true,
          };
          _sharedPrefs = await SharedPreferences.getInstance();
          if (!_sharedPrefs!.containsKey('firstTimeLoad')) {
            _sharedPrefs!.setBool('firstTimeLoad', true);
          }
          if (!_sharedPrefs!.containsKey('firstSlideUp')) {
            _sharedPrefs!.setBool('firstSlideUp', true);
          }
          if (!_sharedPrefs!.containsKey('firstLaunch')) {
            _sharedPrefs!.setBool('firstLaunch', true);
          }
          if (!_sharedPrefs!.containsKey('darkMode')) {
            _sharedPrefs!.setBool('darkMode', false);
          }
          if (!_sharedPrefs!.containsKey('pushNotifications')) {
            _sharedPrefs!.setBool('pushNotifications', true);
          }
          // modify active routes on app launch
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case SavePrefsEvent:
        {
          yield PrefsSavingState();
          _sharedPrefs!.setBool(
              (event as SavePrefsEvent).name!, event.val);
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case PrefsUpdateEvent:
        {
          yield PrefsChangedState();
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case InitActiveRoutesEvent:
        {
          if (hideInactiveRoutes) {
            hideInactiveRoutes = false;
            (event as InitActiveRoutesEvent).routes.forEach((route) {
              _shuttles![route.name] = route.active;
            });
          }
          yield PrefsChangedState();
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case OnboardingComplete:
        {
          _sharedPrefs!.setBool('firstLaunch', false);
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case ThemeChangedEvent:
        {
          yield PrefsChangedState();
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      default:
        yield PrefsErrorState(message: "something wrong with prefs_bloc");
    }
  }
}
