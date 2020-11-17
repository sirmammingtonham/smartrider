class BusTimetable {
  final _interpolatedChar = '•'; // bullet point
  final _skipChar = '—'; // em dash

  String routeId;
  int directionId;
  String directionName;
  String label;
  String startDate;
  String endDate;
  String serviceId;

  List<String> includeDates;
  List<String> excludeDates;
  List<TimetableEntry> timetable;

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
      this.timetable});

  List<String> get timetableDisplay => timetable.map((table) {
        if (table.skipped) {
          return _skipChar;
        }
        if (table.interpolated) {
          return table.formattedTime + _interpolatedChar;
        }
        return table.formattedTime;
      }).toList();

  BusTimetable.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'];
    directionId = json['direction_id'];
    directionName = json['direction_name'];
    label = json['label'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    serviceId = json['service_id'];

    includeDates = json['include_dates'].cast<String>();
    excludeDates = json['exclude_dates'].cast<String>();

    timetable = json['timetable']
        .map((table) {
          return TimetableEntry.fromJson(table);
        })
        .toList()
        .cast<TimetableEntry>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = routeId;
    data['direction_id'] = directionId;
    data['direction_name'] = directionName;
    data['label'] = label;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['service_id'] = serviceId;

    data['include_dates'] = includeDates;
    data['exclude_dates'] = excludeDates;

    data['timetable'] = timetable;

    return data;
  }
}

class TimetableEntry {
  int arrivalTime;
  String stopId;
  String formattedTime;
  int stopSequence;
  bool interpolated;
  bool skipped;

  TimetableEntry({
    this.arrivalTime,
    this.stopId,
    this.formattedTime,
    this.stopSequence,
    this.interpolated,
    this.skipped,
  });

  TimetableEntry.fromJson(Map<String, dynamic> json) {
    arrivalTime = json['arrival_time'];
    stopId = json['stop_id'];
    formattedTime = json['formatted_time'];
    stopSequence = json['stop_sequence'];
    interpolated = json['interpolated'];
    skipped = json['skipped'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arrival_time'] = arrivalTime;
    data['stop_id'] = stopId;
    data['formatted_time'] = formattedTime;
    data['stop_sequence'] = stopSequence;
    data['interpolated'] = interpolated;
    data['skipped'] = skipped;
    return data;
  }
}
