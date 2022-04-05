import 'package:smartrider/blocs/map/data/shuttle_repository.dart';
import 'package:test/test.dart';

void main() {
  final shuttleRepo = ShuttleRepository.create();
  group('ShuttleRepository test suite', () {
    test('Shuttle Route testing', () async {
      final _shuttleRoutes = await shuttleRepo.getRoutes;
      final routes = _shuttleRoutes.values;
      for (final route in routes) {
        expect(route.id, 'Main Route');
      }
    });

    test('Shuttle Stops testing', () async {
      final _shuttleStops = await shuttleRepo.getStops;

      final allStops = [
        'Student Union',
        'Academy Hall',
        'Polytechnic Residence Commons',
        'City Station',
        'Blitman Residence Commons',
        'West Hall',
        '’87 Gymnasium',
        'Barton Hall',
        'B-Lot',
        'East Campus Athletic Village',
        'Sunset Terrace 2',
        'Sunset Terrace 1',
        'Beman Lane',
        'The Armory',
        'Tibbits Avenue'
      ];
      final recievedStops = <String>[];
      for (final stop in _shuttleStops) {
        recievedStops.add(stop.id!);
      }
      for (final stop in allStops) {
        expect(recievedStops.contains(stop), true);
      }
    });
  });
}
