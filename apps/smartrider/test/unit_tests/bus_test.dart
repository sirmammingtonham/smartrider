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

  await testFireStore.collection('routes').doc('87-193').set(<String, dynamic>{
    'agency_id': '1',
    'continuous_drop_off': null,
    'continuous_pickup': null,
    'direction_ids': '0,0,1',
    'end_dates': '20220610,20220610',
    'end_date': 20220611,
    'route_color': '008000',
    'route_desc':
        'Troy/Wynantskill via RPI Campus, between Downtown Troy and Wynantskill (weekdays and Saturdays)',
    'route_id': '87-193',
    'route_long_name': 'Troy/Wynantskill',
    'route_short_name': '87',
    'route_sort_order': 23,
    'route_text_color': 'FFFFFF',
    'route_type': 3,
    'route_url': 'https://www.cdta.org/schedules-route-detail?route_id=286',
    'shape_ids': '2860149,286149',
    'start_date': 20220131,
    'start_dates': '20220131,20220131',
    'stop_ids': '04394,04394',
    'stop_sequences': '16,15,14',
    'stops': [
      <String, dynamic>{
        'level_id': null,
        'location_type': 0,
        'parent_station': null,
        'platform_code': null,
        'stop_code': '10006',
        'stop_desc': null,
        'stop_id': '10006',
        'stop_lat': 42.6939,
        'stop_lon': -73.63517,
        'stop_name': 'Main Ave & Rt 150',
        'stop_sequence_0': 3,
        'stop_sequence_1': -1,
        'stop_timezone': 'America/New_York',
        'stop_url': 'https://www.cdta.org/schedules-stop-detail?stop_id=10006',
        'tts_stop_name': null,
        'wheelchair_boarding': 1,
        'zone_id': null,
      }
    ],
  });
  final busRepo =
      await BusRepository.create(isTest: true, firestore: testFireStore);

  group('BusRepository test suite', () {
    test('Polyline test', () async {
      final _busPolyLines = await busRepo.getPolylines;
      expect(_busPolyLines.isNotEmpty, true);
      expect(_busPolyLines['87'].runtimeType, BusShape);
    });

    test('Route test', () async {
      final _busRoutes = await busRepo.getRoutes;
      expect(_busRoutes.isNotEmpty, true);
      expect(_busRoutes['87'].runtimeType, BusRoute);
      expect(_busRoutes['87']?.endDate, 20220611);
      expect(
        _busRoutes['87']?.stops?.elementAt(0).runtimeType,
        BusStopSimplified,
      );
      expect(
        _busRoutes['87']?.stops?.elementAt(0).stopName,
        'Main Ave & Rt 150',
      );
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
