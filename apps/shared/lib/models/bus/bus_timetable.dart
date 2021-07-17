import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/models/tuple.dart';

class BusTimetable {
  BusTimetable(
      {this.routeId,
      this.directionId,
      this.directionName,
      this.label,
      this.startDate,
      this.endDate,
      this.serviceId,
      this.includeDates,
      this.excludeDates,
      this.stops,
      this.formatted});

  BusTimetable.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'];
    directionId = json['direction_id'];
    directionName = json['direction_name'];
    label = json['label'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    serviceId = json['service_id'];

    includeDates = (json['include_dates'] as List).cast<String>();
    excludeDates = (json['exclude_dates'] as List).cast<String>();

    stops = (json['stops'] as List).map<TimetableStop>((dynamic table) {
      return TimetableStop.fromJson(table);
    }).toList();

    formatted = (json['formatted'] as List).cast<String>();
    timestamps = (json['timestamps'] as List).cast<int>();
  }

  String? routeId;
  int? directionId;
  String? directionName;
  String? label;
  String? startDate;
  String? endDate;
  String? serviceId;

  List<String>? includeDates;
  List<String>? excludeDates;
  List<TimetableStop>? stops;
  List<String>? formatted;
  List<int>? timestamps;

  int get numColumns => stops!.length;
  int get numRows => (formatted!.length / stops!.length).truncate();

// change time from cdta to match time format of our database
  String formatTime(String oldtime) {
    String ampm, hour, minute = 'am';
    ampm = 'am';
    final times = oldtime.split(':');
    final inthour = int.parse(times[0]);
    if (inthour >= 12) {
      ampm = 'pm';
      if (inthour > 12) {
        times[0] = (inthour - 12).toString();
      }
    }
    hour = times[0];
    minute = times[1];
    final newtime = '$hour:$minute$ampm';
    return newtime;
  }

  // both these method are (col, row)
  String getTime(int x, int y) => formatted![y * stops!.length + x];
  int getTimestamp(int x, int y) => timestamps![y * stops!.length + x];

  // set formatted time to newtime
  void setTime(int x, int y, String newtime) =>
      formatted![y * stops!.length + x] = newtime;

  // return the index of stop in stops given its id
  int getStopIndex(String stopid) {
    var def = -1;
    stops?.asMap().forEach((key, stop) {
      if (stop.stopId == stopid) def = key;
    });
    return def;
  }

  /// returns a list of [string, int] pairs, string
  /// representing a formatted time string and the int representation
  Iterable<Tuple<String, int>> getClosestTimes(int i) {
    final now = DateTime.now().hour * 3600 +
        DateTime.now().minute * 60 +
        DateTime.now().second;

    var min = 0;

    for (var j = 0; j < numRows; ++j) {
      // check if current difference is less than previous minimum
      final isLower =
          (getTimestamp(i, j) - now).abs() < (getTimestamp(i, min) - now).abs();

      if (getTimestamp(i, j) > now && isLower) {
        min = j;
      }
    }

    /// basically just checks how many times we can generate
    /// (checks if we'll run out of stops before we generate 5 closest times)
    /// might be a cleaner way to do this but this should work for now
    int offsetLength;
    if (numRows - min < 5) {
      if (numRows - min < 1) {
        offsetLength = 1;
      } else {
        offsetLength = numRows - min;
      }
    } else {
      offsetLength = 5;
    }

    return List.generate(offsetLength, (index) => index)
        .map<Tuple<String, int>>((offset) => Tuple(
            first: getTime(i, min + offset),
            second: now < getTimestamp(i, min + offset)
                ? getTimestamp(i, min + offset) - now
                : 86400 - now + getTimestamp(i, min + offset)));
  }

  /// pass in value has to be [stopID, stopTime]
  // ignore: non_constant_identifier_names
  void updateWithRealtime(Map<String, String>? realtimeMap) {
    // TO-DO update
    //  timeslots (rows), stopoffset (cols)
    if (realtimeMap != null && realtimeMap.length == numColumns) {
      realtimeMap.forEach((id, newtime) {
        final stopIndex = getStopIndex(id);
        if (stopIndex != -1) {
          final now = DateTime.now().hour * 3600 +
              DateTime.now().minute * 60 +
              DateTime.now().second;
          var min = 0;

          for (var j = 0; j < numRows; ++j) {
            // check if current difference is less than previous minimum
            final isLower = (getTimestamp(stopIndex, j) - now).abs() <
                (getTimestamp(stopIndex, min) - now).abs();

            if (getTimestamp(stopIndex, j) > now && isLower) {
              min = j;
            }
          }
          setTime(stopIndex, min, formatTime(newtime));
          // print(stopIndex.toString() + ':' + newtime);
        } else {
          print("stop doesn't exist");
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['route_id'] = routeId;
    data['direction_id'] = directionId;
    data['direction_name'] = directionName;
    data['label'] = label;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['service_id'] = serviceId;

    data['include_dates'] = includeDates;
    data['exclude_dates'] = excludeDates;

    data['stops'] = stops;

    data['formatted'] = formatted;
    data['timestamps'] = timestamps;

    return data;
  }
}

class TimetableStop {
  TimetableStop(
      {required this.stopId,
      required this.stopLat,
      required this.stopLon,
      required this.stopName});

  factory TimetableStop.fromJson(Map<String, dynamic> json) => TimetableStop(
      stopId: json['stop_id'],
      stopLat: json['stop_lat'],
      stopLon: json['stop_lon'],
      stopName: json['stop_name']);

  final String stopId;
  final double stopLat;
  final double stopLon;
  final String stopName;

  LatLng get latLng => LatLng(stopLat, stopLon);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stop_id'] = stopId;
    data['stop_lat'] = stopLat;
    data['stop_lon'] = stopLon;
    data['stop_name'] = stopName;
    return data;
  }
}
