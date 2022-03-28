import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:shared/models/bus/bus_route.dart';
import 'package:shared/models/bus/bus_shape.dart';
import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:smartrider/blocs/map/data/http_util.dart';
import 'package:test/test.dart';

/*
Point of this test is to make sure bus_repo parses response from firestore
correctly. It doesn't test if the data in firebase is correct.
*/
void main() async {
  final testFireStore = FakeFirebaseFirestore();

  await testFireStore // add polyline info for testing
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
    // add route info for testing
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

  await testFireStore.collection('stops').doc('00072').set(<String, dynamic>{
    'arrival_times': [24840],
    'departure_times': [24840],
    'level_id': null,
    'location_type': 0,
    'parent_station': null,
    'platform_code': null,
    'route_ids': ['87-193'],
    'shape_ids': ['2870157'],
    'stop_code': '00072',
    'stop_desc': null,
    'stop_id': '00072',
    'stop_lat': 42.692346,
    'stop_lon': -73.628566,
    'stop_name': 'Main Ave & Milhizer AVE',
    'stop_sequence': [40, 40],
    'stop_timezone': 'America/New_York',
    'stop_url': 'https://www.cdta.org/schedules-stop-detail?stop_id=00072',
    'trip_ids': ['8316011-JAN22-Troy-Weekday-01'],
    'tts_stop_name': null,
    'wheelchair_boarding': 1,
    'zone_id': null,
  });

  // await testFireStore.collection('polylines')
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

    test('Timetable test', () async {
      final _busRealtimeTimetable = await busRepo.getRealtimeTimetable;
      expect(_busRealtimeTimetable.isNotEmpty, true);
      expect(_busRealtimeTimetable['87'] == null, false);
      expect(_busRealtimeTimetable['286'] == null, false);
      expect(_busRealtimeTimetable['289'] == null, false);
    });

    test('Stops test', () async {
      final _busStops = await busRepo.getStops;
      expect(_busStops.isNotEmpty, true);
    });

    test('Timetable realtime test', () async {
      final _allRoutes = ['87', '286', '289'];
      int milliseconds;

      for (final route in _allRoutes) {
        milliseconds = DateTime.now().millisecondsSinceEpoch;
        var response = await get<Map<String, dynamic>>(
          url: 'https://www.cdta.org/apicache/routebus_'
              '${route}_0.json?_=$milliseconds',
        );
        expect(response == null, false);
        if (response != null) {
          for (final dynamic r in response.values) {
            expect(
              DateTime.tryParse('-123450101 ${r.toString()} Z') != null, true,
            );
          }
        }
      }
    });
  });
}
