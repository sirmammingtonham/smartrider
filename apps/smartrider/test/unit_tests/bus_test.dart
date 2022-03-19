import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:test/test.dart';

void main() async {
  final busRepo = await BusRepository.create();
  group('BusRepository test suite', () {
    test('Routes test', () async {
      final _busRoutes = await busRepo.getRoutes;
      expect(_busRoutes.runtimeType, Map);
    });

    test('Realtime timetable test', () async {
      final _busRealtimeTimetable = await busRepo.getRealtimeTimetable;
      expect(_busRealtimeTimetable.runtimeType, Map);
    });

     test('realtime update test', () async {
      final _busRealtimeUpdate = await busRepo.getRealtimeUpdate;
      expect(_busRealtimeUpdate.runtimeType, Map);
    });



    
  });
}
