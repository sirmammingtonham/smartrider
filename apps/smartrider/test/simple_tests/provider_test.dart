import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:shared/models/bus/bus_realtime_update.dart';
import 'dart:convert';

void main() async {
const shortRouteIds = [
    '87',
    '286',
    '289',
    '288', // cdta express shuttle
  ];
   var now = DateTime.now();
    var milliseconds = now.millisecondsSinceEpoch;
  print(milliseconds);
    http.Response response = await http.get(
        Uri.parse('https://www.cdta.org/realtime/buses.json?$milliseconds'));
    Map<String, List<BusRealtimeUpdate>> updates = Map<String, List<BusRealtimeUpdate>>();
    (jsonDecode(response.body) as List).forEach((element) {
      BusRealtimeUpdate update = BusRealtimeUpdate.fromJson(element);
      if (shortRouteIds.contains(update.routeId)) {
        if(updates[update.routeId] == null){
          updates[update.routeId] = [];
        }
          updates[update.routeId]?.add(update);
      }
    });

  updates.forEach((key, value) {
    print("key:  "+key+"    "+"bearing:   "+"${value.length}");
    value.forEach((element) {
      print(element.bearing);
    });
  });
}
