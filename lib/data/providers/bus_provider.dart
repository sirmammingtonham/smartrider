// thx flutter shuttle tracker lol
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
//import '../models/bus/bus_stop_time.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';

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
  Future<Map<String, BusRoute>> getBusRoutes() async {
    var response = await fetch('busroutes');
    Map<String, BusRoute> routeMap = response != null
        ? Map.fromIterable(
            (json.decode(response.body) as List).where((json) => json['enabled']),
            key: (json) => json['name'],
            value: (json) => BusRoute.fromJson(json))
        : {};
    // routeList.removeWhere((route) => route == null);
    return routeMap;
  }

  /// Getter method to retrieve a list of bus shapes
  Future<List<BusShape>> getBusShapes() async {
    var response = await fetch('busshapes');

    List<BusShape> shapesList = response != null
        ? json
            .decode(response.body)
            .map<BusShape>((json) => BusShape.fromJson(json))
            .toList()
        : [];
    return shapesList;
  }


  /// Getter method to retrieve the list of stops
  Future<List<BusStop>> getStops() async {
    var response = await fetch('busStops');

    List<BusStop> stopsList = response != null
        ? json
            .decode(response.body)
            .map<BusStop>((json) => BusStop.fromJson(json))
            .toList()
        : [];
    return stopsList;
  }
  
  /// Getter method to retrive list of trip updates
  Future<List<BusTripUpdate>> getTripUpdates() async {
    var response = await fetch('tripUpdates');

    List<BusTripUpdate> tripUpdatesList = response != null
        ? json
            .decode(response.body)
            .map<BusTripUpdate>((json) => BusTripUpdate.fromJson(json))
            .toList()
        : [];
    return tripUpdatesList;
  }

  /// Getter method to retrieve list of vehicle updates
  Future<List<BusVehicleUpdate>> getVehicleUpdates() async {
    var response = await fetch('vehicleUpdates');

    List<BusVehicleUpdate> vehicleUpdatesList = response != null
        ? json
            .decode(response.body)
            .map<BusVehicleUpdate>((json) => BusVehicleUpdate.fromJson(json))
            .toList()
        : [];
    return vehicleUpdatesList;
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
