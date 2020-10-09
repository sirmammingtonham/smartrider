class BusTripUpdate {
  String id;
  bool isDeleted;
  TripUpdate tripUpdate;

  BusTripUpdate({this.id, this.isDeleted, this.tripUpdate});

  BusTripUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['isDeleted'];
    tripUpdate = json['tripUpdate'] != null
        ? new TripUpdate.fromJson(json['tripUpdate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isDeleted'] = this.isDeleted;
    if (this.tripUpdate != null) {
      data['tripUpdate'] = this.tripUpdate.toJson();
    }
    return data;
  }
}

class TripUpdate {
  Trip trip;
  List<StopTimeUpdate> stopTimeUpdate;
  Vehicle vehicle;

  TripUpdate({this.trip, this.stopTimeUpdate, this.vehicle});

  TripUpdate.fromJson(Map<String, dynamic> json) {
    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
    if (json['stopTimeUpdate'] != null) {
      stopTimeUpdate = new List<StopTimeUpdate>();
      json['stopTimeUpdate'].forEach((v) {
        stopTimeUpdate.add(new StopTimeUpdate.fromJson(v));
      });
    }
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trip != null) {
      data['trip'] = this.trip.toJson();
    }
    if (this.stopTimeUpdate != null) {
      data['stopTimeUpdate'] =
          this.stopTimeUpdate.map((v) => v.toJson()).toList();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle.toJson();
    }
    return data;
  }
}

class Trip {
  String tripId;
  String startTime;
  String startDate;
  String routeId;

  Trip({this.tripId, this.startTime, this.startDate, this.routeId});

  Trip.fromJson(Map<String, dynamic> json) {
    tripId = json['tripId'];
    startTime = json['startTime'];
    startDate = json['startDate'];
    routeId = json['routeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tripId'] = this.tripId;
    data['startTime'] = this.startTime;
    data['startDate'] = this.startDate;
    data['routeId'] = this.routeId;
    return data;
  }
}

class StopTimeUpdate {
  int stopSequence;
  Arrival arrival;
  Arrival departure;
  String stopId;
  String scheduleRelationship;

  StopTimeUpdate(
      {this.stopSequence,
      this.arrival,
      this.departure,
      this.stopId,
      this.scheduleRelationship});

  StopTimeUpdate.fromJson(Map<String, dynamic> json) {
    stopSequence = json['stopSequence'];
    arrival =
        json['arrival'] != null ? new Arrival.fromJson(json['arrival']) : null;
    departure = json['departure'] != null
        ? new Arrival.fromJson(json['departure'])
        : null;
    stopId = json['stopId'];
    scheduleRelationship = json['scheduleRelationship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stopSequence'] = this.stopSequence;
    if (this.arrival != null) {
      data['arrival'] = this.arrival.toJson();
    }
    if (this.departure != null) {
      data['departure'] = this.departure.toJson();
    }
    data['stopId'] = this.stopId;
    data['scheduleRelationship'] = this.scheduleRelationship;
    return data;
  }
}

class Arrival {
  String time;

  Arrival({this.time});

  Arrival.fromJson(Map<String, dynamic> json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    return data;
  }
}

class Vehicle {
  String id;

  Vehicle({this.id});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
