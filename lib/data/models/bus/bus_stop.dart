class BusStop {
  String stopId;
  String stopCode;
  String stopName;
  Null ttsStopName;
  String stopDesc;
  double stopLat;
  double stopLon;
  String zoneId;
  String stopUrl;
  int locationType;
  Null parentStation;
  String stopTimezone;
  int wheelchairBoarding;
  Null levelId;
  Null platformCode;

  BusStop(
      {this.stopId,
      this.stopCode,
      this.stopName,
      this.ttsStopName,
      this.stopDesc,
      this.stopLat,
      this.stopLon,
      this.zoneId,
      this.stopUrl,
      this.locationType,
      this.parentStation,
      this.stopTimezone,
      this.wheelchairBoarding,
      this.levelId,
      this.platformCode});

  BusStop.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'];
    stopCode = json['stop_code'];
    stopName = json['stop_name'];
    ttsStopName = json['tts_stop_name'];
    stopDesc = json['stop_desc'];
    stopLat = json['stop_lat'];
    stopLon = json['stop_lon'];
    zoneId = json['zone_id'];
    stopUrl = json['stop_url'];
    locationType = json['location_type'];
    parentStation = json['parent_station'];
    stopTimezone = json['stop_timezone'];
    wheelchairBoarding = json['wheelchair_boarding'];
    levelId = json['level_id'];
    platformCode = json['platform_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_id'] = this.stopId;
    data['stop_code'] = this.stopCode;
    data['stop_name'] = this.stopName;
    data['tts_stop_name'] = this.ttsStopName;
    data['stop_desc'] = this.stopDesc;
    data['stop_lat'] = this.stopLat;
    data['stop_lon'] = this.stopLon;
    data['zone_id'] = this.zoneId;
    data['stop_url'] = this.stopUrl;
    data['location_type'] = this.locationType;
    data['parent_station'] = this.parentStation;
    data['stop_timezone'] = this.stopTimezone;
    data['wheelchair_boarding'] = this.wheelchairBoarding;
    data['level_id'] = this.levelId;
    data['platform_code'] = this.platformCode;
    return data;
  }
}