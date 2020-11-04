class BusTimeTable {
  String routeId;
  String stopName;
  String serviceId;
  double stopLat;
  double stopLon;
  int stopSequence;
  List<String> stopTimes;

  BusTimeTable(
      {this.routeId,
      this.stopName,
      this.serviceId,
      this.stopLat,
      this.stopLon,
      this.stopSequence,
      this.stopTimes});

  BusTimeTable.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'];
    stopName = json['stop_name'];
    serviceId = json['service_id'];
    stopLat = json['stop_lat'];
    stopLon = json['stop_lon'];
    stopSequence = json['stop_sequence'];
    stopTimes = json['stop_times'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = this.routeId;
    data['stop_name'] = this.stopName;
    data['service_id'] = this.serviceId;
    data['stop_lat'] = this.stopLat;
    data['stop_lon'] = this.stopLon;
    data['stop_sequence'] = this.stopSequence;
    data['stop_times'] = this.stopTimes;
    return data;
  }
}