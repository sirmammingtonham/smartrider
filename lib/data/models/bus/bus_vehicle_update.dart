class BusVehicleUpdate {
  String id;
  bool isDeleted;
  Vehicle vehicle;

  BusVehicleUpdate({this.id, this.isDeleted, this.vehicle});

  BusVehicleUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDeleted = json['isDeleted'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isDeleted'] = this.isDeleted;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle.toJson();
    }
    return data;
  }
}

class Vehicle {
  Trip trip;
  Position position;
  int currentStopSequence;
  String currentStatus;
  String timestamp;
  VehicleId vehicleId;

  Vehicle(
      {this.trip,
      this.position,
      this.currentStopSequence,
      this.currentStatus,
      this.timestamp,
      this.vehicleId});

  Vehicle.fromJson(Map<String, dynamic> json) {
    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
    position = json['position'] != null
        ? new Position.fromJson(json['position'])
        : null;
    currentStopSequence = json['currentStopSequence'];
    currentStatus = json['currentStatus'];
    timestamp = json['timestamp'];
    vehicleId =
        json['vehicle'] != null ? new VehicleId.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trip != null) {
      data['trip'] = this.trip.toJson();
    }
    if (this.position != null) {
      data['position'] = this.position.toJson();
    }
    data['currentStopSequence'] = this.currentStopSequence;
    data['currentStatus'] = this.currentStatus;
    data['timestamp'] = this.timestamp;
    if (this.vehicleId != null) {
      data['vehicle'] = this.vehicleId.toJson();
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

class Position {
  double latitude;
  double longitude;

  Position({this.latitude, this.longitude});

  Position.fromJson(Map<String, dynamic> json) {
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

class VehicleId {
  String id;

  VehicleId({this.id});

  VehicleId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
