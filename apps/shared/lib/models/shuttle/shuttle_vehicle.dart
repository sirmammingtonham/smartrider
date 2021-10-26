class ShuttleVehicle {
  ShuttleVehicle({
    this.id,
    this.name,
    this.created,
    this.updated,
    this.enabled,
    this.trackerId,
  });

  ShuttleVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    created = json['created'] as String?;
    updated = json['updated'] as String?;
    enabled = json['enabled'] as bool?;
    trackerId = json['tracker_id'] as String?;
  }

  int? id;
  String? name;
  String? created;
  String? updated;
  bool? enabled;
  String? trackerId;

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
