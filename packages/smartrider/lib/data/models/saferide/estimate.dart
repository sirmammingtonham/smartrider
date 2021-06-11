class Estimate {
  String? arriveAt;
  int? distance;
  int? duration;
  int? remainingDuration;
  String? startPlace;
  String? endPlace;
  Map<String, dynamic>? polyline; // update type later

  Estimate(
      {this.arriveAt,
      this.distance,
      this.duration,
      this.remainingDuration,
      this.startPlace,
      this.endPlace,
      this.polyline
      });

  Estimate.fromDocument(doc) {
    this.arriveAt = doc['arrive_at'];
    this.distance = doc['distance'];
    this.duration = doc['duration'];
    this.remainingDuration = doc['remaining_duration'];
    this.startPlace = doc['start_place'];
    this.endPlace = doc['end_place'];
    this.polyline = doc['polyline'];
  }
}