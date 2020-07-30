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

  _updatePrefsWeekend() async {
    var curDay = DateTime.now().weekday;
    if (curDay == DateTime.saturday || curDay == DateTime.sunday) {
      
    }
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('NEW North Route', false);
    sharedPrefs.setBool('NEW South Route', false);
    sharedPrefs.setBool('NEW West Route', false);
    sharedPrefs.setBool('Weekend Express', true);
  }

  // probably need some backup stuff to save preferences from last weekday
  // _updatePrefsWeekday() async {
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //   sharedPrefs.setBool('NEW North Route', false);
  //   sharedPrefs.setBool('NEW South Route', false);
  //   sharedPrefs.setBool('NEW West Route', false);
  //   sharedPrefs.setBool('Weekend Express', true);
  // }

  @override
  Stream<PrefsState> mapEventToState(PrefsEvent event) async* {
    if (event is LoadPrefsEvent) {
      final sharedPrefs = await SharedPreferences.getInstance();
      _prefs.getMapping
          .updateAll((key, value) => sharedPrefs.getBool(key) ?? true);
      print(_prefs.getMapping);
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
    } else {
      yield PrefsErrorState(message: "something wrong with prefs_bloc");
    }
  }
}
