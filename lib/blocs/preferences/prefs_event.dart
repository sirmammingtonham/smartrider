part of 'prefs_bloc.dart';

abstract class PrefsEvent extends Equatable {
  const PrefsEvent();
}

class LoadPrefsEvent extends PrefsEvent {
  const LoadPrefsEvent();

  @override
  List<Object> get props => [];
}

class SavePrefsEvent extends PrefsEvent {
  final Map<String, bool> prefData;

  Map<String, bool> get getData => prefData;

  const SavePrefsEvent({this.prefData});

  @override
  List<Object> get props => [this.prefData];
}

class ThemeChangedEvent extends PrefsEvent {
  final bool isDark;
  const ThemeChangedEvent(this.isDark);

  @override
  List<Object> get props => [this.isDark];
}
