class Stop {
  final int id;
  final int lat;
  final int long;
  final String name;
  final String description;

  Stop({this.id, this.name, this.description, this.lat, this.long});

  factory Stop.fromJson(Map<String, dynamic> json) {
    return new Stop(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,

      lat: json['latitude'] as int,
      long: json['longitude'] as int,
    );
  }
}