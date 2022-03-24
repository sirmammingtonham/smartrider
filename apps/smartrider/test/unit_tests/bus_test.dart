import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:test/test.dart';

import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:shared/models/bus/bus_stop.dart';
import 'package:shared/models/bus/bus_timetable.dart';

/*
Point of this test is to make sure bus_repo parses response from firestore
correctly. It doesn't test if the data in firebase is correct.
*/
void main() async {
  final testFireStore = FakeFirebaseFirestore();

  await testFireStore // add polyline info to fakefirestore
      .collection('polylines')
      .doc('87-193')
      .set(<String, dynamic>{
    'geoJSON': '''
      {"type": "LineString",
      "coordinates": [
        [45.34, 56.38],
        [34.68, 56.26]
      ],
"properties": {"route_id": "87-193"}}
    ''',
    'route_id': '87-193',
    'type': 'MultiLineString',
  });

  await testFireStore
      .collection('routes')
      .doc('87-193')
      .set(<String, dynamic>{'route_id': '87-193', 'route_short_name': '87'});
  final routes = await testFireStore
      .collection('routes')
      .where('route_short_name', whereIn: ['87']).get();
  final busRepo =
      await BusRepository.create(isTest: true, firestore: testFireStore);

  group('BusRepository test suite', () {
    test('Polyline test', () async {
      final _busPolyLines = await busRepo.getPolylines;
      expect(_busPolyLines.isNotEmpty, true);
      expect(_busPolyLines['87'].runtimeType, BusShape);
    });

    // test('Realtime timetable test', () async {
    //   final _busRealtimeTimetable = await busRepo.getRealtimeTimetable;
    //   expect(
    //       _busRealtimeTimetable.runtimeType, <String, Map<String, String>>{});
    // });

    // test('realtime update test', () async {
    //   final _busRealtimeUpdate = await busRepo.getRealtimeUpdate;
    //   expect(_busRealtimeUpdate.runtimeType, Map);
    // });
  });
}
