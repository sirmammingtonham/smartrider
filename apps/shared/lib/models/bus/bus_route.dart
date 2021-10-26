import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Bus route model:
/// Contains data related to individual routes
class BusRoute {
  BusRoute(
      {this.routeId,
      this.agencyId,
      this.routeShortName,
      this.routeLongName,
      this.routeDesc,
      this.routeType,
      this.routeUrl,
      this.routeColor,
      this.routeTextColor,
      this.routeSortOrder,
      this.continuousPickup,
      this.continuousDropOff,
      this.startDate,
      this.endDate,
      this.stops});

  BusRoute.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'] as String?;
    agencyId = json['agency_id'] as String?;
    routeShortName = json['route_short_name'] as String?;
    routeLongName = json['route_long_name'] as String?;
    routeDesc = json['route_desc'] as String?;
    routeType = json['route_type'] as int?;
    routeUrl = json['route_url'] as String?;
    routeColor = json['route_color'] as String?;
    routeTextColor = json['route_text_color'] as String?;
    routeSortOrder = json['route_sort_order'] as int?;
    continuousPickup = json['continuous_pickup'] as int?;
    continuousDropOff = json['continuous_drop_off'] as int?;

    startDate = json['start_date'] as int?;
    endDate = json['end_date'] as int?;
    stops = (json['stops'] as List).map<BusStopSimplified>(
      (dynamic stop) => BusStopSimplified.fromJson(
        stop as Map<String, dynamic>,
      ),
    );
  }

  String? routeId;
  String? agencyId;
  String? routeShortName;
  String? routeLongName;
  String? routeDesc;
  int? routeType;
  String? routeUrl;
  String? routeColor;
  String? routeTextColor;
  int? routeSortOrder;
  int? continuousPickup;
  int? continuousDropOff;

  int? startDate;
  int? endDate;
  Iterable<BusStopSimplified>? stops;

  List<BusStopSimplified> get forwardStops =>
      stops!.where((stop) => stop.stopSeq0 != -1).toList()
        ..sort((first, second) {
          return first.stopSeq0.compareTo(second.stopSeq0);
        });
  List<BusStopSimplified> get reverseStops =>
      stops!.where((stop) => stop.stopSeq1 != -1).toList()
        ..sort((first, second) {
          return first.stopSeq1.compareTo(second.stopSeq1);
        });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['route_id'] = routeId;
    data['agency_id'] = agencyId;
    data['route_short_name'] = routeShortName;
    data['route_long_name'] = routeLongName;
    data['route_desc'] = routeDesc;
    data['route_type'] = routeType;
    data['route_url'] = routeUrl;
    data['route_color'] = routeColor;
    data['route_text_color'] = routeTextColor;
    data['route_sort_order'] = routeSortOrder;
    data['continuous_pickup'] = continuousPickup;
    data['continuous_drop_off'] = continuousDropOff;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['stops'] = stops;
    return data;
  }
}

class BusStopSimplified {
  const BusStopSimplified(
      {required this.stopId,
      required this.stopName,
      required this.stopLat,
      required this.stopLon,
      required this.stopSeq0,
      required this.stopSeq1});

  factory BusStopSimplified.fromJson(Map<String, dynamic> json) =>
      BusStopSimplified(
        stopId: json['stop_id'] as String,
        stopName: json['stop_name'] as String,
        stopLat: json['stop_lat'] as double,
        stopLon: json['stop_lon'] as double,
        stopSeq0: json['stop_sequence_0'] as int,
        stopSeq1: json['stop_sequence_1'] as int,
      );

  final String stopId;
  final String stopName;
  final double stopLat;
  final double stopLon;
  final int stopSeq0;
  final int stopSeq1;

  LatLng get getLatLng => LatLng(stopLat, stopLon);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stop_id'] = stopId;

    data['stop_name'] = stopName;

    data['stop_lat'] = stopLat;
    data['stop_lon'] = stopLon;

    data['stop_sequence_0'] = stopSeq0;
    data['stop_sequence_1'] = stopSeq1;
    return data;
  }
}
