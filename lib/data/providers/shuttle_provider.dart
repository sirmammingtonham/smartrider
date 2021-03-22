// thx flutter shuttle tracker lol
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/shuttle/shuttle_route.dart';
import '../models/shuttle/shuttle_stop.dart';
import '../models/shuttle/shuttle_update.dart';
import '../models/shuttle/shuttle_eta.dart';

/// This class contains methods for providing data to Repository
class ShuttleProvider {
  /// Boolean to determine if the app is connected to network
  bool isConnected;

  /// This function will fetch the data from the JSON API and return a decoded
  Future<http.Response> fetch(String type) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client.get('https://shuttles.rpi.edu/$type');
      // await createJSONFile('$type', response);

      if (response.statusCode == 200) {
        isConnected = true;
      }
    } catch (error) {
      isConnected = false;
      print(error);
    }
    //print("App has polled $type API: $isConnected");
    return response;
  }

  bool get getIsConnected => isConnected;

  /// Getter method to retrieve the list of routes
  Future<Map<String, ShuttleRoute>> getRoutes() async {
    /// Returns a map that contains the bus id and its routes.
    ///
    /// Fetch 'routes' data from the JSON API and store in varaible 'response'.
    /// If unable to retreive data, repsonse is set to null
    /// New map is created to hold the shuttle id's and values.
    /// Create a map instance where the keys and its values are computed
    /// using a hashmap. Decode the data.
    /// Using json, the key is assigned by getting the 'name'
    /// and the value is assigned to the routes of the shuttle
    ///
    ///
    ///     return routeMap;
    var response = await fetch('routes');
    Map<String, ShuttleRoute> routeMap = response != null
        ? Map.fromIterable(
            (json.decode(response.body) as List)
                .where((json) => json['enabled']),
            key: (json) => json['name'],
            value: (json) => ShuttleRoute.fromJson(json))
        : {};

    return routeMap;
  }

  /// Getter method to retrieve the list of stops
  Future<List<ShuttleStop>> getStops() async {
    /// Returns a list of shuttle stops.
    ///
    /// Fetch 'stops' data from JSON API and store in variable 'response'
    /// If unable to retreive data, response is set equal to null.
    /// Create list to store data.
    /// Decode the data and insert values into the list.
    ///
    ///
    ///     return stopsList;
    var response = await fetch('stops');

    List<ShuttleStop> stopsList = response != null
        ? json
            .decode(response.body)
            .map<ShuttleStop>((json) => ShuttleStop.fromJson(json))
            .toList()
        : [];
    return stopsList;
  }

  /// Getter method to retrieve the list of updated shuttles
  Future<List<ShuttleUpdate>> getUpdates() async {
    /// Returns a list of shuttle updates.
    ///
    /// Fetch 'updates' data from JSON API and store in variable 'response'
    /// If unable to retreive data, response is set equal to null.
    /// Create list to store data.
    /// Decode the data and insert values into the list.
    ///
    ///
    ///     return updatesList;
    var response = await fetch('updates');

    List<ShuttleUpdate> updatesList = response != null
        ? json
            .decode(response.body)
            .map<ShuttleUpdate>((json) => ShuttleUpdate.fromJson(json))
            .toList()
        : [];
    return updatesList;
  }

  /// Getter method to retrieve the list of shuttle eta (estimated times of arrival)
  Future<List<ShuttleEta>> getEtas() async {
    /// Returns a list of shuttle eta (estimated times of arriaval).
    ///
    /// Fetch 'eta' data from JSON API and store in variable 'response'
    /// If unable to retreive data, response is set equal to null.
    /// Create empty list 'etas'
    /// Store data in a map.
    /// Decode the in the map and trasfer contents in to etas list
    ///
    ///
    ///     return etas;
    var response = await fetch('eta');
    List<ShuttleEta> etas = [];
    Map<String, dynamic> etamap = response != null
        ? (json.decode(response.body) as Map<String, dynamic>)
        : [];
    etamap.forEach((key, value) {
      etas.add(ShuttleEta.fromJson(value));
    });
    return etas;
  }

  /// Helper function to create local JSON file
  Future createJSONFile(String fileName, http.Response response) async {
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      await file.writeAsString(response.body);
    }
  }
}
