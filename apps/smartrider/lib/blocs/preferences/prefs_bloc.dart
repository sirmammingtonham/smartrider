import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:shared/models/themes.dart';
// import 'package:flex_color_scheme/flex_color_scheme.dart';


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// model imports
import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sms_autofill/sms_autofill.dart';

part 'prefs_event.dart';
part 'prefs_state.dart';

class PrefsBloc extends Bloc<PrefsEvent, PrefsState> {
  PrefsBloc() : super(const PrefsLoadingState());

  /// ShuttleBloc named constructor
  late SharedPreferences _sharedPrefs;
  late bool hideInactiveRoutes;
  late Map<String, bool> _shuttles;
  late Map<String, bool> _buses;

  static const Map<String, String> busIdMap = {
    '87': 'Route 87',
    '286': 'Route 286',
    '289': 'Route 289',
    '288': 'CDTA Express Shuttle',
  };

  String? getCurrentOrderId() {
    return _sharedPrefs.getString('current_order');
  }

  bool? getBool(String key) {
    return _sharedPrefs.getBool(key);
  }

  void setBool(String key) {
    if (_sharedPrefs.getBool(key) == true) {
      _sharedPrefs.setBool(key, false);
    } else {
      _sharedPrefs.setBool(key, true);
    }
  }

  void setCurrentOrderId(String? id) {
    if (id == null) {
      _sharedPrefs.remove('current_order');
    } else {
      _sharedPrefs.setString('current_order', id);
    }
  }

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
          if (!_sharedPrefs.containsKey('firstTimeLoad')) {
            await _sharedPrefs.setBool('firstTimeLoad', true);
          }
          if (!_sharedPrefs.containsKey('firstSlideUp')) {
            await _sharedPrefs.setBool('firstSlideUp', true);
          }
          if (!_sharedPrefs.containsKey('firstLaunch')) {
            await _sharedPrefs.setBool('firstLaunch', true);
          }
          if (!_sharedPrefs.containsKey('darkMode')) {
            await _sharedPrefs.setBool('darkMode', false);
          }
          if (!_sharedPrefs.containsKey('pushNotifications')) {
            await _sharedPrefs.setBool('pushNotifications', true);
          }
          // modify active routes on app launch
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case SavePrefsEvent:
        {
          await _sharedPrefs.setBool(
              (event as SavePrefsEvent).name!, event.val,);
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case PrefsUpdateEvent:
        {
          yield const PrefsChangedState();
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case InitActiveRoutesEvent:
        {
          if (hideInactiveRoutes) {
            hideInactiveRoutes = false;
            for (final route in (event as InitActiveRoutesEvent).routes) {
              _shuttles[route.id!] = route.active;
            }
          }
          yield const PrefsChangedState();
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case OnboardingComplete:
        {
          await _sharedPrefs.setBool('firstLaunch', false);
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      case ThemeChangedEvent:
        {
          yield const PrefsChangedState();
          yield PrefsLoadedState(_sharedPrefs, _shuttles, _buses);
        }
        break;
      default:
        yield const PrefsErrorState(message: 'something wrong with prefs_bloc');
    }
  }
}
