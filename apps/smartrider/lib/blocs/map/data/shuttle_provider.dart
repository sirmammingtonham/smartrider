// thx flutter shuttle tracker lol
import 'package:smartrider/blocs/map/data/http_util.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:shared/models/shuttle/shuttle_update.dart';
import 'package:shared/models/shuttle/shuttle_eta.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// This class contains methods for providing data to Repository
class ShuttleProvider {
  /// Boolean to determine if the app is connected to network
  bool isConnected = false;

  /// This function will fetch the data from the JSON API and return a decoded
  Future<List<dynamic>?> fetch(String type) async {
    final response =
        await get<List<dynamic>>(url: 'https://shuttles.rpi.edu/$type');
    isConnected = response != null;
    return response;
  }

  /// Getter method to retrieve the list of routes
  Future<Map<String, ShuttleRoute>> getRoutes() async {
    /// Returns a map that contains the bus id and its routes.
    ///
    /// Fetch 'routes' data from the JSON API and store in varaible 'response'.
    /// If unable to retreive data, repsonse is set to null New map is created
    /// to hold the shuttle id's and values. Create a map instance where the
    /// keys and its values are computed using a hashmap. Decode the data. Using
    /// json, the key is assigned by getting the 'name' and the value is
    /// assigned to the routes of the shuttle
    ///
    ///
    ///     return routeMap;
    final response = await fetch('routes');

    final routeMap = response != null
        ? <String, ShuttleRoute>{
            for (final json in response.where(
                (dynamic json) => (json as Map<String, dynamic>)['enabled']))
              (json as Map<String, dynamic>)['name']:
                  ShuttleRoute.fromJson(json)
          }
        : <String, ShuttleRoute>{};

    return routeMap;
  }

  /// Getter method to retrieve the list of stops
  Future<List<ShuttleStop>> getStops() async {
    /// Returns a list of shuttle stops.
    ///
    /// Fetch 'stops' data from JSON API and store in variable 'response' If
    /// unable to retreive data, response is set equal to null. Create list to
    /// store data. Decode the data and insert values into the list.
    ///
    ///
    ///     return stopsList;
    final response = await fetch('stops');

    final stopsList = response != null
        ? response
            .map<ShuttleStop>((dynamic json) => ShuttleStop.fromJson(json))
            .toList()
        : <ShuttleStop>[];
    return stopsList;
  }

  /// Getter method to retrieve the list of updated shuttles
  Future<List<ShuttleUpdate>> getUpdates() async {
    /// Returns a list of shuttle updates.
    ///
    /// Fetch 'updates' data from JSON API and store in variable 'response' If
    /// unable to retreive data, response is set equal to null. Create list to
    /// store data. Decode the data and insert values into the list.
    ///
    ///
    ///     return updatesList;
    final response = await fetch('updates');
    final updatesList = response != null
        ? response
            .map<ShuttleUpdate>((dynamic json) => ShuttleUpdate.fromJson(json))
            .toList()
        : <ShuttleUpdate>[];
    return updatesList;
  }

  /// Getter method to retrieve the list of shuttle eta (estimated times of
  /// arrival)
  Future<List<ShuttleEta>> getEtas() async {
    /// Returns a list of shuttle eta (estimated times of arriaval).
    ///
    /// Fetch 'eta' data from JSON API and store in variable 'response' If
    /// unable to retreive data, response is set equal to null. Create empty
    /// list 'etas' Store data in a map. Decode the in the map and trasfer
    /// contents in to etas list
    ///
    ///
    ///     return etas;
    // final response = await fetch('eta');
    final etas = <ShuttleEta>[];
    // final Map<String, dynamic> etamap = (response != null ?
    //     (response)! : <dynamic>[]) ..forEach((String key,
    //     dynamic value) {etas.add(ShuttleEta.fromJson(value));
    //       });
    return etas;
  }

  /// Helper function to create local JSON file
  // Future createJSONFile(String fileName, http.Response response) async {if
  //   (response.statusCode == 200) {final directory = await
  //   getApplicationDocumentsDirectory(); final file =
  //   File('${directory.path}/$fileName.json'); await
  //   file.writeAsString(response.body);
  //   }
  // }
}
