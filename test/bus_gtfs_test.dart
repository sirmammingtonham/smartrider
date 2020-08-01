import '../lib/data/providers/bus_provider.dart';
import 'package:flutter/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final _busProvider = BusProvider();
  _busProvider.fetch();
  print("Finished running");
}