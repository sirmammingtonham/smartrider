import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Bus route model:
/// Contains data related to individual routes
class BusRoute {
  String routeId;
  String agencyId;
  String routeShortName;
  String routeLongName;
  String routeDesc;
  int routeType;
  String routeUrl;
  String routeColor;
  String routeTextColor;
  int routeSortOrder;
  int continuousPickup;
  int continuousDropOff;

  int startDate;
  int endDate;
  Iterable<BusStopSimplified> stops;

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
    routeId = json['route_id'];
    agencyId = json['agency_id'];
    routeShortName = json['route_short_name'];
    routeLongName = json['route_long_name'];
    routeDesc = json['route_desc'];
    routeType = json['route_type'];
    routeUrl = json['route_url'];
    routeColor = json['route_color'];
    routeTextColor = json['route_text_color'];
    routeSortOrder = json['route_sort_order'];
    continuousPickup = json['continuous_pickup'];
    continuousDropOff = json['continuous_drop_off'];

    startDate = json['start_date'];
    endDate = json['end_date'];
    stops =
        json['stops'].map<BusStopSimplified>((stop) => BusStopSimplified.fromJson(stop));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = this.routeId;
    data['agency_id'] = this.agencyId;
    data['route_short_name'] = this.routeShortName;
    data['route_long_name'] = this.routeLongName;
    data['route_desc'] = this.routeDesc;
    data['route_type'] = this.routeType;
    data['route_url'] = this.routeUrl;
    data['route_color'] = this.routeColor;
    data['route_text_color'] = this.routeTextColor;
    data['route_sort_order'] = this.routeSortOrder;
    data['continuous_pickup'] = this.continuousPickup;
    data['continuous_drop_off'] = this.continuousDropOff;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['stops'] = this.stops;
    return data;
  }
}

class BusStopSimplified {
  String stopId;
  String stopName;
  double stopLat;
  double stopLon;

  BusStopSimplified({
    this.stopId,
    this.stopName,
    this.stopLat,
    this.stopLon,
  });

  LatLng get getLatLng => LatLng(this.stopLat, this.stopLon);

  BusStopSimplified.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'];

    stopName = json['stop_name'];

    stopLat = json['stop_lat'];
    stopLon = json['stop_lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_id'] = this.stopId;

    data['stop_name'] = this.stopName;

    data['stop_lat'] = this.stopLat;
    data['stop_lon'] = this.stopLon;

    return data;
  }
}
