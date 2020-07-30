part of 'prefs_bloc.dart';

abstract class PrefsState extends Equatable {
  final PrefsData prefs;
  const PrefsState({this.prefs});

  @override
  List<Object> get props => [this.prefs];
}

/// This class represents what user will see when fetching data
class PrefsLoadingState extends PrefsState {
  const PrefsLoadingState();

  @override
  List<Object> get props => [];
}

/// This class represents what user will see when data is fetched
class PrefsLoadedState extends PrefsState {
  final PrefsData prefs;
  const PrefsLoadedState({this.prefs});

  @override
  List<Object> get props => [this.prefs];
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
