class ShuttleVehicle {
  int? id;
  String? name;
  String? created;
  String? updated;
  bool? enabled;
  String? trackerId;

  ShuttleVehicle(
      {this.id,
      this.name,
      this.created,
      this.updated,
      this.enabled,
      this.trackerId});

  ShuttleVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    created = json['created'];
    updated = json['updated'];
    enabled = json['enabled'];
    trackerId = json['tracker_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created'] = created;
    data['updated'] = updated;
    data['enabled'] = enabled;
    data['tracker_id'] = trackerId;
    return data;
  }
}
