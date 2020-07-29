import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// model imports
import 'package:smartrider/data/models/prefs.dart';

part 'prefs_event.dart';
part 'prefs_state.dart';

class PrefsBloc extends Bloc<PrefsEvent, PrefsState> {
  /// ShuttleBloc named constructor
  PrefsBloc() : super(PrefsLoadingState());

  @override
  Stream<PrefsState> mapEventToState(PrefsEvent event) async* {
    if (event is LoadPrefsEvent) {
      final sharedPrefs = await SharedPreferences.getInstance();
      PrefsData prefs = PrefsData();
      prefs.getMapping.updateAll((key, value) => sharedPrefs.getBool(key) ?? true);
      yield PrefsLoadedState(prefs: prefs);
    } else if (event is SavePrefsEvent) {
      yield PrefsSavingState();
      final sharedPrefs = await SharedPreferences.getInstance();
      event.prefData.forEach((key, value) {
        sharedPrefs.setBool(key, value);
      });
      yield PrefsSavedState();
    } else {
      yield PrefsErrorState(message: "something wrong with prefs_bloc");
    }
  }
}
