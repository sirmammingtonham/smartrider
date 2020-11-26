// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smartrider/data/providers/bus_provider.dart';
import 'package:smartrider/data/models/bus/pb/gtfs-realtime.pb.dart';
// import '../../lib/data/models/bus/gtfs-realtime.pb.dart';

void main() async {
  /// test for getDatetime()
  print('starting');
  BusProvider b = BusProvider();
  test1(b);
}

void test1(BusProvider b) async {
  var a = await b.getTripUpdates();

  a.forEach((element) {
    element.stopTimeUpdate.forEach((e) {
      print(e.toJson());
      // print(DateTime.fromMillisecondsSinceEpoch(e.arrivalTime.toInt() * 1000));
    });
  });
}
