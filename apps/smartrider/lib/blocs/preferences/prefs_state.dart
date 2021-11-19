part of 'prefs_bloc.dart';

abstract class PrefsState extends Equatable {
  // final PrefsData prefs;
  const PrefsState();

  @override
  List<Object?> get props => [];
}

/// This class represents what user will see when fetching data
class PrefsLoadingState extends PrefsState {
  const PrefsLoadingState();

  @override
  List<Object> get props => [];
}

/// This class represents what user will see when data is fetched
class PrefsLoadedState extends PrefsState {
  const PrefsLoadedState(this.prefs, this.shuttles, this.buses,
      {this.modifyActiveRoutes = false,});

  final SharedPreferences prefs;
  final Map<String, bool> shuttles;
  final Map<String, bool> buses;
  final bool modifyActiveRoutes;

  // ThemeData get theme => prefs.getBool('darkMode')! ? FlexScheme.brandBlue : lightTheme;

  bool? get firstLaunch => prefs.getBool('firstLaunch');

  @override
  List<Object?> get props => [
        shuttles,
        buses,
        modifyActiveRoutes,
        prefs.getBool('pushNotifications'),
        prefs.getBool('darkMode'),
        prefs.getBool('firstLaunch')
      ];
}

// used only to notify global theme update on change
class PrefsChangedState extends PrefsState {
  const PrefsChangedState();
}

// This class represents what user will see when there is an error
class PrefsErrorState extends PrefsState {
  const PrefsErrorState({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}
