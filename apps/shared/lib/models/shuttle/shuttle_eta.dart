class ShuttleEta {
  int? vehicleId;
  int? routeId;
  List<StopEtas>? stopEtas;
  String? updated;

  ShuttleEta({this.vehicleId, this.routeId, this.stopEtas, this.updated});

  ShuttleEta.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    routeId = json['route_id'];
    if (json['stop_etas'] != null) {
      stopEtas = [];
      json['stop_etas'].forEach((dynamic v) {
        stopEtas!.add(new StopEtas.fromJson(v));
      });
    }
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['route_id'] = this.routeId;
    if (this.stopEtas != null) {
      data['stop_etas'] = this.stopEtas!.map((v) => v.toJson()).toList();
    }
    data['updated'] = this.updated;
    return data;
  }
}

class StopEtas {
  int? stopId;
  String? eta;
  bool? arriving;

  StopEtas({this.stopId, this.eta, this.arriving});

  StopEtas.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'];
    eta = json['eta'];
    arriving = json['arriving'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_id'] = this.stopId;
    data['eta'] = this.eta;
    data['arriving'] = this.arriving;
    return data;
  }
}
