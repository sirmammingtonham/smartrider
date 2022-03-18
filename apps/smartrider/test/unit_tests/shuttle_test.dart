import 'package:smartrider/blocs/map/data/shuttle_repository.dart';
import 'package:test/test.dart';
void main() {
  final shuttleRepo = ShuttleRepository.create();
  group('ShuttleRepository test suite', () {
    test('', () async {
      final _shuttleRoutes = await shuttleRepo.getRoutes;
      
    });

    
  });
}
