// import 'package:shared/util/data.dart';

// import 'package:flutter/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// Future updateCollection(
//   CollectionReference firestore,
//   String root,
//   String stopId,
//   List<String> data,
//   List<double> times,
// ) async {
//   await firestore.document(root).collection('stops').document(stopId).setData({
//     'name': data[0],
//     'location': GeoPoint(double.parse(data[1]), double.parse(data[2])),
//     'stop_id': int.parse(data[3]),
//     'times': times,
//   });
// }

// double timeStringToDouble(String time) {
//   double value;
//   var t = time.replaceAll(':', '.');
//   value = double.tryParse(t.substring(0, t.length - 2));
//   if (value == null) return null;
//   if (t.endsWith('pm') && !t.startsWith('12')) {
//     value += 12.0;
//   }
//   return value;
// }

// Future parseData(CollectionReference firestore, String root,
//     List<List<String>> stopData, List<List<String>> timeData) async {
//   int count = 0;
//   for (List<String> stop in stopData) {
//     List<double> times =
//         timeData.map((row) => timeStringToDouble(row[count])).toList();
//     times.removeWhere((element) => element == null);
//     await updateCollection(firestore, root,
//         '${root}_stop_${count < 10 ? 0 : ''}$count', stop, times);
//     count++;
//   }
// }

// createShuttleRecords(CollectionReference firestore) {
//   parseData(firestore, 'route_north', north_stops, weekday_north)
//       .then((value) => print('weekday north success'));
//   parseData(firestore, 'route_south', south_stops, weekday_south)
//       .then((value) => print('weekday south success'));
//   parseData(firestore, 'route_west', west_stops, weekday_west)
//       .then((value) => print('weekday west success'));

//   parseData(firestore, 'route_weekend', weekend_express_stops, weekend_express)
//       .then((value) => print('weekend_express success'));
// }

// createBusRecords(CollectionReference firestore) {
//   parseData(firestore, 'route_87', stops_87, times_87)
//       .then((value) => print('87 success'));
//   parseData(firestore, 'route_286', stops_286, times_286)
//       .then((value) => print('286 success'));
//   parseData(firestore, 'route_289', stops_289, times_289)
//       .then((value) => print('289 success'));
// }

// // need to redo bus data, there's more time columns than there are stops for some reason...
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   createShuttleRecords(Firestore.instance.collection('schedule_shuttle'));
//   createBusRecords(Firestore.instance.collection('schedule_bus'));
// }
