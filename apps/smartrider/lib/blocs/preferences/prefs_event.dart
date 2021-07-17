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
  const SavePrefsEvent(this.name, this.val);

  final String? name;
  final bool val;

  @override
  List<Object?> get props => [name, val];
}

class PrefsUpdateEvent extends PrefsEvent {
  const PrefsUpdateEvent();

  @override
  List<Object> get props => [];
}

class InitActiveRoutesEvent extends PrefsEvent {
  const InitActiveRoutesEvent(this.routes);

  final List<ShuttleRoute> routes;

  @override
  List<Object> get props => [routes];
}

class ThemeChangedEvent extends PrefsEvent {
  const ThemeChangedEvent(this.isDark);

  final bool isDark;

  @override
  List<Object> get props => [isDark];
}

class OnboardingComplete extends PrefsEvent {
  const OnboardingComplete();

  @override
  List<Object> get props => [];
}
