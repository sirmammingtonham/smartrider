part of 'prefs_bloc.dart';

abstract class PrefsState extends Equatable {
  // final PrefsData prefs;
  const PrefsState();

  @override
  List<Object> get props => [];
}

/// This class represents what user will see when fetching data
class PrefsLoadingState extends PrefsState {
  const PrefsLoadingState();

  @override
  List<Object> get props => [];
}

/// This class represents what user will see when data is fetched
class PrefsLoadedState extends PrefsState {
  final SharedPreferences prefs;
  final Map<String, bool> shuttles;
  final Map<String, bool> buses;
  final bool modifyActiveRoutes;

  const PrefsLoadedState(this.prefs, this.shuttles, this.buses,
      {this.modifyActiveRoutes: false});

  ThemeData get theme => prefs.getBool('darkMode') ? darkTheme : lightTheme;

  bool get firstLaunch => prefs.getBool('firstLaunch');

  @override
  List<Object> get props => [
        this.shuttles,
        this.buses,
        this.modifyActiveRoutes,
        this.prefs.getBool('pushNotifications'),
        this.prefs.getBool('darkMode'),
        this.prefs.getBool('firstLaunch')
      ];
}

// used only to notify global theme update on change
class PrefsChangedState extends PrefsState {
  const PrefsChangedState();
}

/// This class represents what user will see when fetching data
class PrefsSavingState extends PrefsState {
  const PrefsSavingState();

  @override
  List<Object> get props => [];
}

// This class represents what user will see when there is an error
class PrefsErrorState extends PrefsState {
  final String message;
  const PrefsErrorState({this.message});

  @override
  List<Object> get props => [message];
}
