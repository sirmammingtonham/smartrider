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
  // final Map<String, bool> prefData;
  final String name;
  final bool val;

  const SavePrefsEvent(this.name, this.val);

  @override
  List<Object> get props => [this.name, this.val];
}

class PrefsUpdateEvent extends PrefsEvent {
  const PrefsUpdateEvent();
  
  @override
  List<Object> get props => [];
}

class InitActiveRoutesEvent extends PrefsEvent {
  final List<ShuttleRoute> routes;
  const InitActiveRoutesEvent(this.routes);

  @override
  List<Object> get props => [routes];
}

class ThemeChangedEvent extends PrefsEvent {
  final bool isDark;
  const ThemeChangedEvent(this.isDark);

  @override
  List<Object> get props => [this.isDark];
}

class OnboardingComplete extends PrefsEvent {
  const OnboardingComplete();

  @override 
  List<Object> get props => [];
}