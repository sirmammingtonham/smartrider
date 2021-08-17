class ShuttleEta {
  ShuttleEta({this.vehicleId, this.routeId, this.stopEtas, this.updated});

  ShuttleEta.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    routeId = json['route_id'];
    if (json['stop_etas'] != null) {
      stopEtas = [];
      for (final v in json['stop_etas'] as List) {
        stopEtas!.add(StopEtas.fromJson(v));
      }
    }
    updated = json['updated'];
  }

  int? vehicleId;
  int? routeId;
  List<StopEtas>? stopEtas;
  String? updated;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['vehicle_id'] = vehicleId;
    data['route_id'] = routeId;
    if (stopEtas != null) {
      data['stop_etas'] = stopEtas!.map((v) => v.toJson()).toList();
    }
    data['updated'] = updated;
    return data;
  }
}

class StopEtas {
  StopEtas({this.stopId, this.eta, this.arriving});

  StopEtas.fromJson(Map<String, dynamic> json) {
    stopId = json['stop_id'];
    eta = json['eta'];
    arriving = json['arriving'];
  }

  int? stopId;
  String? eta;
  bool? arriving;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stop_id'] = stopId;
    data['eta'] = eta;
    data['arriving'] = arriving;
    return data;
  }
}
