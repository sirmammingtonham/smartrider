class BusShape {
  int id;
  String shapeId;
  double shapePtLat;
  double shapePtLon;
  int shapePtSequence;
  Null shapeDistTraveled;

  BusShape(
      {this.id,
      this.shapeId,
      this.shapePtLat,
      this.shapePtLon,
      this.shapePtSequence,
      this.shapeDistTraveled});

  BusShape.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shapeId = json['shape_id'];
    shapePtLat = json['shape_pt_lat'];
    shapePtLon = json['shape_pt_lon'];
    shapePtSequence = json['shape_pt_sequence'];
    shapeDistTraveled = json['shape_dist_traveled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shape_id'] = this.shapeId;
    data['shape_pt_lat'] = this.shapePtLat;
    data['shape_pt_lon'] = this.shapePtLon;
    data['shape_pt_sequence'] = this.shapePtSequence;
    data['shape_dist_traveled'] = this.shapeDistTraveled;
    return data;
  }
}