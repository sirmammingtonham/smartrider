// thx flutter shuttle tracker lol
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
//import '../models/bus/bus_stop_time.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';
import '../models/bus/bus_trip.dart';

class BusProvider {
  /// Boolean to determine if there's an error
  bool isConnected;

  /// This function will fetch the data from the JSON API and return a decoded
  Future<http.Response> fetch(String type, {Map<String, String> query}) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client.get(
          'https://us-central1-smartrider-4e9e8.cloudfunctions.net/$type',
          headers: query);
      //await createJSONFile('$type', response);

      if (response.statusCode == 200) {
        isConnected = true;
      }
    } catch (error) {
      isConnected = false;
    }
    //print("App has polled $type API: $isConnected");
    return response;
  }

  bool get getIsConnected => isConnected;

  /// Getter method to retrieve the list of routes
  Future<Map<String, BusRoute>> getRoutes() async {
    var response = await fetch('busRoutes',
        query: {'query': '{"route_id": ["87-184","286-184","289-184"]}'});

    Map<String, BusRoute> routeMap = response != null
        ? Map.fromIterable(json.decode(response.body),
            key: (json) => json['route_short_name'],
            value: (json) => BusRoute.fromJson(json))
        : {};
    return routeMap;
  }

  /// Getter method to retrieve a list of bus shapes
  Future<List<BusShape>> getShapes() async {
    var response = await fetch('busShapes');

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
    var response = await fetch('busStops',
        query: {'query': '{"route_id": ["87-184","286-184","289-184"]}'});

    List<BusStop> stopsList = response != null
        ? json
            .decode(response.body)
            .map<BusStop>((json) => BusStop.fromJson(json))
            .toList()
        : [];
    return stopsList;
  }

  /// Getter method to retrieve list of trip updates
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

  Future<List<BusTrip>> getTrip() async {
    var response = await fetch('busTrips', query: {
      'query': '{"route_id": ["87-184","286-184","289-184"]}'
    }); //trips for 87,286 and 289

    List<BusTrip> tripList = response != null
        ? json
            .decode(response.body)
            .map<BusTrip>((json) => BusTrip.fromJson(json))
            .toList()
        : [];
    return tripList;
  }

  Future<List<BusTripUpdate>> getTripUpdatesWithParameter() async {
    var response = await fetch('tripUpdates');
    List<BusTrip> trips = await this.getTrip();
    List<String> tripIDs = new List<String>();
    for (BusTrip trip in trips) {
      // add all tripid to be searched through in tripid list
      if (!tripIDs.contains(trip.tripId)) {
        tripIDs.add(trip.tripId);
      }
    }
    List<BusTripUpdate> tripUpdatesList = response != null
        ? json
            .decode(response.body)
            .where((json) =>
                tripIDs.contains(json["id"]) && json["isDeleted"] == false)
            .map<BusTripUpdate>((json) => BusTripUpdate.fromJson(json))
            .toList()
        : [];
    return tripUpdatesList;
  }

  Future<Map<String, List<BusStop>>> getActiveStops() async {  // map<routeId, list<busstop>>
    List<BusTripUpdate> updates = await this.getTripUpdatesWithParameter();
    List<BusStop> busStops = await this.getStops();
    Map<String, List<BusStop>> stopMap = new Map<String, List<BusStop>>();
    for (BusTripUpdate update in updates) {
      List<String> ids =
          update.tripUpdate.stopTimeUpdate.map((e) => e.stopId).toList();

      List<BusStop> stops =
          busStops.where((element) => ids.contains(element.stopId)).toList();

      stopMap[update.tripUpdate.trip.routeId] = stops;
    }

    return stopMap;
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

  Future createJSONFile(String fileName, http.Response response) async {
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      await file.writeAsString(response.body);
    }
  }
}
