import 'dart:convert';
import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/shuttle/shuttle_route.dart';
import '../models/shuttle/shuttle_stop.dart';
import '../models/shuttle/shuttle_update.dart';



class BusProvider {
  /// Boolean to determine if the gtfs is already downloaded
  bool isDownloaded;

  /// This function will fetch the data from the JSON API and return a decoded
  Future<http.Response> fetch(String type) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client.get('https://us-central1-smartrider-4e9e8.cloudfunctions.net/$type');
      await createJSONFile('$type', response);

      if (response.statusCode == 200) {
        isDownloaded = true;
      }
    } // TODO: better error handling
    catch (error) {
      isDownloaded = false;
    }
    //print("App has polled $type API: $isConnected");
    return response;
  }

  bool get getIsDownloaded => isDownloaded;

  /// Getter method to retrieve the list of routes
  Future<Map<String, ShuttleRoute>> getBusRoutes() async {
    var response = await fetch('busroutes');
    Map<String, ShuttleRoute> routeMap = response != null
        ? Map.fromIterable(
            (json.decode(response.body) as List).where((json) => json['enabled']),
            key: (json) => json['name'],
            value: (json) => ShuttleRoute.fromJson(json))
        : {};
    // routeList.removeWhere((route) => route == null);
    return routeMap;
  }

Future<List<ShuttleStop>> getBusShapes() async {
    var response = await fetch('busshapes');

    List<ShuttleStop> shapesList = response != null
        ? json
            .decode(response.body)
            .map<ShuttleStop>((json) => ShuttleStop.fromJson(json))
            .toList()
        : [];
    return shapesList;
  }
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
