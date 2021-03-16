import '../models/saferide/order.dart';
import '../providers/saferide_provider.dart';

class SaferideRepository {
  final _saferideProvider = SaferideProvider();
  Future<void> createOrder(Order order) async =>
      _saferideProvider.createOrder(order);
}
