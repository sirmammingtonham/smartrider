class ShuttleRoute {
  int id;
  String name;
  String description;
  bool enabled;
  String color;
  int width;
  List<int> stopIds;
  String created;
  String updated;
  List<Points> points;
  bool active;
  List<Schedule> schedule;

  ShuttleRoute(
      {this.id,
      this.name,
      this.description,
      this.enabled,
      this.color,
      this.width,
      this.stopIds,
      this.created,
      this.updated,
      this.points,
      this.active,
      this.schedule});

  ShuttleRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    enabled = json['enabled'];
    color = json['color'];
    width = json['width'];
    stopIds = json['stop_ids'].cast<int>();
    created = json['created'];
    updated = json['updated'];
    if (json['points'] != null) {
      points = new List<Points>();
      json['points'].forEach((v) {
        points.add(new Points.fromJson(v));
      });
    }
    active = json['active'];
    if (json['schedule'] != null) {
      schedule = new List<Schedule>();
      json['schedule'].forEach((v) {
        schedule.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['enabled'] = this.enabled;
    data['color'] = this.color;
    data['width'] = this.width;
    data['stop_ids'] = this.stopIds;
    data['created'] = this.created;
    data['updated'] = this.updated;
    if (this.points != null) {
      data['points'] = this.points.map((v) => v.toJson()).toList();
    }
    data['active'] = this.active;
    if (this.schedule != null) {
      data['schedule'] = this.schedule.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Points {
  double latitude;
  double longitude;

  Points({this.latitude, this.longitude});

  Points.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Schedule {
  int id;
  int routeId;
  int startDay;
  String startTime;
  int endDay;
  String endTime;

  Schedule(
      {this.id,
      this.routeId,
      this.startDay,
      this.startTime,
      this.endDay,
      this.endTime});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeId = json['route_id'];
    startDay = json['start_day'];
    startTime = json['start_time'];
    endDay = json['end_day'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['route_id'] = this.routeId;
    data['start_day'] = this.startDay;
    data['start_time'] = this.startTime;
    data['end_day'] = this.endDay;
    data['end_time'] = this.endTime;
    return data;
  }
}