import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';

import '../models/bus/bus_route.dart';
import '../models/bus/bus_shape.dart';
//import '../models/bus/bus_stop_time.dart';
import '../models/bus/bus_stop.dart';
import '../models/bus/bus_trip_update.dart';
import '../models/bus/bus_vehicle_update.dart';
import '../models/bus/bus_trip.dart';
import '../models/bus/bus_timetable.dart';


/// A provider for Bus data.
///
/// Implemented as a collection of functions that utilizes
/// a REST API to retrieve json files of bus data.
/// Each member function decodes a json file and returns
/// a dart iterable containing the relevent bus data object.
class BusProvider {

  /// The connection status of BusProvider.
  bool isConnected;

  /// Fetchs data from the JSON API and returns a decoded JSON.
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

  /// The status of the most recent [fetch] call.
  bool get getIsConnected => isConnected;

  /// Returns a [Map] of <[BusRoute.routeShortName], [BusRoute]>  pairs.
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

  /// Returns a [List] of [BusShape] objects.
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

  /// Returns a [List] of [BusStop] objects.
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

  /// Returns a [List] of [BusTripUpdate] objects.
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

  /// Returns a [List] of [BusTrip] objects.
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
  

  // Future<Map<String, List<BusStop>>> getActiveStops() async {  // map<routeId, list<busstop>>
  //   List<BusTripUpdate> updates = await this.getTripUpdatesWithParameter();
  //   List<BusStop> busStops = await this.getStops();
  //   Map<String, List<BusStop>> stopMap = new Map<String, List<BusStop>>();
  //   for (BusTripUpdate update in updates) {
  //     List<String> ids =
  //         update.tripUpdate.stopTimeUpdate.map((e) => e.stopId).toList();

  //     List<BusStop> stops =
  //         busStops.where((element) => ids.contains(element.stopId)).toList();

  //     stopMap[update.tripUpdate.trip.routeId] = stops;
  //   }

  //   return stopMap;
  // }

  /// Returns a [List] of [BusVehicleUpdate] objects.
  Future<List<BusVehicleUpdate>> getVehicleUpdates() async {
    var response = await http
        .get('http://64.128.172.149:8080/gtfsrealtime/VehiclePositions');

    Set<String> routeIds = {'87', '286', '289'};

    List<BusVehicleUpdate> vehicleUpdatesList = response != null
        ? FeedMessage.fromBuffer(response.bodyBytes)
            .entity
            .map((entity) => BusVehicleUpdate.fromPBEntity(entity))
            .where((update) => routeIds.contains(update.routeId))
            .toList()
        : [];
    return vehicleUpdatesList;
  }

  ///Returns a [Map] of <[BusStop],[BusTimeTable]>
  Future<Map<String,List<BusTimeTable>>> getBusTimeTable() async{
    var response = await fetch("busTimetable");
    Map<String,List<BusTimeTable>> retmap = {};
    Map<String, dynamic> tablemap = response != null
        ? (json.decode(response.body) as Map<String, dynamic>)
        : [];
    tablemap.forEach((key, value) {
      List<dynamic> b = value["stops"];
      List<BusTimeTable> bl = b.map((element) => BusTimeTable.fromJson(element)).toList();
      retmap[key] = bl;
    });
    return retmap;
      
  }



  /// Creates a JSON file [fileName] and stores it in a local directory.
  /// 
  /// Does nothing if [fetch] cannot establish a connection 
  Future createJSONFile(String fileName, http.Response response) async {
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      await file.writeAsString(response.body);
    }
  }
}
