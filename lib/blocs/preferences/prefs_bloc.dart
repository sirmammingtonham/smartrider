import 'package:flutter/material.dart';
import 'package:smartrider/data/models/themes.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// model imports
import 'package:smartrider/data/models/prefs.dart';

part 'prefs_event.dart';
part 'prefs_state.dart';

class PrefsBloc extends Bloc<PrefsEvent, PrefsState> {
  /// ShuttleBloc named constructor
  PrefsData _prefs;
  PrefsBloc() : super(PrefsLoadingState()) {
    _prefs = PrefsData();
  }

  _updatePrefsWeekend(SharedPreferences sharedPrefs) {
    var curDay = DateTime.now().weekday;
    if (curDay == DateTime.saturday || curDay == DateTime.sunday) {
      sharedPrefs.setBool('NEW North Route', false);
      sharedPrefs.setBool('NEW South Route', false);
      sharedPrefs.setBool('NEW West Route', false);
      sharedPrefs.setBool('Weekend Express', true);
    } else if (curDay == DateTime.monday) {
      sharedPrefs.setBool('NEW North Route', true);
      sharedPrefs.setBool('NEW South Route', true);
      sharedPrefs.setBool('NEW West Route', true);
      sharedPrefs.setBool('Weekend Express', false);
    }
  }

  @override
  Stream<PrefsState> mapEventToState(PrefsEvent event) async* {
    if (event is LoadPrefsEvent) {
      final sharedPrefs = await SharedPreferences.getInstance();
      _updatePrefsWeekend(sharedPrefs);
      _prefs.getMapping
          .updateAll((key, value) => sharedPrefs.getBool(key) ?? true);
      yield PrefsLoadedState(prefs: _prefs);
    } else if (event is SavePrefsEvent) {
      yield PrefsSavingState();
      final sharedPrefs = await SharedPreferences.getInstance();
      _prefs.mapping.forEach((key, value) {
        sharedPrefs.setBool(key, value);
      });
      _prefs.getMapping
          .updateAll((key, value) => sharedPrefs.getBool(key) ?? true);
      yield PrefsLoadedState(prefs: _prefs);
    } else if (event is ThemeChangedEvent) {
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setBool('darkMode', _prefs.getMapping['darkMode']);
      yield PrefsLoadedState(prefs: _prefs);
    } else {
      yield PrefsErrorState(message: "something wrong with prefs_bloc");
    }
  }
}
