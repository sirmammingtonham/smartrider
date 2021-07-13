import 'package:http/http.dart' as http;
//import 'package:collection/collection.dart';
// import 'package:shared/models/bus/bus_realtime_update.dart';
import 'dart:convert';
// import 'package:intl/intl.dart';

// import 'package:smartrider/data/repositories/bus_repository.dart';
void main() async {
  // BusRepository busRepo = await BusRepository.create();

  // const shortRouteIds = [
  //   '87',
  //   '286',
  //   '289',
  //   '288', // cdta express shuttle
  // ];
  // var now = DateTime.now();
  // var milliseconds = now.millisecondsSinceEpoch;
  // print(milliseconds);
  // http.Response response = await http
  //     .get(Uri.parse('https://www.cdta.org/realtime/buses.json?$milliseconds'));
  // Map<String, List<BusRealtimeUpdate>> updates =
  //     Map<String, List<BusRealtimeUpdate>>();
  // (jsonDecode(response.body) as List).forEach((element) {
  //   BusRealtimeUpdate update = BusRealtimeUpdate.fromJson(element);
  //   if (shortRouteIds.contains(update.routeId)) {
  //     if (updates[update.routeId] == null) {
  //       updates[update.routeId] = [];
  //     }
  //     updates[update.routeId]?.add(update);
  //   }
  // });

  // updates.forEach((key, value) {
  //   print("key:  " + key + "    " + "bearing:   " + "${value.length}");
  //   value.forEach((element) {
  //     print(element.bearing);
  //   });
  // });
  //  List<String> defaultRoutes = busRepo.getDefaultRoutes;
  //     defaultRoutes.forEach((routeId) {
  //       // updates[routeId]?.forEach((element) {
  //       //   print(int.parse(element.bearing));
  //       // });
  //       print(routeId);
  //     });

  // final now = DateTime.now();
  // final milliseconds = now.millisecondsSinceEpoch;
  // http.Response response = await http.get(Uri.parse(
  //     'https://www.cdta.org/apicache/routebus_87_0.json?_=$milliseconds'));
  // Map<String, String> data = (jsonDecode(response.body) as Map<String, dynamic>).map((key, value) {
  //    return MapEntry(key, (value as String));
  //    });
  // data.forEach((key, value) {
  //   print(key + "<--key  value-->" + value);
  // });
  const shortRouteIds = [
    '87',
    '286',
    '289',
    '288', // cdta express shuttle
  ];
  final now = DateTime.now();
  final milliseconds = now.millisecondsSinceEpoch;
  Map<String, Map<String, String>> ret = new Map();
  for (String route in shortRouteIds) {
    http.Response response = await http.get(Uri.parse(
        'https://www.cdta.org/apicache/routebus_${route}_0.json?_=$milliseconds'));
    if (response.statusCode == 200) {
      Map<String, String> data =
          (jsonDecode(response.body) as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, (value as String));
      });
      ret[route] = data;
    } else {
      print(route + "not available");
    }
  }
  print(ret.toString());

  // DateTime date= DateFormat.Hm().parse("21:45");
  // String d = DateFormat.Hm().format(date);
  // print(d);
}
