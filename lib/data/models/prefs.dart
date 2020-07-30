import 'package:equatable/equatable.dart';

class PrefsData extends Equatable {
  final Map<String, bool> mapping = {
    'pushNotifications': true,
    'placeholder1': true,
    'placeholder2': true,
    'NEW North Route': true,
    'NEW South Route': true,
    'NEW West Route': true,
    'Weekend Express': true,
    'route87': true,
    'route286': true,
    'route289': true,
  };

  Map<String, bool> get getMapping => mapping;

  @override
  List<Object> get props => mapping.values.toList();

  List<String> get getEnabledShuttles {
    List<String> routes = [];
    mapping.forEach((key, value) {
      if (key == 'NEW North Route' ||
          key == 'NEW South Route' ||
          key == 'NEW West Route' ||
          key == 'Weekend Express') {
        if (value) {
          routes.add(key);
        }
      }
    });
    return routes;
  }

  PrefsData();
}
