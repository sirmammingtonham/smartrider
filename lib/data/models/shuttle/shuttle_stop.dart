class ShuttleStop {
  int id;
  double latitude;
  double longitude;
  String created;
  String updated;
  String name;
  String description;

  ShuttleStop(
      {this.id,
      this.latitude,
      this.longitude,
      this.created,
      this.updated,
      this.name,
      this.description});

  ShuttleStop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    created = json['created'];
    updated = json['updated'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
