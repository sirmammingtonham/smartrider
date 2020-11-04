// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';
// import '../../lib/data/models/bus/gtfs-realtime.pb.dart';

main() async {
  var response = await http
      .get('http://64.128.172.149:8080/gtfsrealtime/VehiclePositions');
  FeedMessage feed = FeedMessage.fromBuffer(response.bodyBytes);
  feed.entity.forEach((entity) {
    print(entity.vehicle.trip.routeId);
  });
}
