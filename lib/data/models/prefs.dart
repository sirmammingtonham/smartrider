class PrefsData {
  final Map<String, bool> mapping = {
    'pushNotifications': true,
    'northRoute': true,
    'southRoute': true,
    'westRoute': true,
    'weekendExpress': true,
    'route87': true,
    'route286': true,
    'route289': true,
    'placeholder1': true,
    'placeholder2': true,
  };

  Map<String, bool> get getMapping => mapping;

  PrefsData();
}
