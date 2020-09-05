class ShuttleVehicle {
  int id;
  String name;
  String created;
  String updated;
  bool enabled;
  String trackerId;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['enabled'] = this.enabled;
    data['tracker_id'] = this.trackerId;
    return data;
  }
}
