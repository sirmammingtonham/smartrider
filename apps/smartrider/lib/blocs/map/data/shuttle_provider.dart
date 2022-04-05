// thx flutter shuttle tracker lol
import 'package:shared/models/shuttle/shuttle_eta.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:shared/models/shuttle/shuttle_route.dart';
import 'package:shared/models/shuttle/shuttle_stop.dart';
import 'package:shared/models/shuttle/shuttle_update.dart';
import 'package:shared/models/shuttle/shuttle_announcement.dart';
import 'package:smartrider/blocs/map/data/http_util.dart';
import 'package:smartrider/ui/widgets/shuttle_schedules/shuttle_announcements.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// This class contains methods for providing data to Repository
class ShuttleProvider {
  /// Boolean to determine if the app is connected to network
  bool isConnected = false;

  /// This function will fetch the data from the JSON API and return a decoded
  Future<List<dynamic>?> fetch(String type) async {
    final response =
        await get<List<dynamic>>(url: 'https://shuttletracker.app/$type');
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

    // Set stopIds for route
    final temp = await getStops();
    final stops = temp.map((e) => e.name).toList();
    final routeList = <ShuttleRoute>[];
    for (final json in response!) {
      routeList.add(ShuttleRoute.fromJson(json as Map<String, dynamic>, stops));
    }
    final routeMap = response != null
        ? <String, ShuttleRoute>{
            for (final route in routeList) route.id!: route
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
            .map<ShuttleStop>(
              (dynamic json) =>
                  ShuttleStop.fromJson(json as Map<String, dynamic>),
            )
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
    final response = await fetch('buses');
    final updatesList = response != null
        ? response
            .map<ShuttleUpdate>(
              (dynamic json) =>
                  ShuttleUpdate.fromJson(json as Map<String, dynamic>),
            )
            .toList()
        : <ShuttleUpdate>[];
    return updatesList;
  }

  Future<List<ShuttleAnnouncement>> getAnnouncements() async {
    /// Returns a list of announcement based on their start+end dates
    /// based on schedule type
    final response = await fetch('announcements');
    final announcementsList = response != null
        ? response
            .map<ShuttleAnnouncement>(
            (dynamic json) =>
                ShuttleAnnouncement.fromJson(json as Map<String, dynamic>),
          )
            .where((announcement) {
            final endDate = DateTime.parse(announcement.end.toString());
            final startDate = DateTime.parse(announcement.start.toString());
            final today = DateTime.now();
            switch (announcement.scheduleType) {
              case 'startOnly':
                return startDate.isBefore(today) ||
                    startDate.isAtSameMomentAs(today);
              case 'endOnly':
                return endDate.isAfter(today);
              case 'startAndEnd':
                return (startDate.isBefore(today) ||
                        startDate.isAtSameMomentAs(today)) &&
                    endDate.isAfter(today);
              default:
                return true;
            }
          }).toList()
        : <ShuttleAnnouncement>[];
    return announcementsList;
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
