import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:shared/models/bus/bus_realtime_update.dart';
import 'dart:convert';

void main() async {
  var now = DateTime.now();
  var milliseconds = now.millisecondsSinceEpoch;
  http.Response response = await http
      .get(Uri.parse('https://www.cdta.org/realtime/buses.json?$milliseconds'));
  List<BusRealtimeUpdate> updates =
      ((jsonDecode(response.body) as List).map((jsonMap) {
    return BusRealtimeUpdate.fromJson(jsonMap);
  }).toList());
  updates.forEach((element) {print(element.toJson());});
}
